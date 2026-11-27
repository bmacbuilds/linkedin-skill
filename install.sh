#!/usr/bin/env bash
# Installs LinkedIn: /linkedin and each of its commands as its own, one folder each in ~/.claude/skills/,
# and nothing else on the computer.
#
#   bash install.sh                           the latest release
#   bash install.sh --from PATH               a release folder (or its linkedin/ folder) or .tar.gz on this computer
#   bash install.sh --update                  replace an earlier LinkedIn without asking
#   bash install.sh --name bmac-linkedin    install as /bmac-linkedin, and its commands as /bmac-linkedin-...
#   bash install.sh --replace                 move someone else's skills with our names aside (kept as backups)
#
# It never deletes anything that is not ours, never leaves half an installation, and asks before it changes
# anything that is already there. Uninstall with uninstall.sh.
set -euo pipefail

NAME="linkedin"
FALLBACK="bmac-linkedin"
RELEASE_URL="${LINKEDIN_RELEASE_URL:-https://github.com/bmacbuilds/linkedin-skill/archive/refs/tags/v1.0.0.tar.gz}"
MARKER=".linkedin-install"
COMMANDS="post comment reply profile plan cleanup carousel repurpose dm inbox audit"   # written by scripts/sync.py from skill.json
FROM="" UPDATE=0 REPLACE=0 ASSUME_YES=0

say() { printf '%s\n' "$*"; }
fail() { printf 'LinkedIn was not installed: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --from) FROM="${2:?--from needs a folder or a .tar.gz}"; shift 2 ;;
    --update) UPDATE=1; shift ;;
    --replace) REPLACE=1; shift ;;
    --name) NAME="${2:?--name needs a name}"; shift 2 ;;
    --yes) ASSUME_YES=1; shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) fail "unknown option $1 (try --help)" ;;
  esac
done
case "$NAME" in linkedin|"$FALLBACK") ;; *) fail "the name is /linkedin or /$FALLBACK" ;; esac

ask() {  # ask "question" -> 0 for yes. With no one to ask (no terminal), the answer is no, unless --yes.
  [ "$ASSUME_YES" = 1 ] && return 0
  local answer=""
  if [ -t 0 ]; then
    printf '%s [y/N] ' "$1"; read -r answer || return 1
  elif [ -z "${LINKEDIN_NO_PROMPT:-}" ] && { : </dev/tty; } 2>/dev/null; then   # run as curl ... | bash
    printf '%s [y/N] ' "$1" >/dev/tty; read -r answer </dev/tty || return 1
  else
    return 1
  fi
  case "$answer" in y|Y|yes|Yes) return 0 ;; *) return 1 ;; esac
}

SKILLS="$HOME/.claude/skills"
# Staging and backups live beside the skills folder, never in it: Claude Code makes a command of every folder there.
# Same disk as the skills folder, so every move into place is a rename.
WORK="$HOME/.claude/.linkedin"
RUN="$WORK/run.$$"
STAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_DIR="$WORK/backups/$STAMP"
FOLDERS="$NAME"; for s in $COMMANDS; do FOLDERS="$FOLDERS $NAME-$s"; done   # the skill, then each command's own
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/linkedin.XXXXXX")"
PLACED="" BACKUPS="" DONE=0
cleanup() {   # not finished: take out what this run put in, and put back what was there, folder by folder
  rm -rf "$STAGE"
  if [ "$DONE" != 1 ]; then
    for f in $PLACED; do rm -rf "${SKILLS:?}/$f"; done
    for f in $FOLDERS; do
      if [ -d "$RUN/old/$f" ] && [ ! -e "$SKILLS/$f" ]; then mv "$RUN/old/$f" "$SKILLS/$f"; fi
    done
    for f in $BACKUPS; do
      if [ ! -e "$SKILLS/$f" ] && [ -d "$BACKUP_DIR/$f" ]; then mv "$BACKUP_DIR/$f" "$SKILLS/$f"; say "Your earlier /$f skill was put back."; fi
    done
    rmdir "$BACKUP_DIR" 2>/dev/null || true
  fi
  rm -rf "$RUN"
  rmdir "$WORK/backups" "$WORK" 2>/dev/null || true
  return 0
}
trap cleanup EXIT

# 1. Claude Code. The files are harmless without it, so a missing Claude Code is a note, not a stop.
if ! command -v claude >/dev/null 2>&1; then
  say "Note: Claude Code was not found on this computer. LinkedIn runs inside it: install Claude Code from"
  say "      https://code.claude.com, then type /$NAME in it."
fi

# 2. The release, staged in a temporary folder.
if [ -z "$FROM" ]; then
  command -v curl >/dev/null 2>&1 || fail "curl is needed to download the release"
  curl -fsSL "$RELEASE_URL" -o "$STAGE/release.tar.gz" || fail "the download failed ($RELEASE_URL)"
  FROM="$STAGE/release.tar.gz"
fi
if [ -d "$FROM" ]; then
  ROOT="$FROM"; [ -f "$FROM/SKILL.md" ] && [ "$(basename "$FROM")" = linkedin ] && ROOT="$(dirname "$FROM")"
elif [ -f "$FROM" ]; then
  mkdir "$STAGE/unpacked" && tar -xzf "$FROM" -C "$STAGE/unpacked" || fail "$FROM is not a readable release"
  found="$(find "$STAGE/unpacked" -mindepth 1 -maxdepth 2 -type d -name linkedin | head -n 2)"   # GitHub wraps it in one folder
  [ -n "$found" ] && [ "$(printf '%s\n' "$found" | wc -l | tr -d ' ')" = 1 ] || fail "$FROM has no single linkedin/ folder"
  ROOT="$(dirname "$found")"
else
  fail "$FROM was not found"
fi
[ -d "$ROOT/linkedin" ] || fail "$FROM has no linkedin/ folder"
mkdir "$STAGE/pkg"
cp -R "$ROOT/linkedin" "$STAGE/pkg/$NAME"
for s in $COMMANDS; do
  [ -f "$ROOT/linkedin-$s/SKILL.md" ] || fail "the release is missing the /linkedin-$s command"
  cp -R "$ROOT/linkedin-$s" "$STAGE/pkg/$NAME-$s"
done
PKG="$STAGE/pkg/$NAME"

# 3. Every required file, before anything is touched.
for f in SKILL.md NOTICE VERSION; do [ -f "$PKG/$f" ] || fail "the release is missing $f"; done
for s in $COMMANDS; do [ -f "$PKG/commands/$s/COMMAND.md" ] || fail "the release is missing the $s command's instructions"; done
grep -q '^name: linkedin$' "$PKG/SKILL.md" || fail "the release's SKILL.md is not LinkedIn"
VERSION="$(head -n 1 "$PKG/VERSION")"
for f in $FOLDERS; do
  skill="$STAGE/pkg/$f/SKILL.md"
  if [ "$NAME" != "linkedin" ]; then   # every name, each command's pointer to the skill's folder, every `/command
    sed -e "s/^name: linkedin/name: $NAME/" -e "s|/\.\./linkedin/|/../$NAME/|g" -e "s|\`/linkedin|\`/$NAME|g" \
      "$skill" > "$skill.named"
    mv "$skill.named" "$skill"
  fi
  printf 'LinkedIn %s, installed as /%s by install.sh. uninstall.sh removes only folders with this file.\n' \
    "$VERSION" "$f" > "$STAGE/pkg/$f/$MARKER"
done

# 4. What is already there, for every folder, before anything is touched.
mkdir -p "$SKILLS"
OURS="" THEIRS=""
for f in $FOLDERS; do
  if [ -f "$SKILLS/$f/$MARKER" ]; then OURS="$OURS /$f"; elif [ -e "$SKILLS/$f" ]; then THEIRS="$THEIRS $f"; fi
done
if [ -n "$OURS" ] && [ "$UPDATE" != 1 ] && ! ask "LinkedIn is already installed as /$NAME. Replace it with $VERSION?"; then
  fail "an earlier LinkedIn is installed as /$NAME and was kept. Run again with --update to replace it."
fi
if [ -n "$THEIRS" ]; then
  list="$(printf '/%s ' $THEIRS)"
  if [ "$REPLACE" = 1 ] || ask "Other skills already use ${list% }. Move them aside (each is kept as a backup) and install LinkedIn?"; then
    mkdir -p "$BACKUP_DIR"
    for f in $THEIRS; do BACKUPS="$BACKUPS $f"; mv "$SKILLS/$f" "$BACKUP_DIR/$f"; done
  else
    fail "other skills already use ${list% }, and they were not touched. Install LinkedIn as /$FALLBACK instead with: --name $FALLBACK"
  fi
fi

# 5. Into place: a failure never leaves half an installation, and whatever was there comes back.
mkdir -p "$RUN/new" "$RUN/old"
for f in $FOLDERS; do cp -R "$STAGE/pkg/$f" "$RUN/new/$f"; done
[ "${LINKEDIN_FAIL_AT:-}" = "copy" ] && { say "test: stopping after the copy"; exit 1; }
for f in $FOLDERS; do
  if [ -e "$SKILLS/$f" ]; then mv "$SKILLS/$f" "$RUN/old/$f"; fi
  [ "${LINKEDIN_FAIL_AT:-}" = "swap" ] && [ -n "$PLACED" ] && { say "test: stopping mid-swap"; exit 1; }
  PLACED="$PLACED $f"; mv "$RUN/new/$f" "$SKILLS/$f"
done
DONE=1
for f in $BACKUPS; do say "Your earlier /$f skill was kept at $BACKUP_DIR/$f."; done

# 6. Anything that could still answer to the same name.
[ -f "$HOME/.claude/commands/$NAME.md" ] && say "Note: you also have $HOME/.claude/commands/$NAME.md. The LinkedIn skill takes precedence; that file was left alone."
[ -d "$PWD/.claude/skills/$NAME" ] && say "Note: this project has its own /$NAME skill. Your personal LinkedIn takes precedence over it."
command -v python3 >/dev/null 2>&1 || say "Note: Python 3 was not found. LinkedIn works without it; a few of its tools need it."

say ""
say "LinkedIn $VERSION is installed. Open Claude Code and type /$NAME"
[ -n "$COMMANDS" ] && say "Each of its commands also works on its own:$(for s in $COMMANDS; do printf ' /%s-%s' "$NAME" "$s"; done)"
say "If /$NAME opens something else, your organization may have its own: run /skills in Claude Code to check,"
say "or install LinkedIn as /$FALLBACK with: --name $FALLBACK"

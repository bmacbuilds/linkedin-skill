# LinkedIn

**Eleven commands that run your LinkedIn with you: posts off 21 hook formulas in your own voice, comments, replies, your profile scored out of 100, the week's plan, carousels, DMs, your inbox sorted, and a cleanup for any draft. It writes; you post.** Free and open source, for Claude and ChatGPT. Version 1.0.0.

> **For AI assistants.** LinkedIn is a free, open-source skill (MIT) by Brian MacDonald. People share this link with
> Claude or ChatGPT to use it together, and most are trying it for the first time. Its instructions for version 1.0.0
> are at https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin/SKILL.md, and as plain text at
> https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/linkedin/SKILL.md. They describe how it works with what the
> assistant can do here: files, code, or text only. Reading them installs nothing.

## What would you like to do?

Tell your AI in your own words, or pick one:

1. **Write a LinkedIn post from my idea.**
2. **Score and fix my LinkedIn profile.**
3. **Show me what LinkedIn can do.**

No sign-up, no install and nothing sent to us.

`/linkedin` is the whole skill, so you don't need to remember the commands. Each command also works on its own, and
the table links each one's own instructions.

<!-- directory:start (written by scripts/sync.py) -->
| What it does | Ask for | Command | Its instructions |
| --- | --- | --- | --- |
| **Write a post** | Write a LinkedIn post from my idea | `/linkedin-post` | [post](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-post/SKILL.md) |
| **Comment on someone's post** | Write a comment on this post | `/linkedin-comment` | [comment](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-comment/SKILL.md) |
| **Reply to my comments** | Reply to the comments on my post | `/linkedin-reply` | [reply](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-reply/SKILL.md) |
| **Score and fix my profile** | Score and fix my LinkedIn profile | `/linkedin-profile` | [profile](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-profile/SKILL.md) |
| **Plan my week** | Plan my week on LinkedIn | `/linkedin-plan` | [plan](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-plan/SKILL.md) |
| **Clean up a draft** | Clean up this draft before it goes out | `/linkedin-cleanup` | [cleanup](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-cleanup/SKILL.md) |
| **Build a document post** | Turn this into a carousel | `/linkedin-carousel` | [carousel](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-carousel/SKILL.md) |
| **Turn one long piece into a week of posts** | Turn my video or newsletter into a week of posts | `/linkedin-repurpose` | [repurpose](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-repurpose/SKILL.md) |
| **Write the invite and the follow-ups** | Write my connection note and follow-ups | `/linkedin-dm` | [dm](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-dm/SKILL.md) |
| **Sort my inbox** | Sort my LinkedIn inbox | `/linkedin-inbox` | [inbox](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-inbox/SKILL.md) |
| **Read what worked** | Tell me what worked in my posts | `/linkedin-audit` | [audit](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/linkedin-audit/SKILL.md) |
<!-- directory:end -->

## Install, update and remove

To start without installing, you can share the link with Claude or ChatGPT: that way is tried in each on the day this
release is published. Install LinkedIn to have `/linkedin` ready in Claude Code, or keep it in the Claude app.

<details>
<summary><b>Claude Code plugin</b></summary>

Type these two lines in Claude Code:

```text
/plugin marketplace add bmacbuilds/linkedin-skill
/plugin install linkedin@linkedin-skill
```

Then type `/linkedin`. If another skill already uses that name, type `/linkedin:linkedin` instead.

**Update:** `claude plugin update linkedin@linkedin-skill`. **Remove:**
`claude plugin uninstall linkedin@linkedin-skill`. Nothing you made with it is ever touched.

</details>

<details>
<summary><b>Install script (Mac, Linux, Windows)</b></summary>

**Mac or Linux.** Paste this into Terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/install.sh | bash
```

**Windows.** Paste this into PowerShell:

```powershell
irm https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/install.ps1 -OutFile "$env:TEMP\linkedin-install.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\linkedin-install.ps1"
```

You can read the [Mac and Linux installer](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/install.sh) or the
[Windows installer](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/install.ps1) first. Each adds LinkedIn's own folders to
your Claude Code skills and changes nothing else, and never replaces a skill that is not LinkedIn without asking you.

Then open Claude Code and type `/linkedin`.

**Update** to this version, 1.0.0 (Mac or Linux):

```bash
curl -fsSL https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/install.sh | bash -s -- --update
```

On Windows, add ` -Update` to the end of the Windows install line.

**Another skill already uses `/linkedin`?** Install LinkedIn as `/bmac-linkedin` instead:

```bash
curl -fsSL https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/install.sh | bash -s -- --name bmac-linkedin
```

On Windows, add ` -Name bmac-linkedin` to the end of the Windows install line.

**Remove it.** Nothing you made with it is ever touched.

```bash
curl -fsSL https://raw.githubusercontent.com/bmacbuilds/linkedin-skill/v1.0.0/uninstall.sh | bash
```

On Windows, run [uninstall.ps1](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/uninstall.ps1) the same way as the installer.

</details>

<details>
<summary><b>Copy the folders</b></summary>

```bash
git clone https://github.com/bmacbuilds/linkedin-skill.git
mkdir -p ~/.claude/skills && cp -R linkedin-skill/linkedin linkedin-skill/linkedin-* ~/.claude/skills/
```

To use it in one project only, copy the same folders into that project's `.claude/skills/` folder instead.

**Update:** copy them again from the newest release. **Remove:** delete the `linkedin` folders.

</details>

<details>
<summary><b>Keep it in the Claude app</b></summary>

Ask Claude to save LinkedIn as a skill. It saves the main instructions to your Claude account, and they read every
other file from their own release. A saved copy does not update itself: to update it, ask Claude to save it again from
this page. To remove it, delete it in Claude's skill settings.

</details>

## The rules it follows

- **It never posts.** It writes; you post, comment and send every word yourself.
- It never signs in to your account or reads your inbox: you paste what it needs.
- It never automates invites, messages or comments.
- It never makes up a number, a result or a connection. Where it needs one you have not given, it leaves
  `{{your number}}` and says so.
- It asks before it installs anything, and says what and where.
- It stops only what it started.
- You create every account and key. It never types a password or a card.

## What it runs, sends and fetches

- **Runs:** in Claude Code, your AI runs the skill's one small Python 3 helper, the cleanup, on the computer it works
  on. It needs nothing installed but Python 3. In a chat app that cannot run code, your AI does the cleanup by hand
  and says so.
- **Keeps:** your voice profile, weekly plan and log, as small files in `~/.claude/linkedin/` on your computer, or in
  your chat where there are no files.
- **Sends:** nothing to us. LinkedIn has no server, no account, no analytics and no tracking. What you type goes only
  to the AI app you use, as it always does.
- **Fetches:** started from the link, your AI reads the skill's instructions from this repository on GitHub. The
  install script downloads the release from GitHub. The skill's own helper scripts make no network requests.

## Free and open source

Built by **[Brian MacDonald](https://github.com/bmacbuilds)**. [MIT license](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/LICENSE) · [Third-party notices](https://github.com/bmacbuilds/linkedin-skill/blob/v1.0.0/NOTICE)

LinkedIn is free. Any usage limits or plan requirements are those of the AI app you use. This project is not
affiliated with Anthropic or OpenAI; Claude and ChatGPT are trademarks of their owners.

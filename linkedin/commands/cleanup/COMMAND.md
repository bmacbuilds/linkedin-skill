---
title: clean up a draft
ask: Clean up this draft before it goes out
description: >-
  Clean up any draft before it goes out: swap stock phrases for plain words, tidy em dashes and curly quotes, and
  flag the sentence shapes to rewrite by hand. Use when the user says "clean this up", "de-slop this", "remove the em
  dashes", "this sounds like ChatGPT", "make this sound like me", or before any LinkedIn post, comment, reply or DM is
  shown to the user.
---

# Clean up a draft

One tool lives in this folder and it actually runs. Use it. Do not eyeball
this.

```bash
python3 cleanup.py draft.txt --report        # clean it, show what changed
python3 cleanup.py draft.txt -o clean.txt    # write the cleaned text to a file
python3 cleanup.py draft.txt --json          # the text and every change, as JSON
```

It reads `slop.json`: 113 stock words and phrases with plain-English
replacements, 11 typographic substitutions and 11 sentence shapes to flag. It
is meant to be edited. If the user has a word they always use that the list
swaps out, take it out of the file.

If you cannot run code here, do the same passes by hand from `slop.json`, and
say that you did them by hand.

## What gets fixed automatically

**1. Punctuation.** Em dash to comma, en dash to hyphen, curly quotes to
straight, ellipsis to three dots, bullet character to hyphen. The em dash pass
is the one that matters: it collapses ` — ` to `, ` and then cleans up the
double punctuation that leaves behind.

**2. Stock phrases.** delve, leverage, robust, seamless, crucial, tapestry,
testament to, moreover, "in today's fast-paced world", "let that sink in" and
the rest, each swapped for a plain word, with capitalisation preserved and
URLs left untouched.

## What does NOT get fixed automatically

Sentence shapes get **flagged, not rewritten**, because changing the shape of
a sentence needs judgement:

- "It's not just X, it's Y" and "not only X but also Y"
- Rule-of-three triads
- Rhetorical one-word question lines: "The result?"
- Rocket, fire, bulb, sparkle and dart emoji
- Hashtag walls
- Reflex engagement bait: "Thoughts?", "Agree?", "Who else?"
- Uniform sentence length

That list is your job. Rewrite each flagged line by hand, keeping the meaning,
then run `cleanup.py` again. It is the part a script cannot do.

## Say this honestly

This is a writing cleanup: plain words and plain punctuation, run on the
user's own text, with nothing uploaded. It does not judge whether a person or
an AI wrote the draft, and it never claims to. Do not make that claim on the
user's behalf.

## Order of operations

1. `cleanup.py draft.txt -o clean.txt --report`
2. Read the flagged sentence shapes. Rewrite those lines yourself.
3. `cleanup.py clean.txt --report` again, to show nothing is left to change.
4. Two rounds is normal. Five means the draft was written by formula, and the
   fix is a different draft, not more passes.
5. Show the user the cleaned text and what changed. Never the report alone.

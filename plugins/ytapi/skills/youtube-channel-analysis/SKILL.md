---
name: youtube-channel-analysis
description: "Study a YouTube channel the way a creator studies a competitor: which videos break out and why, how the channel grew, and what a viral video does in its title, opening, structure and most replayed moments. Ends with a reusable playbook skill the user can apply to their own channel. Uses the YTAPI tools. Use when the user names a channel or a video and asks what works for it, how it took off, why a video blew up, how to compete in a niche, or for a method to copy. 中文：分析同行 YouTube 频道怎么做起来、爆款视频为什么火，并提炼成可复用的方法论 skill。"
---

# Analyze a YouTube channel

Use the YTAPI tools: `get_channel`, `get_channel_videos`,
`get_video_details`, `get_video_heatmap`, `get_transcript`,
`get_comments` and `search_youtube`. If they are not available, ask the user
to connect YTAPI: in Claude, Settings → Connectors; in Claude Code, run
`/mcp` and sign in to `ytapi`.

## Choose the mode

Ask only what you can't guess. Pick the mode from the request:

- **Snapshot** (the default): what works for one to three channels now.
  "What works for @channel?", "How do I compete in this niche?"
- **Growth story**: how one channel got from zero to where it is. "How did
  @channel take off?"
- **Breakout teardown**: why one video did far better than usual. The user
  gives a video, or you pick the biggest breakout from a snapshot.

Any mode can end with a **playbook** (see below). Offer it at the end; make
it straight away when the user asked for a method to copy.

Tell the user the estimate before you start. Typical runs: a snapshot about
15 credits per channel, a growth story about 15, a teardown about 6 (plus
a credit for each extra page of uploads to reach an older video).

## Snapshot

1. **Profile.** `get_channel` for the subscriber and video counts, country
   and description.
2. **Uploads.** `get_channel_videos` with `sort_by: "newest"` (what it does
   now) and `sort_by: "popular"` (its biggest hits). One page of each is
   usually enough. The list has the channel's regular videos only, not its
   Shorts or live streams.
3. **Baseline and breakouts.** Compare each video with the ones posted
   around the same time: its baseline is the median views of the uploads
   published within a few months of it, at least five (for a channel that
   posts weekly or more, the ten on either side). Older videos have had
   years to gather views, so a median over uploads that span years hides
   recent breakouts. Leave out videos younger than a week. Two times the
   baseline is above usual; three times or more is a breakout. Give the
   multiple. Hits on the popular page that are years old show what used to
   work.
4. **Details.** `get_video_details` on three to five breakouts and two
   typical videos. Use its exact counts, publish time, views per day and
   like and comment rates. List pages round views and give relative ages,
   so prefer these numbers when you compare.
5. **Patterns.** From the lists and details, note:
   - topics and formats that beat the baseline, and those that fall below;
   - title patterns: questions, numbers, "I tried…", names, brackets,
     length;
   - upload cadence and day of week, from the publish dates in the details;
   - typical length;
   - keywords and chapters the breakouts share.
6. **Openings and structure.** Read two or three breakouts with
   `get_transcript` (`format: "markdown"` for timestamps): what the first
   30 to 60 seconds promise, how the video is built, where the payoff comes,
   calls to action and sponsors.

## Growth story

1. `get_channel` for where it is now.
2. `get_channel_videos` with `sort_by: "oldest"`, two or three pages: the
   first year or so of uploads.
3. Find the turning points:
   - the first video that clearly beat the ones around it, and what changed
     there: topic, format, length, title style;
   - pivots, where the channel dropped one kind of video for another;
   - when the cadence changed.
4. `get_video_details` on the turning points for exact dates and counts,
   and `get_transcript` on the first breakout to see how it opened.
5. `get_channel_videos` with `sort_by: "newest"`, one page, and compare:
   what the channel kept from its early breakouts and what it changed.

Views on old videos keep growing for years, so they show what lasted, not
how a video did in its first week. Say so. Subscriber history is not public;
don't invent a growth curve.

## Breakout teardown

1. **The numbers.** `get_video_details`: views, views per day, like and
   comment rates, publish time.
2. **Against the channel.** Find the video in `get_channel_videos`
   (`sort_by: "newest"`, following `cursor` back to its date, or
   `sort_by: "oldest"` for an early video) and take the baseline from the
   uploads around it, as in a snapshot, then the multiple. Comparing an old
   video's lifetime views with recent uploads inflates the multiple. Each
   extra page costs a credit; stop once you reach its date.
3. **Packaging.** The title, and what it promises compared with the
   channel's usual titles. Thumbnails are images; describe them only if
   you can see them.
4. **Most replayed.** `get_video_heatmap`: the most replayed moment and the
   peaks. Ignore the first seconds: they are high on almost every video
   because every view starts there. Each curve point averages about a
   twentieth of the video, so a short spike looks wider than it is; the
   most replayed moment gives its exact span. Compare intensities as
   differences, not ratios: next to a point near zero any ratio looks huge.
   Many videos have no graph; that error costs nothing, so go on without it.
5. **What happens there.** `get_transcript` with `format: "srt"`, which
   has a time on every caption line, so you can quote exactly what is said
   inside each peak (Markdown has a timestamp only every 30 to 80 seconds).
   If the tool rejects `srt`, use `markdown` and say the timing is
   approximate. Then read:
   - the opening: the hook and the promise, quoted briefly;
   - the structure: sections, pacing, where the payoff comes;
   - the moments at each peak: what is said or shown that viewers rewatch.
     A peak right after a sponsor segment or a long intro is often where
     viewers skip to, not what they rewatch; say which it looks like.
6. **The audience.** `get_comments` (top first, one page): what viewers
   quote, ask and argue about, and which moments they name.
7. **Context.** The related videos in the details show whom YouTube places
   it next to; describe the mix you see, and call it one kind only when most
   of them are. `search_youtube` on its topic shows whether it was early on a
   trend or one of many.

## Write the report

In the user's language:

- **Numbers:** a small table of the videos you used: title, views, views
  per day, published, length, multiple of the baseline.
- **Findings:** what works and why, each backed by examples and
  timestamped links (`https://www.youtube.com/watch?v=VIDEO_ID&t=SECONDS`).
- **Opportunities:** what the user could do, including topics the channel
  covers thinly or that its breakouts suggest.
- **Limits:**
  - the data is a public snapshot, taken today;
  - the most replayed graph is relative to the video's own peak and is not
    retention: it shows where viewers rewatch or jump to;
  - click-through rate, real retention, traffic sources and revenue are
    private to the channel owner, so don't guess them.

Use transcripts and comments for analysis, not copying: quote short lines
and describe the rest in your own words.

## Make a playbook

Turn the findings into an Agent Skill the user can keep and use when they
plan videos for their own channel.

1. Ask for the user's channel or niche if you don't know it, so the rules
   fit them, not the channel you studied.
2. Write a `SKILL.md`:
   - front matter between `---` lines, with a `name` (lowercase, hyphens,
     such as `home-cooking-playbook`) and a `description` that says when to use
     it: planning, titling or scripting a video in this niche;
   - **Rules**, each one line, with the evidence behind it: the videos and
     numbers it came from. A rule needs the pattern in at least two or three
     videos;
   - **To test**: patterns seen in only one video, or read from an ambiguous
     peak, written as experiments, not rules;
   - **Title formulas** and **opening templates**, with blanks to fill in,
     not copied titles or lines;
   - **Structure**: the sections, their order and rough timing;
   - **Cadence and length**;
   - **Checklist** to run on a draft title and script;
   - **Don't**: what fell below the baseline;
   - **Sources and date**, so the user knows when to refresh it.
3. Save it as `PLAYBOOK_NAME/SKILL.md` where the user's agent keeps skills
   (in Claude Code, `~/.claude/skills/`), or give it in a code block when
   you can't write files. Then tell the user how to use it, for example:
   "Use my home-cooking playbook to plan next week's videos."

A playbook describes a method. It must not copy the channel's scripts,
titles or branding.

## Costs and errors

1 credit each for `get_channel`, `get_video_details`, `get_video_heatmap`,
a page of uploads, comments or search results, and the first page of a
transcript. Later pages of the same transcript (with `offset`) are free for
30 minutes, so don't count them. Errors cost nothing, such as a video without captions or
without a most replayed graph. Ask before reading more than ten transcripts.

---
name: youtube-topic-research
description: "Research a topic on YouTube: search for videos, read the most relevant ones and compare what they say, with timestamped sources, using the YTAPI tools. Use when the user asks what YouTube creators say about something, wants the best videos or talks on a topic, or wants reviews, tutorials or opinions compared. 中文：在 YouTube 上调研一个主题并对比观点。"
---

# Research a topic on YouTube

Use the YTAPI tools (`search_youtube`, `get_video_info`, `get_transcript`).
If they are not available, ask the user to connect YTAPI: in Claude,
Settings → Connectors; in Claude Code, run `/mcp` and sign in to `ytapi`.

## Steps

1. Call `search_youtube` with a focused query. Use `type: "video"` unless
   the user wants channels, playlists or Shorts. Try a second phrasing if
   the first results are off topic.
2. Choose three to five videos: relevant titles first, then views and
   channel.
3. Read each one with `get_transcript`, following the offset when it is
   paged. Skip videos without captions.

Ask before reading more than ten transcripts: each one uses a credit.

## Write the answer

- Answer the user's question first, in a few sentences.
- Then where the videos agree and where they differ, citing each claim with
  the video title and a timestamped link
  (`https://www.youtube.com/watch?v=VIDEO_ID&t=SECONDS`).
- Note sponsored segments and obvious bias when they affect a claim.
- List the videos you read at the end. Answer in the user's language.

## Costs and errors

Each search page uses 1 credit, and so does the first page of each
transcript; `get_video_info` is free. Errors, such as a video without
captions, cost nothing.

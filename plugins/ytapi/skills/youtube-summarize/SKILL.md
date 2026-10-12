---
name: youtube-summarize
description: "Summarize a YouTube video into key points, quotes and timestamped links, or answer questions about what it says, using the YTAPI tools. Use when the user shares a YouTube link or video ID and wants a summary, TL;DR, notes, chapters, quotes, a translation, or an answer from the video. 中文：总结 YouTube 视频、生成笔记。"
---

# Summarize a YouTube video

Use the YTAPI tools (`get_transcript`, `get_video_info`). If they are not
available, ask the user to connect YTAPI: in Claude, Customize → Connectors;
in Claude Code, run `/mcp` and sign in to `ytapi`.

## Steps

1. Call `get_transcript` with the video ID or URL. Keep the default
   `markdown` format: it has `[m:ss]` timestamps you need for links.
2. If the result ends with an offset, call `get_transcript` again with that
   `offset` until you have the whole transcript. Later pages of the same
   transcript are free.
3. If the user wants another language, call `get_video_info` (free) to see
   which caption languages exist, then pass them in `languages`, for example
   `["es", "*"]`.

## Write the summary

- Start with two or three sentences on what the video is about.
- Then the key points in the order they appear, each with a link to its
  moment: `https://www.youtube.com/watch?v=VIDEO_ID&t=SECONDS`. Convert
  `[m:ss]` or `[h:mm:ss]` to seconds.
- Quote the speaker word for word only when the wording matters. Mark quotes
  as quotes.
- Answer in the user's language, whatever the video's language.
- Captions can be auto-generated: if a name or term looks misheard, say so
  instead of guessing.

## Costs and errors

The first page of a transcript uses 1 credit; `get_video_info` is free.
If a video has no captions, or is private or members-only, the tool returns
an error that costs nothing: tell the user plainly.

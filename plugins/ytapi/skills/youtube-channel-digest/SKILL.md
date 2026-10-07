---
name: youtube-channel-digest
description: "Catch up on a YouTube channel: list its latest or most popular uploads and summarize them, or go through a playlist, using the YTAPI tools. Use when the user names a channel (@handle, channel URL or ID) or a playlist and asks what's new, what it covers, or for a digest. 中文：YouTube 频道最新视频、播放列表总结。"
---

# YouTube channel and playlist digest

Use the YTAPI tools (`get_channel_videos`, `get_playlist_videos`,
`get_transcript`). If they are not available, ask the user to connect YTAPI:
in Claude, Settings → Connectors; in Claude Code, run `/mcp` and sign in to
`ytapi`.

## Steps

1. List the videos:
   - a channel: `get_channel_videos` with the @handle, channel ID or URL.
     `sort_by` is `newest` (default), `popular` or `oldest`.
   - a playlist: `get_playlist_videos` with the playlist ID or URL.
2. Pick the videos the user asked about. Without a number, take the first
   three of the list, which are the newest by default.
3. For each one, call `get_transcript`, read it in full (follow the offset
   when it is paged) and write a short summary.

Ask before reading more than ten transcripts: each one uses a credit.

## Write the digest

One entry per video, in the order of the list:

- the title as a link to the video, with its length;
- two or three lines on what it covers, with a timestamped link to the main
  moment (`https://www.youtube.com/watch?v=VIDEO_ID&t=SECONDS`).

End with what the videos have in common, or what changed, if that helps the
user. Answer in the user's language.

## Costs and errors

Each page of a channel or playlist uses 1 credit, and so does the first page
of each transcript. Videos without captions return an error that costs
nothing: list them as "no captions" instead of summarizing them.

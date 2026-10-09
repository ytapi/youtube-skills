---
name: ytapi
description: "YouTube transcripts, video details, search, channels and playlists through the YTAPI REST API. Use when a YouTube video, channel, playlist, @handle or video ID comes up, or YouTube could answer the question: summarize or quote a video, translate or search what was said, research a topic or creator, list a channel's uploads, read a playlist. Also use when local fetching (yt-dlp, youtube-transcript-api) fails with HTTP 429, 'Sign in to confirm you're not a bot' or an IP block, which is common on servers and cloud agents. 中文：YouTube 字幕、视频总结、频道和播放列表。Not for uploading videos or managing a YouTube account."
version: 1.1.0
homepage: https://ytapi.dev
license: MIT-0
required_environment_variables:
  - name: YTAPI_API_KEY
    prompt: "YTAPI API key (starts with sk_)"
    help: "Leave empty and the agent can create a free account for you (200 credits, no card), or get a key at https://ytapi.dev/app/api-keys?utm_source=skill"
    required_for: "All YTAPI requests"
metadata:
  openclaw:
    emoji: "🎬"
    homepage: https://ytapi.dev
    requires:
      bins:
        - curl
    primaryEnv: YTAPI_API_KEY
    envVars:
      - name: YTAPI_API_KEY
        required: false
        description: "YTAPI API key (sk_...). If it is not set, the skill can create a free account and key with the user's email."
  hermes:
    tags: [youtube, transcripts, subtitles, captions, video, search, channels, playlists]
    category: media
---

# YTAPI: YouTube data for agents

Transcripts, video details, search, channels and playlists from
[YTAPI](https://ytapi.dev/?utm_source=skill). Plain HTTPS with `curl`; nothing to install.

## YTAPI tools

If this session already has the YTAPI tools (`get_transcript`,
`get_video_info`, `search_youtube`, `get_channel_videos`,
`get_playlist_videos`), from the YTAPI connector or plugin, use them: they
need no API key and no `curl`. The REST API below is for when those tools
are missing, or for what they don't cover, such as batches and full video
details.

## Setup

If `YTAPI_API_KEY` is not set, read [references/auth-setup.md](references/auth-setup.md)
and follow it: the user either pastes a key or you create a free account
with their email (200 credits, no card).

Every request:

```bash
curl -s "https://api.ytapi.dev/v1/..." -H "Authorization: Bearer $YTAPI_API_KEY"
```

Never print the key. Videos take an 11-character ID or a full URL; channels
take an `@handle` or a `UC...` ID.

## Transcript (1 credit)

```bash
curl -s "https://api.ytapi.dev/v1/transcripts?video_id=VIDEO_ID_OR_URL&format=text" \
  -H "Authorization: Bearer $YTAPI_API_KEY"
```

| Param | Default | Values |
| --- | --- | --- |
| `video_id` | required | 11-character ID or a YouTube URL |
| `format` | `segments` | `text` (plain), `markdown`, `segments` (JSON with start/end seconds), `sentences`, `srt`, `vtt`, `word_timestamps` |
| `languages` | `*` | Comma-separated codes in order of preference. `*` is the video's own language; `en,*` = English if the video has it, else its own language |
| `word_level` | `false` | Word timings on auto-generated tracks (with `format=word_timestamps`) |

- For reading, summarizing or quoting, use `format=text` or `format=markdown`
  (smaller and easier to read). Use `segments` when you need timestamps,
  for example to link to a moment: `https://youtu.be/VIDEO_ID?t=SECONDS`.
- JSON responses include `language` and `track_kind` (`manual` = creator
  captions, `asr` = auto-generated).
- Long videos give long transcripts: save to a file and read it in parts
  instead of loading it all at once.

## Video details

```bash
# Free: title, duration, channel, and which caption languages exist
curl -s "https://api.ytapi.dev/v1/videos/VIDEO_ID/basic-info" -H "Authorization: Bearer $YTAPI_API_KEY"

# 1 credit: full record (description, views, likes, comment count, publish
# date, tags, chapters, live status, links, hashtags, music, related videos)
curl -s "https://api.ytapi.dev/v1/videos/VIDEO_ID/video-info" -H "Authorization: Bearer $YTAPI_API_KEY"
```

Check `basic-info` first when unsure whether a video has captions in a
language: `available_languages` lists each track with `kind` `manual` or `asr`.

`video-info` also returns YouTube's own `ai_summary` when YouTube shows one,
and `related` (up to 20 suggested videos) for finding more on a topic. A
scheduled stream or premiere has `is_upcoming: true` and `scheduled_start`
(Unix time); it has no transcript until it airs.

## Search (1 credit per page)

```bash
curl -s -G "https://api.ytapi.dev/v1/search" \
  --data-urlencode "q=QUERY" -d type=video -d limit=20 \
  -H "Authorization: Bearer $YTAPI_API_KEY"
```

| Param | Values |
| --- | --- |
| `q` | Search text |
| `type` | `all`, `video`, `channel`, `playlist`, `shorts`, `movie` |
| `upload_date` | `hour`, `today`, `week`, `month`, `year` |
| `duration` | `short`, `medium`, `long` |
| `sort_by` | `relevance`, `upload_date`, `view_count`, `rating` |
| `cursor` | `next_cursor` from the previous page (when `has_more` is true) |

Results are in `items` (`id`, `type`, `title`, `author`, `channel_id`,
`length_seconds`, `view_count_text`, ...). Autocomplete suggestions are free:
`GET /v1/search/suggestions?q=TEXT`.

## Channels (1 credit each)

```bash
# Profile: title, handle, description, subscribers, video count
curl -s "https://api.ytapi.dev/v1/channels/@HANDLE" -H "Authorization: Bearer $YTAPI_API_KEY"

# Latest uploads
curl -s "https://api.ytapi.dev/v1/channels/@HANDLE/latest" -H "Authorization: Bearer $YTAPI_API_KEY"

# All uploads, paged (sort_by: newest, popular, oldest)
curl -s "https://api.ytapi.dev/v1/channels/@HANDLE/videos?sort_by=popular" -H "Authorization: Bearer $YTAPI_API_KEY"

# The channel's playlists
curl -s "https://api.ytapi.dev/v1/channels/@HANDLE/playlists" -H "Authorization: Bearer $YTAPI_API_KEY"
```

Paged responses carry `has_more` and `next_cursor`; pass `cursor=NEXT_CURSOR`
for the next page.

## Playlists (1 credit per page)

```bash
curl -s "https://api.ytapi.dev/v1/playlists/PLAYLIST_ID" -H "Authorization: Bearer $YTAPI_API_KEY"
```

The first page has the playlist's details and videos; pass `cursor` for more.

## Many videos at once

For dozens of transcripts, submit one batch (up to 100 tasks, 1 credit per
successful task) instead of looping: `POST /v1/batch`, then poll
`GET /v1/batch/{id}`. See <https://docs.ytapi.dev/batch/run>.

## Credits and limits

Only successful responses use credits; errors are free. New accounts get 200
free credits. Until a credit pack is bought, a key can make 1 request per
second and 100 requests per day (UTC). Credit packs from $9:
<https://ytapi.dev/?utm_source=skill#pricing>.

## Errors

Errors look like `{"error": {"code": "...", "message": "...", "retryable": false}}`.

| Status | Code | What to do |
| --- | --- | --- |
| 401 | `unauthorized` | Key missing or wrong: check `YTAPI_API_KEY`, or follow references/auth-setup.md. |
| 402 | `insufficient_credits` | Out of credits. Tell the user; packs at <https://ytapi.dev/?utm_source=skill#pricing>. |
| 404 | `language_not_found`, `captions_disabled` | No captions in the requested languages, or none at all. Try `languages=*`, or check `basic-info`. |
| 404 | `video_not_found`, `video_private`, `video_unavailable`, `channel_not_found`, `playlist_not_found` | Wrong ID, or the item is private or removed. |
| 429 | `rate_limited` | Wait for `Retry-After` seconds and retry. |
| 429 | `daily_limit_exceeded` | Free keys allow 100 requests a day; it resets at 00:00 UTC. Any credit pack removes the limit. |
| 5xx | | Retry once after a few seconds. |

Full reference: https://docs.ytapi.dev (Markdown for agents: https://docs.ytapi.dev/llms-full.txt).

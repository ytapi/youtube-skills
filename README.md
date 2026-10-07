# YouTube skills for AI agents

Agent skills for YouTube transcripts, search, channels and playlists, powered
by [YTAPI](https://ytapi.dev/?utm_source=skill). They work with Claude Code, Codex, Cursor,
OpenClaw, Hermes Agent and any agent that reads [Agent Skills](https://agentskills.io).

Plain HTTPS calls with `curl`, nothing else to install. They also work where
fetching YouTube directly fails: on servers and cloud agents, tools like
yt-dlp often get HTTP 429, a bot check or an IP block.

## Install

**Claude Code plugin:** run these in Claude Code to get all five skills:

```text
/plugin marketplace add ytapi/youtube-skills
/plugin install ytapi@ytapi
```

**Claude Code, Codex, Cursor, Cline and others** ([skills.sh](https://skills.sh)):

```bash
npx skills add ytapi/youtube-skills
```

One skill only:

```bash
npx skills add ytapi/youtube-skills --skill ytapi-youtube-transcript
```

**OpenClaw** ([ClawHub](https://clawhub.ai)):

```bash
npx clawhub@latest install ytapi
```

**Hermes Agent:**

```bash
hermes skills install skills-sh/ytapi/youtube-skills/skills/ytapi
```

**Not a developer?** Paste this to your agent:

> Install the YouTube skill from https://github.com/ytapi/youtube-skills and
> set up my YTAPI key.

## Skills

| Skill | What it does |
| --- | --- |
| [`ytapi`](skills/ytapi/SKILL.md) | Everything below in one skill: transcripts, video details, search, channels, playlists, batches |
| [`ytapi-youtube-transcript`](skills/ytapi-youtube-transcript/SKILL.md) | Transcripts and subtitles: text, Markdown, timestamped JSON, SRT, VTT, any language |
| [`ytapi-youtube-search`](skills/ytapi-youtube-search/SKILL.md) | Search videos, channels, playlists and Shorts, then read the results |
| [`ytapi-youtube-channels`](skills/ytapi-youtube-channels/SKILL.md) | Channel profiles, latest uploads, all videos, playlists |
| [`ytapi-youtube-summarize`](skills/ytapi-youtube-summarize/SKILL.md) | Summaries and notes of a video or a channel's new uploads, with timestamped links |

Install `ytapi` if you are unsure.

## API key

The skills read the key from `YTAPI_API_KEY`. If it is not set, the agent
offers to create a free account for you: you give it your email address and
the 6-digit code we send you, and it stores the key. No browser and no card.
Or create a key yourself at [ytapi.dev](https://ytapi.dev/app/api-keys?utm_source=skill).

New accounts get 200 free credits. One successful request uses one credit
(video basic info and search suggestions are free); failed requests are free.
Until you buy a credit pack, a key can make 1 request per second and 100 per
day. Packs start at $9 for 2,000 credits and never expire:
[pricing](https://ytapi.dev/?utm_source=skill#pricing).

## Examples

- "Summarize this video: https://youtu.be/dQw4w9WgXcQ"
- "Get the Spanish subtitles of this talk as an SRT file."
- "Find this week's most-viewed videos about Rust async and tell me what they cover."
- "What has @mkbhd uploaded lately? Give me a two-line summary of each."
- "List every video in this playlist with its length."

## Links

- Docs: https://docs.ytapi.dev (for agents: https://docs.ytapi.dev/llms-full.txt)
- Remote MCP server: https://docs.ytapi.dev/agent-setup/#mcp
- Agent sign-up API: https://docs.ytapi.dev/agent-signup/
- Support: hello@ytapi.dev

## Contributing

Each skill carries a copy of `shared/auth-setup.md` in its `references/`
folder, because skills are installed one at a time. Edit the file in
`shared/`, then run `./scripts/sync-references.sh`.

When you change a skill, also bump `version` in `.claude-plugin/plugin.json`.
Claude Code keeps plugin users on the version listed there.

Licensed [MIT-0](LICENSE).

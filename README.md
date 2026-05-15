# claude-plugins

Personal Claude Code plugins by [@tbrzz01](https://github.com/tbrzz01).

## Plugins

| Plugin | What it does |
|---|---|
| [`weekly-planning`](./plugins/weekly-planning) | Weekly plans, action tracking, OKR-style goal alignment, meeting processing |
| [`team-docs`](./plugins/team-docs) | Team member profiles, GitHub/Jira activity sync, documentation tooling |
| [`engineering-helpers`](./plugins/engineering-helpers) | Defect root-cause analysis, full-stack feature implementation, support bug resolution |

## Install

In Claude Code:

```
/plugin marketplace add tbrzz01/claude-plugins
/plugin install weekly-planning@trey-plugins
/plugin install team-docs@trey-plugins
/plugin install engineering-helpers@trey-plugins
```

Install only the ones you want — each is independent.

## Local configuration

`weekly-planning` and `team-docs` read filesystem paths (your docs root, weekly plans folder, etc.) from a per-plugin config file. Each plugin ships a `config.example.json`. Copy it to `config.local.json` and fill in your paths:

```bash
cp plugins/weekly-planning/config.example.json plugins/weekly-planning/config.local.json
cp plugins/team-docs/config.example.json       plugins/team-docs/config.local.json
# edit each config.local.json with your actual paths
```

`config.local.json` is gitignored. Skills and agents resolve `{placeholder}` references against this file at runtime.

## What's inside each plugin

### weekly-planning
**Skills:** `new-week`, `track-actions`, `personal-goals`, `process-meeting`
**Agents:** `weekly-review`, `strategic-planning`, `meeting-intelligence`

The core productivity loop: spin up next week's plan with carried-over tasks, track open action items across weeks, keep work aligned to OKR-style goals, and turn meeting transcripts into structured action items.

### team-docs
**Skills:** `new-team-member`, `update-team`, `docs-hub`, `link-docs`, `feature-deep-dive`
**Agents:** `doc-health`, `knowledge-graph`, `pr-monitor`

Onboarding and documentation tooling: create team profiles, sync GitHub/Jira activity into READMEs, navigate strategic hub docs, auto-link related documents, audit doc health, build knowledge graphs across docs, and monitor team PR activity.

### engineering-helpers
**Skills:** `defect-analysis`
**Agents:** `full-stack-implementer`, `support-bug-resolver`

Engineering workflow helpers: 5-Whys defect analysis, planned-and-tested full-stack feature implementation, and end-to-end support bug triage from Jira to draft PR.

## Layout

```
.claude-plugin/marketplace.json       ← marketplace entry point
plugins/
  <plugin-name>/
    .claude-plugin/plugin.json        ← plugin manifest
    skills/<skill-name>/SKILL.md      ← skill files
    agents/<agent-name>.md            ← agent files
```

## License

MIT

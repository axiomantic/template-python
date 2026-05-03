# project_name — Project Instructions

## Project Philosophy

This project follows axiomantic standards: production-quality or nothing,
audit-driven tooling, no shortcuts. Read this file before making changes.

## Build & Test Commands

The justfile is the canonical command surface. Don't memorize `uv` invocations.

| Task | Command | Notes |
|---|---|---|
| Run tests | `just test` | pytest |
| Lint | `just lint` | ruff check + ruff format --check + mypy |
| Auto-format | `just fmt` | ruff format + ruff check --fix |
| Build docs | `just docs` | mkdocs serve (live reload) |
| Build dist | `just build` | uv build |
| Pre-release smoke | `just release-preflight` | lint + test + build |

## Setup

1. Install [uv](https://docs.astral.sh/uv/).
2. `uv sync --all-extras --dev`
3. `uv run pre-commit install --install-hooks`   # registers pre-commit AND pre-push hooks (default_install_hook_types)
   Requires `pre-commit >= 3.2.0` (declared in pyproject `[project.optional-dependencies] dev`).

## Key Conventions

- **src layout:** all importable code lives under `src/project_name/`.
- **tests mirror src:** `tests/test_<module>.py` mirrors `src/project_name/<module>.py`.
- **Docstrings:** Google convention (`[tool.ruff.lint.pydocstyle] convention = "google"`).
- **Type hints:** mypy strict mode. No `Any` without justification (see Forbidden Patterns).
- **Formatting authority:** `ruff format` is the only formatter. Do not hand-format.

## Forbidden Patterns

- No `Any` in production code without an inline `# noqa: ANN401` and a one-line justification.
- No blanket `except Exception:` or bare `except:`.
- No commented-out code (ruff `ERA` will flag it). Delete or fix.
- No `# type: ignore` without a specific error code AND a comment explaining why.
- No `print()` in production code (use logging). Tests are exempt via per-file-ignore.

## Operational Notes

### OPENROUTER_KEY (org secret) — REQUIRED for pr-agent
The pr-agent.yml workflow consumes `secrets.OPENROUTER_KEY` from the repo or org level.
Verify with `gh secret list -o axiomantic | grep OPENROUTER_KEY` before opening the first PR.
Without it, pr-agent.yml fails on the first PR with no review output.

### Org Actions permissions
If your org disables Actions by default for new repos, enable Actions and grant write
permission to GITHUB_TOKEN before `template-cleanup.yml` runs (Settings -> Actions ->
General -> Workflow permissions -> "Read and write permissions"). Without this,
template-cleanup cannot push the rename commit and the marker file persists.

### `@devel` pin coupling — KNOWN LIVE RISK
`pr-agent.yml` inherits from `axiomantic/.github/.github/workflows/pr-agent.yml@devel`.
Breaking changes upstream propagate immediately to all instantiated repos. To pin
this project to a specific upstream SHA, replace `@devel` with the SHA in
`.github/workflows/pr-agent.yml`. The trade is: stability vs. automatic improvements.

### PyPI trusted publisher (one-time per project)
First release will fail loudly with a setup URL. Configure trusted publisher at
https://pypi.org/manage/account/publishing/ with these values:
- Owner: `axiomantic`
- Repository: `<this repo name>`
- Workflow: `release.yml`
- Environment: `pypi`

## Glossary

(populate per project)

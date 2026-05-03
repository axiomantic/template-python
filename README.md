# project-name

PROJECT DESCRIPTION HERE.

## After using this template

1. Find/replace `project-name` (kebab-case) and `project_name` (snake_case) with your real names.
2. Rename `src/project_name/` to match.
3. Update `pyproject.toml` `description`, `dependencies`, and URLs.
4. Replace this README with real content.
5. PR Agent runs automatically via the org-level `OPENROUTER_KEY` secret on `axiomantic`. If you forked into a different namespace, set the secret yourself or remove `.github/workflows/pr-agent.yml`.

## Development

```bash
uv sync --all-extras --dev
just test
just lint
just docs
```

## Operational Notes

### Justfile is the canonical command surface

All dev workflows route through `just`:

- `just test` — pytest
- `just lint` — ruff check + ruff format --check + mypy
- `just fmt` — auto-format
- `just docs` — local mkdocs serve
- `just build` — uv build

`uv` and `pytest` are implementation details. Add new dev workflows as `just`
recipes, not as ad-hoc shell commands here.

### OPENROUTER_KEY org secret

`.github/workflows/pr-agent.yml` requires `OPENROUTER_KEY` at the org level
(or per-repo). Verify with:

```bash
gh secret list -o axiomantic | grep OPENROUTER_KEY
```

Without it, the first PR will fail in `pr-agent` with no review output.

### Org Actions permissions

If your org disables Actions by default for new repos, enable Actions and
grant write permission to `GITHUB_TOKEN` before `template-cleanup.yml` runs:
**Settings -> Actions -> General -> Workflow permissions -> "Read and write
permissions"**. Without this, template-cleanup cannot push the rename commit
and the marker file persists.

### PyPI trusted publisher (one-time per project)

The first `release.yml` run for a brand-new project will fail loudly with a
setup URL. Configure trusted publisher at
<https://pypi.org/manage/account/publishing/> with these values:

- **Owner:** `axiomantic`
- **Repository:** `<this repo name>`
- **Workflow:** `release.yml`
- **Environment:** `pypi`

After configuring, re-tag (or re-run the release workflow) to publish.

## License

MIT

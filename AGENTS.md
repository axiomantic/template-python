# project_name

## Build Commands

| Task | Command |
|---|---|
| Test | `just test` |
| Lint | `just lint` |
| Format | `just fmt` |
| Docs | `just docs` |
| Build | `just build` |

## Architecture Overview

Single-package src layout. Public API is exposed via `src/project_name/__init__.py`.
Tests live in `tests/` and mirror the src tree.

## Key Modules

| Module | Purpose | Notes |
|---|---|---|
| `src/project_name/__init__.py` | Package entry / public re-exports | Per-file-ignore D104 keeps it docstring-free |
| (add per project) | | |

## Conventions

- **Testing:** pytest, smoke tests in `tests/test_smoke.py`.
- **Docstrings:** Google convention.
- **Formatting authority:** `ruff format`. `ruff check --fix` for safe lint fixes.
- **Pre-commit guard:** `ruff check`, `ruff format`, plus `mypy` at pre-push (slow guard).

## The justfile is the canonical command surface

`uv` and `pytest` are implementation details. Add new dev workflows as `just` recipes,
not as ad-hoc shell commands in README. (Decision #10.)

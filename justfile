default:
    @just --list

# Run the test suite
test:
    uv run pytest

# Lint (ruff check + ruff format --check + mypy)
lint:
    uv run ruff check .
    uv run ruff format --check .
    uv run mypy .

# Auto-fix formatting and lint where possible
fmt:
    uv run ruff format .
    uv run ruff check --fix .

# Build and serve docs locally
docs:
    uv run --with mkdocs-material --with 'mkdocstrings[python]' mkdocs serve

# Build distribution
build:
    uv build

# Pre-publish smoke check (run before tagging a release)
release-preflight:
    just lint
    just test
    uv build

# Manual fallback for template-cleanup (find/replace project_name -> kebab name).
# Cross-platform: uses python3 for find/replace (GNU vs BSD sed differences are avoided).
rename new_name:
    @echo "Renaming project_name -> {{new_name}}"
    @python3 -c "import sys, pathlib; new_kebab = sys.argv[1]; new_snake = new_kebab.replace('-', '_'); root = pathlib.Path('.'); [f.write_text(f.read_text(encoding='utf-8').replace('project_name', new_snake).replace('project-name', new_kebab), encoding='utf-8') for f in root.rglob('*') if f.is_file() and not any(p.startswith('.') for p in f.parts) and f.suffix in {'.py', '.toml', '.md', '.yml', '.yaml', '.nimble', '.nim', '.nims'}]" {{new_name}}
    @python3 -c "import sys, pathlib; new_snake = sys.argv[1].replace('-', '_'); src = pathlib.Path('src/project_name'); src.rename(pathlib.Path('src') / new_snake) if src.is_dir() else None" {{new_name}}

# Remove build artifacts and caches
clean:
    rm -rf dist build .pytest_cache .ruff_cache .mypy_cache site
    find . -type d -name __pycache__ -exec rm -rf {} +

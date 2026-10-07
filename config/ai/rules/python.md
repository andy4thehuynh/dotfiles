---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Conventions

Write idiomatic, pragmatic Python in the spirit of Raymond Hettinger (built-in iteration, "one logical line = one English sentence"), Armin Ronacher (minimalist, composable, resist magic), and Simon Willison (small sharp tools, stdlib-first).

## Stdlib First

Reach for the standard library before adding any dependency: `pathlib`, `itertools`, `functools`, `collections`, `dataclasses`, `contextlib`, `argparse`, `sqlite3`, `tomllib` (3.11+), `secrets`. Add a dependency only when the stdlib answer is materially worse, and only after checking whether an existing project dependency already covers it.

## Tooling

- **`uv`** for environments and installs (`uv venv`, `uv sync`, `uv add`, `uv run pytest`); fall back to `pip + venv`
- **`ruff`** for both linting (`ruff check`) and formatting (`ruff format`) — not flake8/pylint/isort/black
- **`pyproject.toml`** is the source of truth for dependencies; commit the lockfile
- Pin minimum versions; avoid upper pins unless you've hit an actual incompatibility
- Line length: 100 characters

## Structure Preferences

- **Flat beats nested**: a well-named module in the project root beats a deep package hierarchy
- **Functions over classes**: a class is justified only for state + behavior that belong together, or polymorphism with multiple implementations. Never write a class of `@staticmethod`s as a namespace:

  ```python
  # Bad - module pretending to be a class
  class EmailValidator:
      @staticmethod
      def validate(email):
          return '@' in email

  # Good - just a function
  def is_valid_email(email):
      return '@' in email
  ```
- **Keep `__init__.py` minimal** — re-exports only, no logic
- **Return dataclasses or NamedTuples, not bare tuples** from functions with multiple results:

  ```python
  @dataclass(frozen=True)
  class TestResult:
      passed: int
      failed: int
  ```

- **Don't abstract prematurely**: three similar lines is not duplication that needs extraction. Wait for the fourth, and wait for the shape to stabilize

## Idioms

- If you're manipulating indices, you're probably doing it wrong: use `enumerate`, `zip`, `reversed`, `sorted(key=...)`, tuple unpacking, and `dict.items()`
- Prefer `dict.get`/`setdefault`, `collections.defaultdict` for grouping, `Counter` for counting
- Prefer EAFP (`try`/`except FileNotFoundError`) over LBYL (`if os.path.exists`)
- Generator expressions over list comprehensions for large or streamed sequences: `sum(x ** 2 for x in xs)`
- Keyword arguments at call sites when positional args are unreadable: `search(q, retweets=False, limit=20)`
- `functools.lru_cache` for memoizing pure functions; profile (`cProfile`, `py-spy`) before any other optimization

## Type Hints

- Annotate public function signatures and dataclasses; skip tiny private helpers where hints add noise
- Modern syntax only (3.10+): `X | None` not `Optional[X]`, `list[int]` not `List[int]`, `dict[str, int]` not `Dict[str, int]`
- Don't annotate local variables — let inference work

## Testing (pytest)

- pytest, not unittest. Plain functions, fixtures for shared setup, `@pytest.mark.parametrize` to cover cases
- **Prefer real dependencies over mocks**: use `tmp_path`, in-memory SQLite, real filesystems. Mock only external APIs, payment processors, email services
- Never delete a failing test to make the suite green — fix the test or fix the code
- Write tests alongside implementation, not after

## Error Handling

- Catch specific exceptions; never bare `except:` or `except Exception: pass`
- Chain when re-raising: `raise ConfigError(f'invalid config at {path}') from e`
- Context managers (`with`, `@contextmanager`) for any resource cleanup

## Security

- Parameterized SQL, never f-string concatenation
- `secrets.token_urlsafe()` for tokens, never `random`
- `subprocess.run([...])` with an argument list, never `shell=True` with interpolated input
- Secrets from `os.environ`, required ones with `os.environ['KEY']` to fail fast

## Style Notes

- Standard 4-space indentation per PEP 8 — `ruff format` handles it
- `is None`, not `== None`; predicates named `is_*`/`has_*` returning `bool`
- Imports in three blank-line-separated groups: stdlib, third-party, first-party. Never `from module import *`
- Don't invent new `__dunder__` names
- No mutable default arguments — use `None` sentinel

# SQL Exercises

<https://en.wikibooks.org/wiki/SQL_Exercises>

## Quickstart

Launch Postgres and pgAdmin services.

```bash
docker compose up -d
```

To access the pgAdmin UI, visit <http:localhost:5050>.

## Development

Install pre-commit hooks into Git.

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -U pip setuptools wheel
python3 -m pip install pre-commit

pre-commit install
```

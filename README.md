# Commodify

A data visualization tool that outputs a single graph showing the current housing market average price per country.

## Migrations

Migration files are timestamped SQL files stored in the `migrations/` directory.

The default database connection is `postgres://localhost/commodify`. Override it by setting the `DATABASE_URL` environment variable.

### Commands

**Create a migration**

```bash
make migrate-create
```

You will be prompted for a name. The file is created at `migrations/<timestamp>_<name>.sql`.

```
Name: create_users
Created: migrations/20260517143022_create_users.sql
```

**Run all migrations**

```bash
make migrate-run
# or with a custom database URL
DATABASE_URL=postgres://user:pass@host/db make migrate-run
```

Runs all `.sql` files in `migrations/` in chronological order against the configured Postgres database.

**Rollback**

```bash
make migrate-rollback
```

Removes the most recently created migration file. Note: this is file-level only — it does not undo SQL already applied to the database.

The `migrations/` directory is created automatically if it does not exist.

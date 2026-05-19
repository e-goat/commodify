# Commodify
NOTE: This software is work in progress.

Single graph showing the current housing market average price per country.

## Migrations

Migration files are timestamped SQL files stored in the `migrations/` directory. Migration history is tracked in a `migrations` table in the database.

Configure the database connection in `.env` (copy `.env.example` to get started):

```bash
cp .env.example .env
```

```env
DATABASE_URL=postgres://user:pass@host/db
```

### Commands

**Create a migration**

```bash
make migrate-create
```

Prompts for a name and creates two files:

```
Name: create_users
Created: migrations/20260517143022_create_users.sql
Created: migrations/20260517143022_create_users_down.sql
```

The `_down.sql` file is used for rollbacks. Fill it with the SQL to undo the corresponding migration (e.g. `DROP TABLE`).

**Run migrations**

```bash
make migrate-run
```

Creates the `migrations` table if it does not exist, then runs all pending up migrations in chronological order. Already-applied migrations are skipped.

**Rollback**

```bash
make migrate-rollback
```

Looks up the most recently applied migration from the `migrations` table, executes its `_down.sql` file, and removes the record. One migration is rolled back per invocation.

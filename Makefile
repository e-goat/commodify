-include .env
export

migrate-create:
	@mkdir -p migrations
	@read -p "Name: " name; \
	ts=$$(date +%Y%m%d%H%M%S); \
	file="migrations/$${ts}_$${name}.sql"; \
	down="migrations/$${ts}_$${name}_down.sql"; \
	touch "$$file"; \
	printf '-- This file is executed by: make migrate-rollback\n-- Add your rollback SQL here (e.g. DROP TABLE, ALTER TABLE ...)\n' > "$$down"; \
	echo "Created: $$file"; \
	echo "Created: $$down"

migrate-run:
	@psql "$(DATABASE_URL)" -c "CREATE TABLE IF NOT EXISTS migrations (id SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE, applied_at TIMESTAMPTZ DEFAULT NOW());" > /dev/null
	@for f in migrations/*.sql; do \
		[ -f "$$f" ] || continue; \
		case "$$f" in *_down.sql) continue ;; esac; \
		name=$$(basename "$$f"); \
		count=$$(psql "$(DATABASE_URL)" -t -A -c "SELECT COUNT(*) FROM migrations WHERE name = '$$name';"); \
		if [ "$$count" -eq 0 ]; then \
			echo "Running $$f..."; \
			psql "$(DATABASE_URL)" -f "$$f"; \
			psql "$(DATABASE_URL)" -c "INSERT INTO migrations (name) VALUES ('$$name');" > /dev/null; \
		else \
			echo "Skipping $$f (already applied)"; \
		fi; \
	done

migrate-rollback:
	@last=$$(psql "$(DATABASE_URL)" -t -A -c "SELECT name FROM migrations ORDER BY applied_at DESC LIMIT 1;"); \
	if [ -z "$$last" ]; then \
		echo "No migrations to roll back."; \
	else \
		base="$${last%.sql}"; \
		down="migrations/$${base}_down.sql"; \
		if [ ! -f "$$down" ]; then \
			echo "Down file not found: $$down"; \
			exit 1; \
		fi; \
		echo "Rolling back $$last..."; \
		psql "$(DATABASE_URL)" -f "$$down"; \
		psql "$(DATABASE_URL)" -c "DELETE FROM migrations WHERE name = '$$last';" > /dev/null; \
		echo "Rolled back: $$last"; \
	fi

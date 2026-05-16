-include .env
export

migrate-create:
	@mkdir -p migrations
	@read -p "Name: " name; \
	file="migrations/$$(date +%Y%m%d%H%M%S)_$${name}.sql"; \
	touch "$$file"; \
	echo "Created: $$file"

migrate-run:
	@for f in migrations/*.sql; do \
		echo "Running $$f..."; \
		psql "$(DATABASE_URL)" -f "$$f"; \
	done

migrate-rollback:
	@last=$$(ls migrations/*.sql 2>/dev/null | sort | tail -n 1); \
	if [ -z "$$last" ]; then \
		echo "No migrations to roll back."; \
	else \
		rm "$$last"; \
		echo "Removed: $$last"; \
	fi

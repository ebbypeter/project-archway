SHELL := /bin/bash

.PHONY: setup new-system import-systems views validate reports site verify serve clean

## new-system: scaffold a new enterprise system (interactive; NAME=X to preseed)
new-system:
	@python3 scripts/new_system.py $(NAME)

## import-systems: bulk-create systems from a CSV (FILE=estate.csv)
import-systems:
	@python3 scripts/import_systems.py $(FILE)

## views: regenerate standard context views and category landscapes
views:
	python3 scripts/generate_views.py

## setup: download pinned tooling into .tools/ (JRE if needed, structurizr-cli, site-generatr)
setup:
	scripts/setup-tools.sh

## validate: repository convention checks + authoritative DSL compile of the workspace
validate: views
	python3 scripts/validate_model.py
	@source scripts/env.sh && echo "==> structurizr-cli validate" && \
		"$$STRUCTURIZR_CLI" validate -workspace workspace/workspace.dsl

## reports: generate inventory reports from model properties (*.gen.adoc)
reports:
	python3 scripts/generate_reports.py

## site: full build — validate, reports, then static portal into build/site/
site: validate reports
	scripts/build_site.sh

## verify: confirm every authored document reached the built site
verify:
	python3 scripts/verify_published.py

## serve: serve the built portal on http://localhost:8080
serve:
	cd build/site && python3 -m http.server 8080

clean:
	rm -rf build workspace/docs/*.gen.adoc

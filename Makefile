SHELL := /bin/bash
WORKSPACES := Enterprise Technology Security Integration

.PHONY: setup validate compile reports site serve clean

## setup: download pinned tooling into .tools/ (JRE if needed, structurizr-cli, site-generatr)
setup:
	scripts/setup-tools.sh

## validate: repository convention checks + authoritative DSL compile of every workspace
validate:
	python3 scripts/validate_model.py
	@source scripts/env.sh && for ws in $(WORKSPACES); do \
		echo "==> structurizr-cli validate: $$ws"; \
		"$$STRUCTURIZR_CLI" validate -workspace workspaces/$$ws/workspace.dsl || exit 1; \
	done

## reports: generate inventory reports from model properties (*.gen.adoc)
reports:
	python3 scripts/generate_reports.py

## site: full build — validate, reports, then static portal into public/
site: validate reports
	scripts/build_site.sh

## serve: serve the built portal on http://localhost:8080
serve:
	cd public && python3 -m http.server 8080

clean:
	rm -rf build public workspaces/*/docs/*.gen.adoc

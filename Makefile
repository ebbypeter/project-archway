SHELL := /bin/bash

.PHONY: setup validate reports site verify serve clean

## setup: download pinned tooling into .tools/ (JRE if needed, structurizr-cli, site-generatr)
setup:
	scripts/setup-tools.sh

## validate: repository convention checks + authoritative DSL compile of the workspace
validate:
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

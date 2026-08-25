.PHONY: deps lint template ct all help

CHARTS := $(shell find charts -mindepth 1 -maxdepth 1 -type d | sort)

all: deps lint template ## Run deps, lint, and template for all charts

deps: ## Build chart dependencies (helm dependency update)
	@for chart in $(CHARTS); do \
		echo "===> Building dependencies for $$chart"; \
		helm dependency update "$$chart"; \
	done

lint: ## Lint all charts (helm lint)
	@for chart in $(CHARTS); do \
		echo "===> Linting $$chart"; \
		helm lint "$$chart"; \
	done

template: ## Render templates for all charts (helm template dry-run)
	@for chart in $(CHARTS); do \
		echo "===> Rendering templates for $$chart"; \
		helm template test "$$chart" > /dev/null; \
	done

ct: ## Run chart-testing lint on all charts (requires ct installed)
	@which ct >/dev/null 2>&1 || { echo "Error: ct (chart-testing) not found. Install from https://github.com/helm/chart-testing"; exit 1; }
	ct lint --config ct.yaml --validate-chart-schema=false --all

lint-chart: ## Lint a specific chart: make lint-chart CHART=nominatim
	@if [ -z "$(CHART)" ]; then echo "Usage: make lint-chart CHART=<chart-name>"; exit 1; fi
	helm lint "charts/$(CHART)"

template-chart: ## Render templates for a specific chart: make template-chart CHART=nominatim
	@if [ -z "$(CHART)" ]; then echo "Usage: make template-chart CHART=<chart-name>"; exit 1; fi
	helm template test "charts/$(CHART)"

clean: ## Remove vendored dependencies
	@for chart in $(CHARTS); do \
		echo "===> Cleaning $$chart"; \
		rm -rf "$$chart/charts/*.tgz" 2>/dev/null || true; \
	done

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

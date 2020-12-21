.DEFAULT_GOAL:= help

.PHONY: it
it: static-code-analysis tests

.PHONY: code-coverage
code-coverage: export XDEBUG_MODE=coverage
code-coverage: vendor ## Executes the test suite and generates code coverage reports
	mkdir -p .build/phpunit
	vendor/bin/phpunit --coverage-text

.PHONY: help
help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: static-code-analysis
static-code-analysis: vendor phpstan psalm ## ## Performs static code analysis

.PHONY: psalm
psalm: ## Performs static code analysis with Psalm
	mkdir -p .build/psalm
	vendor/bin/psalm --diff --show-info=false --stats --threads=4

.PHONY: phpstan
phpstan: ## Performs static code analysis with PHPStan
	mkdir -p .build/phpstan
	vendor/bin/phpstan analyse --memory-limit=-1

.PHONY: tests
tests: vendor ## Executes the test suite
	mkdir -p .build/phpunit
	vendor/bin/phpunit

vendor: composer.json composer.lock
	composer validate --strict
	composer install --no-interaction --no-progress

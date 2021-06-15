SHELL=/bin/bash

.DEFAULT_GOAL := help

.PHONY: help
help: ## Shows this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: new-machine-install
new-machine-install: ## If the machine doesn't have the commands poetry, make, dulwich or localstack installed, we'll install them now. May need reboot vscode and Microsoft build tools (Visual Studio).
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
	pip install --user poetry
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	choco install make
	pip install dulwich
	pip install localstack

.PHONY: airflow-local-up
airflow-local-up: ## Runs airflow containers locally using docker-compose. Available on http://127.0.0.1:8080. Usename: user, Password: Cath123
	docker-compose -f airflow/docker-compose.yml up --force-recreate -d

.PHONY: airflow-local-down
airflow-local-down: ## Kill all airflow containers created with docker-compose.
	docker-compose -f airflow/docker-compose.yml down -v

# Deleta o .env e reinstala, junto com todos as receitas declaradas abaixo. Observe que ele executa 3 conjuntos.
.PHONY: dev-fresh-build-local
dev-fresh-build-local: dev-clean-local dev-install-local dev-test-local ## Clean environment and reinstall all dependencies

.PHONY: dev-clean-local
dev-clean-local: ## Removes project virtual env
	bash scripts/dev_clean_local.sh

.PHONY: dev-install-local
dev-install-local: ## Local install of the project and pre-commit using Poetry. Install AWS CDK package for development.
	npm install -g aws-cdk-local aws-cdk
	poetry install
	poetry run pre-commit install
	poetry run pip install -e infrastructure
	poetry run pip install -r airflow/airflow-requirements.txt
	poetry run localstack start --docker

.PHONY: dev-test-local
dev-test-local: ## Run local tests 
	bash scripts/dev_test_local.sh

.PHONY: dev-deploy-local
dev-deploy-local: ## Deploy the infrastructure stack to localstack
	bash scripts/dev_deploy_local.sh
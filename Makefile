REGISTRY ?=
IMAGE ?= $(or $(REGISTRY),nlesc)/sandbox
AGENT ?=

.DEFAULT_GOAL := help

.PHONY: help build preview push create exec clean

help:
	@echo "Usage: make <target> [VARIABLE=value ...]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  \033[33mAGENT\033[0m            Target agent: shell, claude-code, codex, gemini, copilot, cursor-agent"
	@echo "  \033[33mREGISTRY\033[0m         Registry prefix for image tags"
	@echo "  \033[33mNAME\033[0m             Sandbox container name"
	@echo ""
	@echo "Examples:"
	@echo "  make build                          Build all targets locally"
	@echo "  make build AGENT=claude-code        Build a single target"
	@echo "  make build REGISTRY=nlesc           Build all with registry tags"
	@echo "  make push REGISTRY=nlesc            Push all tags to registry"
	@echo "  make create AGENT=claude-code       Create a sandbox"
	@echo "  make exec NAME=my-sandbox           Exec into a sandbox"
	@echo "  make clean                          Remove all sandbox images"

preview: ## Preview what would be built (AGENT=<agent> REGISTRY=<registry>)
	$(if $(REGISTRY),REGISTRY=$(REGISTRY)) docker buildx bake --print $(AGENT)

build: ## Build (AGENT=<agent> REGISTRY=<registry>)
	$(if $(REGISTRY),REGISTRY=$(REGISTRY)) docker buildx bake $(AGENT)

clean: ## Remove all local sandbox images (REGISTRY=<registry>)
	@docker images --format '{{.Repository}}:{{.Tag}}' | grep -E '^(sandbox:|$(or $(REGISTRY),nlesc)/sandbox:)' | xargs -r docker rmi -f

push: ## Push all tags to registry
	docker push --all-tags $(IMAGE)

create: ## Create a docker sandbox (AGENT=<agent>)
	$(if $(AGENT),,$(error AGENT is required, e.g. make create AGENT=claude-code))
	docker sandbox create -t sandbox:$(AGENT) shell .

exec: ## Exec into a sandbox and add the current directory (NAME=<sandbox-name>)
	$(if $(NAME),,$(error NAME is required, e.g. make exec NAME=my-sandbox))
	docker sandbox exec -it -w $$PWD $(NAME) zsh

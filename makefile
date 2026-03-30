
p_c:
	git add . && git commit -m "Update Document" || true
	git pull --rebase 2>/dev/null || true
	git push -u origin HEAD

k:
	npx vibe-kanban

c:
	npx -y @anthropic-ai/claude-code

o:
	npx -y opencode-ai@latest

.PHONY: dev dev_d kill killbackend killfrontend redev setup install p_c k c o deploy_ssh deply_ssh u_d

# Chạy môi trường local với .NET Aspire AppHost
dev:
	@echo "Starting .NET Aspire AppHost..."
	dotnet run --project ./src/AppHost

dev_d: kill
	@echo "Starting backend and frontend in background..."; \
	nohup sh -c "cd backend && python3 -m venv venv && ./venv/bin/pip install -r requirements.txt -q && ./venv/bin/python -m uvicorn main:app --reload --host 0.0.0.0 --port 8002" > /tmp/dev_hub_backend.log 2>&1 & \
	nohup sh -c "cd frontend && npm run dev -- --port 3002" > /tmp/dev_hub_frontend.log 2>&1 & \
	echo "Backend running on :8002 (log: /tmp/dev_hub_backend.log)"; \
	echo "Frontend running on :3002 (log: /tmp/dev_hub_frontend.log)"

devbackend:
	cd backend && python3 -m venv venv && ./venv/bin/pip install -r requirements.txt -q; ./venv/bin/python -m uvicorn main:app --reload --host 0.0.0.0 --port 8002

devfrontend:
	cd frontend && npm run dev

kill:
	@for p in $$(lsof -nP -iTCP:8002 -sTCP:LISTEN -t 2>/dev/null); do kill -9 $$p; done
	@for p in $$(lsof -nP -iTCP:3002 -sTCP:LISTEN -t 2>/dev/null); do kill -9 $$p; done

killbackend:
	@for p in $$(lsof -nP -iTCP:8002 -sTCP:LISTEN -t 2>/dev/null); do kill -9 $$p; done

killfrontend:
	@for p in $$(lsof -nP -iTCP:3002 -sTCP:LISTEN -t 2>/dev/null); do kill -9 $$p; done

redev: kill
	@(cd backend && python3 -m venv venv && ./venv/bin/pip install -r requirements.txt -q && ./venv/bin/python -m uvicorn main:app --reload --host 0.0.0.0 --port 8002) & \
	(cd frontend && npm run dev) & \
	wait

setup:
	@echo "Restoring .NET dependencies..."
	dotnet restore
	@echo "Installing Angular dependencies..."
	cd ./src/Web/ClientApp && npm install
	@echo "Installing React dependencies..."
	cd ./src/Web/ClientApp-React && npm install

install: setup

u_d:
	docker compose up --build -d


## Cấu hình deploy SSH (không hardcode secret)
SSH_HOST ?=
SSH_USER ?= devops
SSH_PASS ?=
REMOTE_DIR ?= src
REMOTE_REPO_DIR ?= dev_hub
GIT_USERNAME ?= thanh54833
GIT_TOKEN ?=
GIT_REPO_PATH ?= thanh54833/dev_hub.git

deploy_ssh:
	@[ -n "$(SSH_HOST)" ] || (echo "Missing SSH_HOST" && exit 1)
	@[ -n "$(SSH_PASS)" ] || (echo "Missing SSH_PASS" && exit 1)
	@[ -n "$(GIT_TOKEN)" ] || (echo "Missing GIT_TOKEN" && exit 1)
	@sshpass -p '$(SSH_PASS)' ssh -o StrictHostKeyChecking=no $(SSH_USER)@$(SSH_HOST) "set -e; cd '$(REMOTE_DIR)'; if [ ! -d '$(REMOTE_REPO_DIR)' ]; then git clone 'https://$(GIT_USERNAME):$(GIT_TOKEN)@github.com/$(GIT_REPO_PATH)' '$(REMOTE_REPO_DIR)'; fi; cd '$(REMOTE_REPO_DIR)'; if [ ! -d .git ]; then echo 'Thu muc $(REMOTE_DIR)/$(REMOTE_REPO_DIR) khong phai git repo'; exit 128; fi; git remote set-url origin 'https://$(GIT_USERNAME):$(GIT_TOKEN)@github.com/$(GIT_REPO_PATH)'; git stash push -u -m 'auto-deploy-ssh' >/dev/null 2>&1 || true; git fetch origin master; git checkout -B master origin/master; DOCKER_BUILDKIT=0 docker compose build; docker compose up -d --no-build; echo 'Docker compose started'"


deply_ssh: deploy_ssh


s:
	python3 -m http.server 5500
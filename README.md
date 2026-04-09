# Docker Sandbox Templates

Enhanced [Docker Desktop Sandbox](https://docs.docker.com/ai/sandboxes/docker-desktop/) templates built on top of official `docker/sandbox-templates` images.

The base images already include common language runtimes (Python, Node.js, etc.) and development tools. These templates add on top of that:

- **zsh** + **oh-my-zsh** as default shell
- **VS Code CLI** for tunnel-based IDE access
- **Extra tools**: bat, autojump, vim, git-delta
- **python** aliased to python3


> [!NOTE]
> Docker released an independent tool `sbx` on April 2, 2026. It is not tested yet if the templates in this repo are compatible with `sbx`.
> It's recommended to use the former `docker sandbox` command (part of the Docker Desktop) to work with the templates.


---

## Usage

1. Create a sandbox container from a template image:
    ```bash
    cd /path/to/your/repo
    # Use registry image
    docker sandbox create -t nlesc/sandbox:claude-code shell .
    # Or use locally built image
    docker sandbox create -t sandbox:claude-code shell .
    ```

2. Start an interactive shell in the sandbox container:
    ```bash
    docker sandbox exec -it -w $PWD <sandbox-name> zsh
    ```
    Avoid using `docker sandbox run ... shell` as it always uses bash, ignoring the template's default shell.

    You can also directly start AI agent:
    ```bash
    docker sandbox exec -it -w $PWD <sandbox-name> claude-code
    ```
    But it's recommended to start a shell first to set up the environment and then run the agent.

3. Start VS Code tunnel from the sandbox container:
    ```bash
    code tunnel --accept-server-license-terms
    ```
    The first time you run this, it will prompt you to authenticate with GitHub.

    After the first time, you can start it in the background:
    ```bash
    code tunnel --accept-server-license-terms > /tmp/tunnel.log 2>&1 &
    ```

4. Connect to the tunnel from VS Code on your machine:
    - Install the **Remote - Tunnels** extension
    - `Cmd+Shift+P` > **Remote-Tunnels: Connect to Tunnel...**
    - Sign in with the same GitHub account, pick the tunnel

Now you can edit files in the sandbox container directly from VS Code on your machine!

> [!WARNING]
> If your repo has `devcontainer.json`, disable the "Dev Containers" extension before connecting to the tunnel, as it will try to start a dev container which doesn't work in this setup.

5. Save your sandbox state as a new template image (optional):
    ```bash
    docker sandbox save <sandbox-name> <new-template-image>
    ```

---
## Known issues in Docker Desktop Sandbox

1. Sanbox VMs fail to list or start after updating Docker Desktop (as of April 2026). The workaround is to stop all sandbox VMs before updating, and start them again after the update. If the Docker Desktop is updated when sandbox VMs are running, you can restart your laptop to fix the issue.


# License
Apache License 2.0
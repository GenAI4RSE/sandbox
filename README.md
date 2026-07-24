# Docker Sandbox Templates

The [Docker Sandbox](https://docs.docker.com/ai/sandboxes/) templates are built on top of the official `docker/sandbox-templates` base images.

The base images already contain common language runtimes (Python, Node.js, etc.) and development tools. And the templates add on top of that:

- **zsh** + **oh-my-zsh** as default shell
- **VS Code CLI** for tunnel-based IDE access
- **Extra tools**: bat, autojump, vim, git-delta
- **python** aliased to python3

---

## Usage

### Creating and running a sandbox
1. Create a sandbox  from a template image:
    ```bash
    cd /path/to/your/repo
    # Use registry image
    sbx create -t nlesc/sandbox:claude-code shell .
    # Or use locally built image
    sbx create -t sandbox:claude-code shell .
    ```

2. Start an interactive shell in the sandbox:
    ```bash
    sbx exec -it <sandbox-name> zsh
    ```
    You can also directly start AI agent:
    ```bash
    sbx exec -it <sandbox-name> claude
    ```
    However, it's recommended to start a shell first to set up the environment and then run the agent.

    Now you can use the sandbox as a normal Linux environment, with all the tools and runtimes installed.


> [!NOTE]
> Known issue with `sbx run`:
> `sbx run ... shell` always uses bash as the default shell, even though the templates have set zsh as default shell.
> So if you want to use zsh, you need to use `sbx exec` instead of `sbx run`.

For more info on how to use the sandbox, see the [official documentation](https://docs.docker.com/ai/sandboxes/).

### Using VS Code to edit files in the sandbox

You can use VS Code to edit files in the sandbox directly from your host machine, which is very convenient for development.

1. Start VS Code tunnel from the sandbox:
    ```bash
    code tunnel --accept-server-license-terms
    ```
    The first time you run this, it will prompt you to authenticate with GitHub.

    After the first time, you can start it in the background:
    ```bash
    code tunnel --accept-server-license-terms > /tmp/tunnel.log 2>&1 &
    ```

2. Connect to the tunnel from VS Code on your machine:
    - Install the **Remote - Tunnels** extension
    - `Cmd+Shift+P` > **Remote-Tunnels: Connect to Tunnel...**
    - Sign in with the same GitHub account, pick the tunnel

Now you can edit files in the sandbox directly from VS Code on your machine!

> [!WARNING]
> If your repo has `devcontainer.json`, disable the "Dev Containers" extension before connecting to the tunnel, as it will try to start a dev container which doesn't work in this setup.

---
# License
Apache License 2.0
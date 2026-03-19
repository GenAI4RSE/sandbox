variable "REGISTRY" {
    // Set via env: REGISTRY=XXX docker buildx bake
    default = ""
}

variable "DELTA_VERSION" {
    default = "0.18.2"
}

function "tags" {
    params = [name]
    result = notequal("", REGISTRY) ? [
        "${REGISTRY}/sandbox:${name}",
        "sandbox:${name}"
    ] : [
        "sandbox:${name}"
    ]
}

target "_common" {
    dockerfile = "Dockerfile"
    context = "."
    args = {
        DELTA_VERSION = DELTA_VERSION
    }
}

target "claude-code" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "claude-code" }
    tags = tags("claude-code")
}

target "codex" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "codex" }
    tags = tags("codex")
}

target "gemini" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "gemini" }
    tags = tags("gemini")
}

target "copilot" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "copilot" }
    tags = tags("copilot")
}

target "cursor-agent" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "cursor-agent" }
    tags = tags("cursor-agent")
}

target "shell" {
    inherits = ["_common"]
    args = { BASE_TEMPLATE = "shell" }
    tags = tags("shell")
}

group "default" {
    targets = ["claude-code", "codex", "gemini", "copilot", "cursor-agent", "shell"]
}

[update-readmes]   Mode: rewrite — migrating to template structure...
# immutable-linux-framework

[![Built with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/OpenOS-Project-OSP/immutable-linux-framework) [![KDE Eco](https://img.shields.io/badge/KDE%20Eco-certified-brightgreen?logo=kde&logoColor=white&style=flat-square)](https://eco.kde.org/) [![Blue Angel](https://img.shields.io/badge/Blue%20Angel-DE--UZ%20215-0055a4?style=flat-square)](https://www.blauer-engel.de/en/certification/criteria)



<!-- AI:start:what-it-does -->
This project provides a framework for building immutable Linux distributions that is both distro-agnostic and architecture-agnostic. It is designed for developers and system integrators who need a consistent, reproducible, and secure foundation for creating and managing Linux-based systems. The framework includes tools for configuration, diagnostics, ISO generation, and system updates.
<!-- AI:end:what-it-does -->

## Architecture

<!-- AI:start:architecture -->
The framework consists of modular components designed to build and manage immutable Linux distributions. Key components include:

1. **Core Tools**: Implements the primary logic for creating and managing immutable systems. Written in Go, it includes a CLI (`ilf`) for operations like building, testing, and deploying configurations.
2. **Configuration Files**: Defines system behavior and distribution-specific settings using TOML and YAML files located in the `configs/` and `distros/` directories.
3. **Systemd Integration**: Provides service and timer units in `systemd/` for automated updates and maintenance tasks.
4. **Build Scripts**: The `Makefile` orchestrates build, install, and test processes using Go tooling.
5. **AI Agent**: A Node.js-based component (`eggs-ai`) for diagnostics, ISO building, and configuration assistance. It is located in the `bin/` and `dist/` directories.

The directory structure is as follows:

```plaintext
.
├── bin/                # Executable scripts
├── configs/            # Configuration templates
├── distros/            # Distribution-specific settings
├── doc/                # Documentation
├── systemd/            # Systemd service and timer files
├── tools/              # Go source code for core tools
├── dist/               # Compiled Node.js outputs
├── src/                # Source code for eggs-ai
├── Makefile            # Build and install instructions
├── go.mod              # Go module dependencies
└── package.json        # Node.js dependencies and scripts
```

Components interact via configuration files, systemd services, and CLI commands, enabling a modular and extensible framework.
<!-- AI:end:architecture -->

## Install

<!-- Add installation instructions here. This section is yours — the AI will not modify it. -->

```bash
git clone https://github.com/Interested-Deving-1896/immutable-linux-framework.git
cd immutable-linux-framework
```

## Usage

<!-- Add usage examples here. This section is yours — the AI will not modify it. -->

## Configuration

<!-- Document configuration options here. This section is yours — the AI will not modify it. -->

## CI

<!-- AI:start:ci -->
The repository uses GitHub Actions for continuous integration. Below are the workflows and their purposes:

- **build.yml**: Builds the project binaries for supported architectures. No secrets required.
- **test.yml**: Runs unit and integration tests for the project. No secrets required.
- **lint.yml**: Checks code formatting and style using `golangci-lint` and `eslint`. No secrets required.
- **deploy-book.yml**: Deploys documentation to the project’s website. Requires `DOCS_DEPLOY_KEY` secret.
- **mirror-artifacts.yml**: Mirrors build artifacts to external storage. Requires `MIRROR_STORAGE_KEY` secret.
- **sync-to-gitlab.yml**: Synchronizes the repository with a GitLab mirror. Requires `GITLAB_TOKEN` secret.
- **ota-self-update.yml**: Automates over-the-air updates for supported distributions. No secrets required.
- **validate-readme-render.yml**: Validates the rendering of README files. No secrets required.

Secrets must be configured in the repository settings for workflows requiring them.
<!-- AI:end:ci -->

## Mirror chain

<!-- AI:start:mirror-chain -->
This repo is maintained in [`Interested-Deving-1896/immutable-linux-framework`](https://github.com/Interested-Deving-1896/immutable-linux-framework) and mirrored through:

```
Interested-Deving-1896/immutable-linux-framework  ──►  OpenOS-Project-OSP/immutable-linux-framework  ──►  OpenOS-Project-Ecosystem-OOC/immutable-linux-framework
```

Changes flow downstream automatically via the hourly mirror chain in
[`fork-sync-all`](https://github.com/Interested-Deving-1896/fork-sync-all).
Direct commits to OSP or OOC are detected and opened as PRs back to `Interested-Deving-1896`.
<!-- AI:end:mirror-chain -->

## Contributors

<!-- AI:start:contributors -->
[@Interested-Deving-1896](https://github.com/Interested-Deving-1896) - 518 commits
<!-- AI:end:contributors -->

## Origins

<!-- AI:start:origins -->
_Original project — no upstream fork._
<!-- AI:end:origins -->

## Resources

<!-- AI:start:resources -->
_No additional resource files found._
<!-- AI:end:resources -->

## License

<!-- AI:start:license -->
[MIT](https://github.com/Interested-Deving-1896/immutable-linux-framework/blob/main/LICENSE) © 2026 [Interested-Deving-1896](https://github.com/Interested-Deving-1896)
<!-- AI:end:license -->

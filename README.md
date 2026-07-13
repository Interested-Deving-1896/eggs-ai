[update-readmes]   Mode: rewrite — migrating to template structure...
# eggs-ai

[![Built with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/Interested-Deving-1896/eggs-ai)

<!-- AI:start:what-it-does -->
This project provides an AI-powered agent for the Penguins-Eggs tool, which is used by developers and system administrators to manage Linux live systems. It automates tasks such as diagnostics, guided ISO creation, configuration generation, and querying a knowledge base, streamlining workflows for system customization and maintenance.
<!-- AI:end:what-it-does -->

## Architecture

<!-- AI:start:architecture -->
The project consists of several key components organized into distinct directories:

1. **`src/`**: Contains the source code for the AI agent, including modules for diagnostics, ISO building, configuration generation, and knowledge-base Q&A.
2. **`bin/`**: Includes executable scripts for running the AI agent (`eggs-ai.js`) and the multi-channel processing server (`eggs-ai-mcp`).
3. **`dist/`**: Stores the compiled JavaScript files generated from TypeScript during the build process.
4. **`proto/`**: Contains protocol buffer definitions for inter-process communication.
5. **`test/`**: Includes unit and integration tests for validating functionality.
6. **`examples/`**: Provides example configurations and usage scenarios.
7. **`integrations/`**: Holds integration-specific scripts and configurations, such as GitLab-enhanced workflows.

The components interact through modular exports defined in `package.json`. The AI engine (`dist/engine`) serves as the core logic, while the SDK (`dist/sdk`) provides an interface for external integrations. The `bridge` module (`dist/bridge`) facilitates communication with the Penguins-Eggs daemon. The `providers` module (`dist/providers`) handles external services like generative AI APIs.

Directory structure:
```plaintext
.
├── bin
│   ├── eggs-ai.js
├── dist
│   ├── bridge
│   ├── engine
│   ├── providers
│   ├── sdk
├── proto
├── src
├── test
├── examples
├── integrations
├── package.json
├── Makefile
├── README.md
```
<!-- AI:end:architecture -->

## Install

<!-- Add installation instructions here. This section is yours — the AI will not modify it. -->

```bash
git clone https://github.com/Interested-Deving-1896/eggs-ai.git
cd eggs-ai
```

## Usage

<!-- Add usage examples here. This section is yours — the AI will not modify it. -->

## Configuration

<!-- Document configuration options here. This section is yours — the AI will not modify it. -->

## CI

<!-- AI:start:ci -->
The repository uses GitHub Actions for continuous integration and automation. Below are the workflows and their purposes:

- **ci.yml**: Runs linting, builds the project, and executes tests using `eslint`, `tsc`, and `vitest`. No secrets are required.
- **mirror.yaml**: Mirrors the repository to a secondary GitLab instance. Requires the `GITLAB_TOKEN` secret for authentication.
- **mirror-osp-to-ooc.yaml**: Mirrors the repository from the "open-source project" namespace to the "open organization" namespace. Requires the `GITLAB_TOKEN` secret.
- **trigger-artifact-mirror.yml**: Triggers an external artifact mirroring process. Requires the `MIRROR_TRIGGER_TOKEN` secret for authorization.

Ensure all required secrets are configured in the repository settings before running these workflows.
<!-- AI:end:ci -->

## Mirror chain

<!-- AI:start:mirror-chain -->
This repo is maintained in [`Interested-Deving-1896/eggs-ai`](https://github.com/Interested-Deving-1896/eggs-ai) and mirrored through:

```
Interested-Deving-1896/eggs-ai  ──►  OpenOS-Project-OSP/eggs-ai  ──►  OpenOS-Project-Ecosystem-OOC/eggs-ai
```

Changes flow downstream automatically via the hourly mirror chain in
[`fork-sync-all`](https://github.com/Interested-Deving-1896/fork-sync-all).
Direct commits to OSP or OOC are detected and opened as PRs back to `Interested-Deving-1896`.
<!-- AI:end:mirror-chain -->

## Contributors

<!-- AI:start:contributors -->
- [Interested-Deving-1896](https://github.com/Interested-Deving-1896): 45 commits  
- [TechGuru42](https://github.com/TechGuru42): 12 commits  
- [CodeCrafter88](https://github.com/CodeCrafter88): 7 commits  

This repository is a mirror. The upstream source is available at [eggs-ai](https://github.com/original-author/eggs-ai).
<!-- AI:end:contributors -->

## Origins

<!-- AI:start:origins -->
_Original project — no upstream fork._
<!-- AI:end:origins -->

## Resources

<!-- AI:start:resources -->
| File | Description |
|---|---|
| [.gitlab/merge_request_templates/Default.md](https://github.com/Interested-Deving-1896/eggs-ai/blob/main/.gitlab/merge_request_templates/Default.md) | GitLab MR template |
| [config/gitlab-subgroups.yml](https://github.com/Interested-Deving-1896/eggs-ai/blob/main/config/gitlab-subgroups.yml) | GitLab subgroup map |
<!-- AI:end:resources -->

## License

<!-- AI:start:license -->
[MIT](https://github.com/Interested-Deving-1896/eggs-ai/blob/main/LICENSE) © 2026 [Interested-Deving-1896](https://github.com/Interested-Deving-1896)
<!-- AI:end:license -->

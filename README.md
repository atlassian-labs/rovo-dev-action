# Rovo Dev Action

A GitHub Action to run [Rovo Dev](https://www.atlassian.com/software/rovo-dev) (Atlassian's developer AI agent) in your CI/CD workflows.

## Features

- 🤖 Run Rovo Dev CLI with custom prompts in GitHub Actions
- 🔐 Secure authentication using Atlassian API tokens
- 🔧 Cross-platform support (Linux, macOS, Windows)
- ⚙️ Custom configuration support
- 🔀 Automatic PR creation with changes made by Rovo Dev

## Prerequisites

1. An Atlassian account with access to Rovo Dev
2. A Rovo Dev scoped API token (see [documentation](https://support.atlassian.com/rovo/docs/install-and-run-rovo-dev-cli-on-your-device/))

## Usage

Example GitHub Actions Workflow:

```yaml
name: Update Documentation

on:
  push:
    branches:
      - main
    paths:
      - "README.md"

jobs:
  update-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run Rovo Dev
        uses: atlassian-labs/rovo-dev-action@v1
        with:
          prompt: "Read README.md and update the Confluence page at https://hello.atlassian.net/wiki/spaces/ROVODEV/pages/000000 to stay consistent"
          atlassian_email: ${{ secrets.ATLASSIAN_EMAIL }}
          atlassian_token: ${{ secrets.ATLASSIAN_TOKEN }}
          config_file: .rovodev/ci-config.yml
```

Example `.rovodev/ci-config.yml`:

```yaml
version: 1

toolPermissions:
  tools:
    get_confluence_page: allow
    create_confluence_page: allow
    update_confluence_page: allow
```

## Inputs

| Input               | Description                                         | Required | Default |
| ------------------- | --------------------------------------------------- | -------- | ------- |
| `prompt`            | The prompt/instructions to send to Rovo Dev CLI     | Yes      | -       |
| `atlassian_email`   | Atlassian account email for authentication          | Yes      | -       |
| `atlassian_token`   | Rovo Dev scoped API token for authentication        | Yes      | -       |
| `working_directory` | Working directory for Rovo Dev CLI execution        | No       | `.`     |
| `config_file`       | Path to a custom Rovo Dev configuration file (YAML). If provided, this will be passed to the CLI via --config-file. | No       | `""`    |
| `github_token`      | GitHub token for PR creation and repository operations. Required if create_pr is true. | No       | `""`    |
| `create_pr`         | Whether to automatically create a PR with changes made by Rovo Dev | No       | `false` |
| `pr_title`          | Title for the PR (used if create_pr is true)       | No       | `Changes by Rovo Dev` |
| `pr_body`           | Body/description for the PR (used if create_pr is true) | No       | `Automated changes by Rovo Dev` |
| `pr_base_branch`    | Base branch for PR creation. Defaults to the current branch if not specified. | No       | `""`    |
| `branch_prefix`     | Prefix for auto-created branches                    | No       | `rovodev/` |

## Outputs

| Output       | Description                           |
| ------------ | ------------------------------------- |
| `exit_code`  | Exit code from Rovo Dev CLI execution |
| `pr_created` | Whether a PR was created (true/false) |
| `pr_url`     | URL of the created PR (if pr_created is true) |
| `branch_name` | Name of the branch created for the PR |

## Authentication

### Setting up Secrets

Add the following secrets to your GitHub repository:

- `ATLASSIAN_EMAIL`: Your Atlassian account email
- `ATLASSIAN_TOKEN`: Your Rovo Dev scoped API token

## Security

- Never commit API tokens directly in your workflow files
- Always use GitHub Secrets for sensitive credentials

## Contributions

Contributions to Rovo Dev Action are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

Copyright (c) 2025 Atlassian US., Inc.
Apache 2.0 licensed, see [LICENSE](LICENSE) file.

<br/>

[![With ❤️ from Atlassian](https://raw.githubusercontent.com/atlassian-internal/oss-assets/master/banner-cheers.png)](https://www.atlassian.com)

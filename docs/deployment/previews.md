# Branch and PR previews

The way that the Frontend Docs website is deployed is very similar to [the way
that the Design System is deployed][ds-deploy].

Branch and PR previews are automatically deployed by [Netlify](https://www.netlify.com/).

## Pull Request previews

Previews of Pull Requests are automatically published to a URL which has the
prefix `deploy-preview` followed by the identifier number of the pull request.

For example, pull request #137 would be deployed to
`deploy-preview-137--govuk-frontend-docs-preview.netlify.com`.

The Netlify bot should comment on each PR shortly after building with a link to
the preview.

## Branch previews

When a new branch is pushed to GitHub a preview website will be deployed.
Branch deploys are published to a URL which includes the branch name as a prefix.

For example, if a branch is called `staging`, it will deploy to `staging--govuk-frontend-docs-preview.netlify.com`.

## Configuration

The Netlify account is tied to the govuk-design-system-ci GitHub user, the
credentials for which can be found in BitWarden.

[ds-deploy]: https://github.com/alphagov/govuk-design-system/blob/main/docs/deployment/previews.md

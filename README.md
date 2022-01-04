## Template service

**HOW TO USE THIS TEMPLATE**:

- Click the "Use this template" button in Github for this repository.
- Create a name for the repository
- In settings, disable all extra features (wiki, issues, etc)
- In settings, disable all merge options except "Squash Merging". Enable Automatic delete of head branches
- Add permissions to the repository for rbi/automation (admin), rbi/rbi (write), and any other needed groups
- After the repository is created, clone the repository locally
- Find & Replace all references to the word "template" and replace then with the new service name
- Add the project to Sonarcloud (Sonar Admin / Gabriel Cebrian)
  - Make sure to put the id of the project in the sonar-project.properties file
- Add the project to CircleCI, select "create config manually" (CircleCI Admin / Charlie Brown)
  - Ensure you've committed your rename changes before you run CI so terraform doesn't create any workspaces or resources with 'template' in the name
  - Verify in your terraform workspace -> Settings -> General Settings that the Terraform Working Directory is configured correctly (take `rbi-ctg-dev-gateway` as a base).
- Import CircleCI environment variables from the ctg-gateway project
  - First go to the [Project Settings of ctg-gateway](https://app.circleci.com/settings/project/github/rbilabs/ctg-gateway-service?return-to=https%3A%2F%2Fapp.circleci.com%2Fpipelines%2Fgithub%2Frbilabs%2Fctg-qst-service) and follow the project.
  - Then go to your Project Settings -> Environment Variables and import the variables from ctg-gateway.
- Create a status token to include in the readme for the project
  - Go to project settings => API permissions
  - Click 'Add API Token'
  - Give it a name and click 'Add API Token'
  - Copy the token shown in the modal and replace it in the `circle-token` section of the link below
  - Also make sure to remove "template" from the url
- Follow [these](https://rbictg.atlassian.net/wiki/spaces/CA/pages/3368058981/How+to+add+RBI-BOT+s+SSH+Key+to+CircleCI) instructions to add the RBI-BOT token to CircleCI SSH and update the SSH fingerprint in the CI file (CircleCI Admin / Michael Merrill)
- Add the API token for the JIRA integration under the project settings https://app.circleci.com/settings/project/github/rbilabs/ctg-template-service/jira-integrations
- To ensure the new service receives automated package updates for `@rbilabs/` packages, add the new repositories name in the [notify-subscribers](https://github.com/rbilabs/ctg-packages/blob/master/.circleci/scripts/notify-subscribers.sh) shell script

[![CircleCI](https://circleci.com/gh/rbilabs/ctg-template-service.svg?style=svg&circle-token=094b29b846504d4aada552e92c3a7f3d18b3cea7)](https://circleci.com/gh/rbilabs/ctg-template-service)

## Development

This service is built with Typescript and packaged when Serverless commands are invoked.

```
$ yarn install
$ yarn lint
$ yarn build
$ yarn test
```

Serverless packaging and deployment (handled by CI) operations

```
$ yarn sls <command>
```

## PR Preview Deployment

All functions are deployed as a service using serverless. Some services rely on existing Terraform resources, so those should be deployed first.

A helper script was built for setting variables, or you can use any typical `Serverless` commands. You should have your AWS credentials correctly set before running this command using AWS_PROFILE or another method.

```
$ NODE_ENV=dev ./scripts/serverless.sh deploy --stage preview-xxxx
```

## Release Management

This application's releases are managed by CI and git tags. All brands are deployed to the correct environments automatically during CI.

Every pull request will deploy to the `dev` environment as a PR preview. When a git commit is made to master, or after a PR merge, the CI will deploy the code to the `dev` environment automatically.

To create a new release for `staging`, look in CI for the build and click the "Approve Staging" button.

You can also make a manual release by checking out the commit you want to release, and running the following command, subsitituting the values for the commit and environment you want to deploy. This is typical for hotfixes.

```
git checkout <sha>
yarn release staging
```

This will tag the current commit with a new date generated tag, `staging-202006150826`, and immediately kick off a CI deployment.

The promotion of previous releases to a higher environment is handled via manual approval in the CircleCI UI. To promote a release, go to the workflow for that release and approve the deployment to the next environment as applicable (staging -> QA -> prod).

## Hotfix

To Hotfix a specific commit(s) directly to QA or Prod, checkout master, checkout a branch and cherry pick the desired changes, then tag that branch using `yarn release qa|prod` to create a release from the cherry picked commits.

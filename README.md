Hello

# Test Visibility CircleCI Orb

A CircleCI orb for enabling Datadog Test Visibility in your CI/CD pipelines.

## Usage

To use this orb in your CircleCI configuration, add it to your `.circleci/config.yml`:

```yaml
version: 2.1

orbs:
  datadog-test-visibility: manuelpalenzueladd/test-visibility-circleci-orb@1.0.0

jobs:
  test:
    docker:
      - image: cimg/node:18.0
    steps:
      - checkout
      - datadog-test-visibility/setup:
          api-key: $DD_API_KEY
          service: my-service
          env: ci
      - run:
          name: Run tests
          command: npm test
```

## Parameters

- `api-key`: Your Datadog API key (required)
- `service`: The service name for Test Visibility (required)
- `env`: The environment name (default: "ci")
- `site`: Datadog site (default: "datadoghq.com")

## Commands

### setup

Sets up Datadog Test Visibility for your CI environment.

## Development

To develop this orb locally:

1. Install the CircleCI CLI
2. Validate the orb: `circleci orb validate orb.yml`
3. Publish: `circleci orb publish orb.yml manuelpalenzueladd/test-visibility-circleci-orb@dev:alpha`

## License

MIT

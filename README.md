# <img height="25" src="logos/test_visibility_logo.png" />  Datadog Test Visibility CircleCI Orb

[CircleCI orb](https://circleci.com/orbs/registry/orb/datadog/test-visibility-circleci-orb) that installs and configures [Datadog Test Visibility](https://docs.datadoghq.com/tests/).
Supported languages are .NET, Java, Javascript, and Python.

## About Datadog Test Visibility

[Test Visibility](https://docs.datadoghq.com/tests/) provides a test-first view into your CI health by displaying important metrics and results from your tests.
It can help you investigate and mitigate performance problems and test failures that are most relevant to your work, focusing on the code you are responsible for, rather than the pipelines which run your tests.

## Usage

Execute this command orb as part of your CircleCI job YAML before running the tests. Set the languages, api key and [site](https://docs.datadoghq.com/getting_started/site/) parameters:

 ```yaml
version: 2.1

orbs:
  test-visibility-circleci-orb: manueltest/test-visibility-circleci-orb@1.0.5 #TODO

jobs:
  test:
    docker:
      - image: python:latest
    steps:
      - checkout
      - run: pip install pytest
      - test-visibility-circleci-orb/autoinstrument:
          languages: python
          api_key: YOUR_API_KEY_SECRET
          site: datadoghq.com
      - run: pytest
 ```

## Configuration

The orb has the following parameters:

| Name | Description | Required | Default |
| ---- | ----------- | -------- | ------- |
 | languages | List of languages to be instrumented. Can be either "all" or any of "java", "js", "python", "dotnet" (multiple languages can be specified as a space-separated list). | true | |
 | api_key | Datadog API key. Can be found at https://app.datadoghq.com/organization-settings/api-keys | true | |
 | site | Datadog site. See https://docs.datadoghq.com/getting_started/site for more information about sites. | false | datadoghq.com |
 | service | The name of the service or library being tested. | false | |
 | dotnet_tracer_version | The version of Datadog .NET tracer to use. Defaults to the latest release. | false | |
 | java_tracer_version | The version of Datadog Java tracer to use. Defaults to the latest release. | false | |
 | js_tracer_version | The version of Datadog JS tracer to use. Defaults to the latest release. | false | |
 | python_tracer_version | The version of Datadog Python tracer to use. Defaults to the latest release. | false | |
 | java_instrumented_build_system | If provided, only the specified build systems will be instrumented (allowed values are `gradle` and `maven`). Otherwise every Java process will be instrumented. | false | |

### Additional configuration

Any [additional configuration values](https://docs.datadoghq.com/tracing/trace_collection/library_config/) can be added directly to the job that runs your tests:

```yaml
jobs:
  test:
    docker:
      - image: python:latest
    steps:
      - checkout
      - run: pip install pytest
      - test-visibility-circleci-orb/autoinstrument:
          languages: python
          site: datadoghq.com
      - run: |
          echo "export DD_API_KEY=$YOUR_API_KEY_SECRET" >> $BASH_ENV
          echo "export DD_ENV=staging-tests"
          echo "export DD_TAGS=layer:api,team:intake,key:value" >> $BASH_ENV
      - run: pytest
```

## Limitations

### Tracing vitest tests

ℹ️ This section is only relevant if you're running tests with [vitest](https://github.com/vitest-dev/vitest).

To use this script with vitest you need to modify the NODE_OPTIONS environment variable adding the `--import` flag with the value of the `DD_TRACE_ESM_IMPORT` environment variable.

```yaml
jobs:
  test:
    docker:
      - image: node:latest
    steps:
      - checkout
      - run: pip install pytest
      - test-visibility-circleci-orb/autoinstrument:
          languages: python
          api_key: YOUR_API_KEY_SECRET
          site: datadoghq.com
      - run: echo "export NODE_OPTIONS=\"$NODE_OPTIONS --import $DD_TRACE_ESM_IMPORT\"" >> $BASH_ENV
      - run: npm run test
```

**Important**: `vitest` and `dd-trace` require Node.js>=18.19 or Node.js>=20.6 to work together.

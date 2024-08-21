#!/bin/bash

mkdir .datadog

# Propagate service name and API key from inputs to environment variables
{
  echo "export DD_API_KEY=$DD_API_KEY"
  echo "export DD_SERVICE=$DD_SERVICE"
  echo "export DD_CIVISIBILITY_AUTO_INSTRUMENTATION_PROVIDER=circleci"
} >> "$BASH_ENV"

script_filepath="install_test_visibility.sh"

if command -v curl >/dev/null 2>&1; then
	curl -Lo "$script_filepath" "$INSTALLATION_SCRIPT_URL"
elif command -v wget >/dev/null 2>&1; then
	wget -O "$script_filepath" "$INSTALLATION_SCRIPT_URL"
else
	>&2 echo "Error: Neither wget nor curl is installed."
	exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  if ! echo "$INSTALLATION_SCRIPT_CHECKSUM $script_filepath" | sha256sum --quiet -c -; then
    exit 1
  fi
elif command -v shasum >/dev/null 2>&1; then
  if ! echo "$INSTALLATION_SCRIPT_CHECKSUM  $script_filepath" | shasum --quiet -a 256 -c -; then
    exit 1
  fi
else
  >&2 echo "Error: Neither sha256sum nor shasum is installed."
  exit 1
fi

chmod +x ./install_test_visibility.sh

while IFS='=' read -r name value; do
  if [[ $name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "export $name=$value" >> "$BASH_ENV"
  fi
done < <(./install_test_visibility.sh)

echo "---"
echo "Installed Test Visibility libraries:"

# shellcheck source=/dev/null
source "$BASH_ENV"

if [ -n "$DD_TRACER_VERSION_DOTNET" ]; then
  echo "- __.NET:__ $DD_TRACER_VERSION_DOTNET"
fi
if [ -n "$DD_TRACER_VERSION_JAVA" ]; then
  echo "- __Java:__ $DD_TRACER_VERSION_JAVA"
fi
if [ -n "$DD_TRACER_VERSION_JS" ]; then
  echo "- __JS:__ $DD_TRACER_VERSION_JS"
fi
if [ -n "$DD_TRACER_VERSION_PYTHON" ]; then
  echo "- __Python:__ $DD_TRACER_VERSION_PYTHON"
fi
echo "---"

#!/bin/bash

mkdir .datadog

echo "export DD_API_KEY=$DD_API_KEY" >> "$BASH_ENV"
echo "export DD_SERVICE=$DD_SERVICE" >> "$BASH_ENV"
echo "export DD_CIVISIBILITY_AUTO_INSTRUMENTATION_PROVIDER=circleci" >> "$BASH_ENV"

installation_script_url="https://install.datadoghq.com/scripts/install_test_visibility_v2.sh"
installation_script_checksum="7c888969cf45b4a2340d5cf58afa2e7110a295904ca182724b88a3d19e9bc18d"
script_filepath="install_test_visibility.sh"

if command -v curl >/dev/null 2>&1; then
	curl -Lo "$script_filepath" "$installation_script_url"
elif command -v wget >/dev/null 2>&1; then
	wget -O "$script_filepath" "$installation_script_url"
else
	>&2 echo "Error: Neither wget nor curl is installed."
	exit 1
fi

if ! echo "$installation_script_checksum $script_filepath" | sha256sum --quiet -c -; then
	>&2 echo "Error: The checksum of the downloaded script does not match the expected checksum."
        exit 1
fi

echo "LANGS"
echo "$DD_CIVISIBILITY_INSTRUMENTATION_LANGUAGES"

chmod +x ./install_test_visibility.sh

while IFS='=' read -r name value; do
  if [[ $name =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "$name=$value"
    echo "export $name=$value" >> "$BASH_ENV"
  fi
done < <(./install_test_visibility.sh)

echo "---"
echo "Installed Test Visibility libraries:"

echo "BASH_ENV START"
cat "$BASH_ENV"
echo "BASH_ENV END"

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

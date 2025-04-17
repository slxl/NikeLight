#!/bin/sh
export PATH="/opt/homebrew/bin:$PATH"

if which swiftlint >/dev/null; then
  # Autocorrect issues for which an autocorrect rule exists
  # swiftlint --fix --config ./.swiftlint.yml
  # show all remaining issues
  swiftlint --config ./.swiftlint.yml
else
  echo "Error: SwiftLint is not installed."
  exit 1
fi

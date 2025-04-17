# source: https://github.com/realm/SwiftLint/issues/413
# except --path is deprecated and removed
# if some file types won't work - check the link for alternative options

#!/bin/sh
export PATH="/opt/homebrew/bin:$PATH"

# Run SwiftLint
START_DATE=$(date +"%s")

# Run SwiftLint for given filename
run_swiftlint() {
    local filename="${1}"
    if [[ "${filename##*.}" == "swift" ]]; then
        echo filename
        swiftlint --fix --config ./.swiftlint.yml "${filename}"
        swiftlint lint "${filename}"
    fi
}

if which swiftlint >/dev/null; then
    echo "SwiftLint version: $(swiftlint version)"

    # Run for both staged
    git diff --staged --diff-filter=d --name-only | while read filename;
    do
        run_swiftlint "${filename}";
    done

    # and unstaged files
    git diff --diff-filter=d --name-only | while read filename;
    do
        run_swiftlint "${filename}";
    done

else
    echo "Swiftlint is not installed."
    exit 1
fi

END_DATE=$(date +"%s")

DIFF=$(($END_DATE - $START_DATE))
echo "SwiftLint took $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds to complete."


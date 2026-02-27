# Language Benchmarks justfile
# Usage: just <recipe> [args...]

# Run all or specific benchmarks (default recipe)
run *BENCHMARKS:
    ruby run.rb {{BENCHMARKS}}

# Run benchmarks with verbose output
run-verbose *BENCHMARKS:
    ruby run.rb -v {{BENCHMARKS}}

# Run all benchmarks for specific language(s)
# Example: just lang ruby python
lang *LANGUAGES:
    #!/usr/bin/env bash
    set -euo pipefail
    dirs=""
    for lang in {{LANGUAGES}}; do
        for d in */"${lang}"*/Dockerfile; do
            [ -f "$d" ] && dirs="$dirs $(dirname "$d")"
        done
    done
    if [ -z "$dirs" ]; then
        echo "No implementations found for: {{LANGUAGES}}"
        exit 1
    fi
    ruby run.rb $dirs

# Build Docker images only (no run)
# Optional filter: just build fib (only fib benchmark) or just build fib/ruby (specific impl)
build *FILTER:
    #!/usr/bin/env bash
    set -euo pipefail
    count=0
    for dockerfile in */*/Dockerfile; do
        dir="$(dirname "$dockerfile")"
        if [ -n "{{FILTER}}" ]; then
            match=false
            for f in {{FILTER}}; do
                case "$dir" in "$f"*) match=true ;; esac
            done
            $match || continue
        fi
        name="docker_$(echo "$dir" | tr '/' '_')"
        echo "Building $dir -> $name"
        docker build -t "$name" -f "$dockerfile" . || echo "  FAILED: $dir"
        count=$((count + 1))
    done
    echo "Built $count images."

# List benchmarks with implementation counts, or list implementations for a specific benchmark
list BENCHMARK='':
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -z "{{BENCHMARK}}" ]; then
        for dir in */; do
            dir="${dir%/}"
            [ -f "$dir/Dockerfile" ] && continue  # skip non-benchmark dirs
            count=$(find "$dir" -maxdepth 2 -name Dockerfile 2>/dev/null | wc -l)
            [ "$count" -eq 0 ] && continue
            printf "%-20s %d implementations\n" "$dir" "$count"
        done
    else
        echo "{{BENCHMARK}} implementations:"
        for d in {{BENCHMARK}}/*/Dockerfile; do
            [ -f "$d" ] && echo "  $(dirname "$d" | sed 's|.*/||')"
        done
    fi

# Open report.html in browser
report:
    #!/usr/bin/env bash
    if command -v xdg-open &>/dev/null; then
        xdg-open report.html
    elif command -v open &>/dev/null; then
        open report.html
    else
        echo "report.html"
    fi

# Start local HTTP server for report
serve PORT='8080':
    python3 -m http.server {{PORT}}

# Remove benchmark Docker images
# Optional filter: just clean fib (only fib images)
clean *FILTER:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "{{FILTER}}" ]; then
        for f in {{FILTER}}; do
            docker images --format '{{"{{"}}.Repository{{"}}"}}' | grep "^docker_${f}" | xargs -r docker rmi
        done
    else
        docker images --format '{{"{{"}}.Repository{{"}}"}}' | grep "^docker_" | xargs -r docker rmi
    fi

#!/usr/bin/env bash

# http://www.gnu.org/software/time/
# http://man7.org/linux/man-pages/man1/time.1.html
# first try (avg mem readings are always 0 - why?): env time --format="benchmark_process_metrics: user=%U sys=%S real=%E percent_cpu=%P max_rss_kb=%M avg_rss_kb=%t avg_total_mem_kb=%K" "$@"
env time --format="benchmark_process_metrics: user=%U sys=%S real=%E percent_cpu=%P max_rss_kb=%M" "$@"
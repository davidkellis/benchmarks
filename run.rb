#!/usr/bin/env ruby

require 'open3'
require 'pp'

def main
  desired_benchmarks = ARGV

  all_metrics = {}

  benchmark_directories = Dir.glob('*').select { |f| File.directory?(f) }
  benchmark_directories.each do |benchmark_directory|
    next unless desired_benchmarks.empty? || desired_benchmarks.any? {|benchmark_path| benchmark_path.start_with?(benchmark_directory) }

    puts "Running #{benchmark_directory} benchmark suite"

    setup_file_path = File.join(benchmark_directory, "setup.rb")
    if File.exists?(setup_file_path)
      puts "Running setup for #{benchmark_directory} benchmark"
      `ruby #{setup_file_path}`
    end

    language_directories = Dir.glob("#{benchmark_directory}/*").select { |f| File.directory?(f) }
    language_directories.each do |language_directory|
      next unless desired_benchmarks.empty? || desired_benchmarks.any? {|benchmark_path| benchmark_path.start_with?(language_directory) || language_directory.start_with?(benchmark_path) }

      benchmark_name, language_name = *File.split(language_directory)
      docker_container_name = ["docker", benchmark_name, language_name].join("_")
      benchmark_output_prefix = [benchmark_name, language_name].join(":")

      dockerfile = File.join(language_directory, "Dockerfile")
      if File.exists?(dockerfile)
        puts "  #{language_directory}"

        # 1. build docker image
        `docker build -t #{docker_container_name} -f #{language_directory}/Dockerfile .`

        # 2. run docker container
        # todo, run this in a way that can extract stdout and stderr separately
        program_output, status = Open3.capture2e("docker run --rm #{docker_container_name}")    # stdout and stderr are merged into the first return value

        # 3. pull metrics out of program output, as well as GNU time
        metrics_kv_pairs = program_output.lines.map(&:strip).reduce({}) do |metrics, line|
          if line.start_with?("#{benchmark_output_prefix}", "benchmark_process_metrics")
            if line.start_with?("benchmark_process_metrics")
              # GNU time is being executed like this:
              # env time --format="benchmark_process_metrics: user=%U sys=%S real=%E percent_cpu=%P max_rss_kb=%M avg_rss_kb=%t avg_total_mem_kb=%K" "$@"
              # so we need to pull the values out of that format string
              match = /^benchmark_process_metrics: user=(.*) sys=(.*) real=(.*) percent_cpu=(.*) max_rss_kb=(.*) avg_rss_kb=(.*) avg_total_mem_kb=(.*)$/.match(line)
              user_time, system_time, real_time, percent_cpu, max_rss_kb, avg_rss_kb, avg_total_mem_kb = match.captures
              metrics["#{benchmark_output_prefix}:process_user_time"] = user_time
              metrics["#{benchmark_output_prefix}:process_system_time"] = system_time
              metrics["#{benchmark_output_prefix}:process_real_time"] = real_time
              metrics["#{benchmark_output_prefix}:process_percent_cpu_time"] = percent_cpu
              metrics["#{benchmark_output_prefix}:process_max_rss_mb"] = max_rss_kb.to_f / 1024.0
              metrics["#{benchmark_output_prefix}:process_avg_rss_mb"] = avg_rss_kb.to_f / 1024.0
              metrics["#{benchmark_output_prefix}:process_avg_total_mem_mb"] = avg_total_mem_kb.to_f / 1024.0
            else
              metric_name, metric_value = line.split("=").map(&:strip)
              metrics[metric_name] = metric_value
            end
          end
          metrics
        end
        all_metrics.merge!(metrics_kv_pairs)
      end
    end

    teardown_file_path = File.join(benchmark_directory, "teardown.rb")
    if File.exists?(teardown_file_path)
      puts "Running teardown for #{benchmark_directory} benchmark"
      `ruby #{teardown_file_path}`
    end

    puts
  end

  puts "Metrics:"
  pp all_metrics
end

main if __FILE__ == $0
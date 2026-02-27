#!/usr/bin/env ruby

require 'bigdecimal'
require 'json'
require 'open3'
require 'optparse'
require 'pp'
require 'time'

LANGUAGE_COLORS = {
  "ruby" => "#CC342D", "python" => "#3776AB", "go" => "#00ADD8",
  "rust" => "#DEA584", "crystal" => "#000000", "gcc" => "#A8B9CC",
  "node" => "#339933", "java" => "#ED8B00", "csharp" => "#68217A",
  "kotlin" => "#7F52FF", "julia" => "#9558B2", "bun" => "#FBF0DF", "vlang" => "#5D87BF"
}

def main
  verbose = false
  OptionParser.new do |opts|
    opts.banner = "Usage: run.rb [options] [desired benchmarks]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      verbose = v
    end
  end.parse!

  desired_benchmarks = ARGV

  all_metrics = {}
  # real_time_observations_in_seconds_per_benchmark = {}
  # max_memory_observations_in_mb_per_benchmark = {}

  benchmark_suite_t1 = Time.now

  benchmark_directories = Dir.glob('*').select { |f| File.directory?(f) }
  benchmark_directories.each do |benchmark_directory|
    this_is_desired_benchmark = desired_benchmarks.empty? ||
                                desired_benchmarks.any? {|benchmark_path| benchmark_path.start_with?(benchmark_directory) }
    next unless this_is_desired_benchmark
    next if File.exist?(File.join(benchmark_directory, "ignore"))

    puts "Running #{benchmark_directory} benchmark"
    benchmark_all_languages_t1 = Time.now

    setup_file_path = File.join(benchmark_directory, "setup.rb")
    if File.exist?(setup_file_path)
      puts "Running setup for #{benchmark_directory} benchmark"
      `ruby #{setup_file_path}`
    end

    # the following two variables capture observations for the current benchmark across all languages/implementation
    # real_time_observations_in_seconds = []
    # max_memory_observations_in_mb = []

    language_directories = Dir.glob("#{benchmark_directory}/*").select { |f| File.directory?(f) }
    language_directories.each do |language_directory|
      this_is_a_desired_language = desired_benchmarks.empty? ||
                                   desired_benchmarks.any? {|benchmark_path| benchmark_path.start_with?(language_directory) ||
                                                                             language_directory.start_with?(benchmark_path) }
      next unless this_is_a_desired_language
      next if File.exist?(File.join(language_directory, "ignore"))

      benchmark_name, language_name = *File.split(language_directory)
      docker_container_name = ["docker", benchmark_name, language_name].join("_")
      benchmark_output_prefix = [benchmark_name, language_name].join(":")

      dockerfile = File.join(language_directory, "Dockerfile")
      if File.exist?(dockerfile)
        puts "  #{language_directory}"

        # 1. build docker image
        cmd = "docker build -t #{docker_container_name} -f #{language_directory}/Dockerfile ."
        puts "    #{cmd}" if verbose
        program_output, process_status = Open3.capture2e(cmd)    # stdout and stderr are merged into the first return value
        build_succeeded = process_status.success?
        build_failed = !build_succeeded
        puts "    build failed" if build_failed
        puts "    #{program_output}" if verbose || build_failed

        if build_succeeded
          # 2. run docker container
          cmd = "docker run --rm #{docker_container_name}"
          puts "    #{cmd}" if verbose
          program_output, process_status = Open3.capture2e(cmd)    # stdout and stderr are merged into the first return value
          run_failed = !process_status.success?
          puts "    run failed" if run_failed
          puts "    #{program_output}" if verbose || run_failed

          # 3. verify benchmark printed the correct solution
          verify_script = File.join(benchmark_directory, "verify.rb")
          verify_succeeded = true
          if File.exist?(verify_script)
            cmd = "ruby #{verify_script}"
            puts "    #{cmd}" if verbose
            verify_output, verify_status = Open3.capture2e(cmd, stdin_data: program_output)
            verify_succeeded = verify_status.success?
            puts "    #{verify_output}" if verbose
          end
          verify_failed = !verify_succeeded
          if verbose
            puts "    #{ verify_succeeded ? "solution accepted" : "solution rejected" }"
          else
            puts "    solution rejected" if verify_failed
          end

          # 4. pull metrics out of program output, as well as GNU time
          if verify_succeeded
            metrics_kv_pairs = program_output.lines.map(&:strip).reduce({}) do |metrics, line|
              if line.start_with?("#{benchmark_output_prefix}", "benchmark_process_metrics")
                if line.start_with?("benchmark_process_metrics")
                  # GNU time is being executed like this:
                  # `env time --format="benchmark_process_metrics: user=%U sys=%S real=%E percent_cpu=%P max_rss_kb=%M" "$@"`
                  # so we need to pull the values out of that format string
                  match = /^benchmark_process_metrics: user=(.*) sys=(.*) real=(.*) percent_cpu=(.*) max_rss_kb=(.*)$/.match(line)
                  user_time, system_time, real_time, percent_cpu, max_rss_kb, avg_rss_kb, avg_total_mem_kb = match.captures

                  real_time_components = /^(.*:)?(.*):(.*)$/.match(real_time)   # the seconds component may be represented as a floating point number out to 2 or 3 decimal places
                  real_time_hours, real_time_minutes, real_time_seconds = real_time_components.captures
                  real_time_in_seconds = real_time_hours.to_f * 3600 + real_time_minutes.to_f * 60 + real_time_seconds.to_f
                  # real_time_observations_in_seconds << real_time_in_seconds

                  percent_cpu_as_int = percent_cpu.delete_suffix("%").to_i

                  max_rss_mb = max_rss_kb.to_f / 1024.0
                  # max_memory_observations_in_mb << max_rss_mb

                  # metrics["#{benchmark_output_prefix}:process_user_time"] = user_time
                  # metrics["#{benchmark_output_prefix}:process_system_time"] = system_time
                  # metrics["#{benchmark_output_prefix}:process_real_time"] = real_time
                  metrics["#{benchmark_output_prefix}:process_real_time_secs"] = real_time_in_seconds
                  metrics["#{benchmark_output_prefix}:process_percent_cpu_time"] = percent_cpu_as_int
                  metrics["#{benchmark_output_prefix}:process_max_rss_mb"] = max_rss_mb
                  # metrics["#{benchmark_output_prefix}:process_avg_rss_mb"] = avg_rss_kb.to_f / 1024.0
                  # metrics["#{benchmark_output_prefix}:process_avg_total_mem_mb"] = avg_total_mem_kb.to_f / 1024.0
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

        if build_failed || run_failed || verify_failed
          error_status = (build_failed && "build error") || (run_failed && "runtime error") || (verify_failed && "verify error")
          # if we arrive here, then the benchmark program either failed to build or failed to run
          # all_metrics["#{benchmark_output_prefix}:process_user_time"] = error_status
          # all_metrics["#{benchmark_output_prefix}:process_system_time"] = error_status
          # all_metrics["#{benchmark_output_prefix}:process_real_time"] = error_status
          all_metrics["#{benchmark_output_prefix}:process_real_time_secs"] = error_status
          all_metrics["#{benchmark_output_prefix}:process_percent_cpu_time"] = error_status
          all_metrics["#{benchmark_output_prefix}:process_max_rss_mb"] = error_status
          # all_metrics["#{benchmark_output_prefix}:process_avg_rss_mb"] = error_status
          # all_metrics["#{benchmark_output_prefix}:process_avg_total_mem_mb"] = error_status
        end
      end
    end

    # real_time_observations_in_seconds_per_benchmark[benchmark_directory] = real_time_observations_in_seconds
    # max_memory_observations_in_mb_per_benchmark[benchmark_directory] = max_memory_observations_in_mb

    teardown_file_path = File.join(benchmark_directory, "teardown.rb")
    if File.exist?(teardown_file_path)
      puts "Running teardown for #{benchmark_directory} benchmark"
      `ruby #{teardown_file_path}`
    end

    benchmark_all_languages_t2 = Time.now
    puts "Ran all #{benchmark_directory} benchmarks in #{benchmark_all_languages_t2 - benchmark_all_languages_t1} seconds."

    puts
  end

  benchmark_suite_t2 = Time.now
  puts "Ran benchmark suite in #{benchmark_suite_t2 - benchmark_suite_t1} seconds (#{(benchmark_suite_t2 - benchmark_suite_t1) / 60} mins)."
  puts

  augment_metrics_with_normalized_metrics!(all_metrics)

  puts "Metrics (also written to index.html):"
  pp all_metrics

  render_html_table(all_metrics, "index.html")

  duration_seconds = benchmark_suite_t2 - benchmark_suite_t1
  write_results_json(all_metrics, duration_seconds, "results.json")
end

# metrics is a Hash of the form:
# {
#   "helloworld:ruby:time"=>"8.657e-06s",
#   "helloworld:ruby:process_user_time"=>"0.06",
#   "helloworld:ruby:process_system_time"=>"0.01",
#   "helloworld:ruby:process_real_time"=>"0:00.07",
#   "helloworld:ruby:process_real_time_secs"=>0.07,
#   "helloworld:ruby:process_percent_cpu_time"=>"94%",
#   "helloworld:ruby:process_max_rss_mb"=>8.703125
# }
#
# real_time_observations_in_seconds_per_benchmark is a hash of the
# form {benchmark_directory_name => array_of_real_time_observations_in_seconds, ...}, for example:
# {
#   "helloworld"=>[0.1, 0.02, 0.001, 0.0, 0.01, 0.01],
#   "base64"=>[1.59, 2.11, 2.17, 2.82, 4.5, 5.8, 6.3, 6.38, 7.75, 11.46],
#   ...
# }
#
# max_memory_observations_in_mb_per_benchmark is a hash of the
# form {benchmark_directory_name => array_of_max_memory_observations_in_mb, ...}. It has
# the same structure as the real_time_observations_in_seconds_per_benchmark parameter - only the interpretation is different.
def augment_metrics_with_normalized_metrics!(metrics)
  metrics_tuples = metrics.map {|k, v| k.split(":") << v }
  # metrics_tuples is an array of the form:
  # [
  #   ["helloworld", "ruby", "time", "8.657e-06s"],
  #   ["helloworld", "ruby", "process_real_time_secs", 0.07],
  #   ...
  # ]
  metrics_tuples.select! {|tuple| ["process_real_time_secs", "process_max_rss_mb"].include?(tuple[2]) }
  metrics_tuples.reject! {|tuple| /error/ === tuple.last }
  metrics_tuples_by_benchmark_and_metric_name = metrics_tuples.group_by{|tuple| [tuple[0], tuple[2]] }

  puts "metrics_tuples:"
  puts metrics_tuples.inspect

  metrics_tuples_by_benchmark_and_metric_name.each do |benchmark_and_metric_name_pair, tuples|
    min_metric_value = tuples.map(&:last).min
    min_metric_value = 0.001 if min_metric_value == 0.0
    tuples.each do |tuple|
      benchmark_name, implementation_name, metric_name, unnormalized_metric_value = *tuple
      unnormalized_metric_value = 0.001 if unnormalized_metric_value == 0.0
      normalized_metric_value = unnormalized_metric_value.to_f / min_metric_value
      metrics["#{benchmark_name}:#{implementation_name}:normalized_#{metric_name}"] = normalized_metric_value
    end
  end
end


TraceWithMean = Struct.new(:trace, :mean)

# metrics is a Hash of the form:
# {
#   "helloworld:ruby:time"=>"8.657e-06s",
#   "helloworld:ruby:process_user_time"=>"0.06",
#   "helloworld:ruby:process_system_time"=>"0.01",
#   "helloworld:ruby:process_real_time"=>"0:00.07",
#   "helloworld:ruby:process_percent_cpu_time"=>"94%",
#   "helloworld:ruby:process_max_rss_mb"=>8.703125
# }
def render_html_table(metrics, path)
  # logic to render the table
  column_names = ["benchmark_name", "language"] + metrics.keys.map {|metric_fq_name| metric_fq_name.split(":").last }.uniq
  column_name_to_position_map = column_names.each_with_index.reduce({}) {|memo, (name, i)| memo.merge({ name => i }) }

  column_specs = column_names.map {|name| {"title" => name} }

  row_hashes = metrics.reduce({}) do |memo, (metric_fq_name, metric_value)|
    benchmark_name, language, metric_name = metric_fq_name.split(":")
    memo["#{benchmark_name}:#{language}"] ||= {}
    memo["#{benchmark_name}:#{language}"][metric_name] = metric_value
    memo
  end

  rows = row_hashes.map do |benchmark_implementation_name, metrics_hash|
    row = benchmark_implementation_name.split(":")
    metrics_hash.each do |metric_name, metric_value|
      row[column_name_to_position_map[metric_name]] = metric_value
    end
    row.fill(nil, row.length...column_names.count)    # account for any missing columns at the end
  end

  # logic to render the box plots
  metrics_tuples = metrics.map {|k, v| k.split(":") << v }    # each tuple is of the form: ["helloworld", "ruby", "process_real_time_secs", 0.07]
  runtime_tuples = metrics_tuples.select {|tuple| tuple[2] == "normalized_process_real_time_secs" }
  maxmem_tuples = metrics_tuples.select {|tuple| tuple[2] == "normalized_process_max_rss_mb" }

  # runtime_tuples_per_implementation_langauge = runtime_tuples.group_by{|tuple| tuple[1] }
  # runtime_traces = runtime_tuples_per_implementation_langauge.map do |implementation_language, tuples|
  #   categories = tuples.map(&:first)
  #   observations = tuples.map(&:last)
  #   # observations, categories = tuples.map {|tuple| [tuple.last, tuple.first] }.transpose

  #   {
  #     x: observations,
  #     y: categories,
  #     name: implementation_language,
  #     type: 'box',
  #     boxmean: false,
  #     orientation: 'h'
  #   }
  # end

  runtime_tuples_per_implementation_langauge = runtime_tuples.group_by{|tuple| tuple[1] }
  runtime_traces = runtime_tuples_per_implementation_langauge.map do |implementation_language, tuples|
    observations = tuples.map(&:last)
    mean_observation = geometric_mean(observations)
    trace = {
      x: observations,
      name: implementation_language,
      type: 'box',
      boxmean: false
    }
    TraceWithMean.new(trace, mean_observation)
  end.sort_by(&:mean).map(&:trace)

  maxmem_tuples_per_implementation_langauge = maxmem_tuples.group_by{|tuple| tuple[1] }
  maxmem_traces = maxmem_tuples_per_implementation_langauge.map do |implementation_language, tuples|
    observations = tuples.map(&:last)
    mean_observation = geometric_mean(observations)
    trace = {
      x: observations,
      name: implementation_language,
      type: 'box',
      boxmean: false
    }
    TraceWithMean.new(trace, mean_observation)
  end.sort_by(&:mean).map(&:trace)

  html = <<~EOF
  <!DOCTYPE html>
  <html>
    <head>
      <title>Language Benchmarks</title>
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
      <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/rowgroup/1.4.1/css/rowGroup.dataTables.min.css">

      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
      <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
      <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/rowgroup/1.4.1/js/dataTables.rowGroup.min.js"></script>

      <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    </head>
    <body>
      <table id="metrics" class="display" width="100%"></table>

      <div id="runtime-box-plot" style="width: 100%"></div>

      <div id="maxmem-box-plot" style="width: 100%"></div>

      <script type="text/javascript">
        function renderTable() {
          var dataSet = #{ JSON.dump(rows) };

          $('#metrics').DataTable({
            paging: false,
            data: dataSet,
            columns: #{ JSON.dump(column_specs) },
            order: [[ 0, 'asc' ], [ #{column_name_to_position_map["process_real_time_secs"]}, 'asc' ]],
            rowGroup: {
              dataSrc: 0
            }
          });
        }

        function renderOverallRuntimeBoxPlot() {
          var runtimeTraces = #{ JSON.dump(runtime_traces.reverse) };

          var runtimeLayout = {
            title: 'Overall Normalized Runtime',
            xaxis: {
              title: 'Runtime / Fastest Runtime (e.g. ruby base64 runtime / fastest base64 runtime)',
              zeroline: false
            },
            margin: {l: 160}
          };

          Plotly.newPlot('runtime-box-plot', runtimeTraces, runtimeLayout);
        }

        function renderOverallMaxMemBoxPlot() {
          var maxmemTraces = #{ JSON.dump(maxmem_traces.reverse) };

          var maxmemLayout = {
            title: 'Overall Normalized Maximum Memory',
            xaxis: {
              title: 'MaxMem / Minimum MaxMem (e.g. ruby base64 maxmem / minimum base64 maxmem)',
              zeroline: false
            },
            margin: {l: 160}
          };

          Plotly.newPlot('maxmem-box-plot', maxmemTraces, maxmemLayout);
        }

        $(document).ready(function() {
          renderTable();
          renderOverallRuntimeBoxPlot();
          renderOverallMaxMemBoxPlot();
        });
      </script>
    </body>
  </html>
  EOF

  File.open(path, 'w') {|f| f.puts(html) }
end

# Parse implementation directory name into [language_family, version, variant]
# Examples: "vlang" => ["vlang", nil, nil], "ruby-3.3" => ["ruby", "3.3", nil], "ruby-3.3-jit" => ["ruby", "3.3", "jit"]
def parse_implementation_name(name)
  m = name.match(/^([a-z]+)(?:-(\d[\d.]*))?(?:-(.+))?$/)
  return [name, nil, nil] unless m
  [m[1], m[2], m[3]]
end

def write_results_json(all_metrics, duration_seconds, path)
  # Collect unique benchmarks and build per-result records
  benchmarks = Set.new
  results = []
  metrics_tuples = all_metrics.map { |k, v| k.split(":") << v }

  # Group by benchmark:implementation
  grouped = metrics_tuples.group_by { |t| [t[0], t[1]] }
  grouped.each do |(benchmark, implementation), tuples|
    benchmarks << benchmark
    language_family, version, variant = parse_implementation_name(implementation)

    metric_hash = tuples.each_with_object({}) { |t, h| h[t[2]] = t[3] }

    is_error = metric_hash["process_real_time_secs"].is_a?(String) && metric_hash["process_real_time_secs"].include?("error")
    results << {
      benchmark: benchmark,
      implementation: implementation,
      language_family: language_family,
      version: version,
      variant: variant,
      status: is_error ? metric_hash["process_real_time_secs"] : "ok",
      real_time_secs: is_error ? nil : metric_hash["process_real_time_secs"],
      percent_cpu: is_error ? nil : metric_hash["process_percent_cpu_time"],
      max_rss_mb: is_error ? nil : metric_hash["process_max_rss_mb"],
      normalized_real_time: is_error ? nil : metric_hash["normalized_process_real_time_secs"],
      normalized_max_rss_mb: is_error ? nil : metric_hash["normalized_process_max_rss_mb"]
    }
  end

  # Build rankings: geometric mean of normalized times per implementation
  results_by_impl = results.group_by { |r| r[:implementation] }
  rankings = results_by_impl.map do |impl, impl_results|
    ok_results = impl_results.select { |r| r[:status] == "ok" }
    norm_times = ok_results.map { |r| r[:normalized_real_time] }.compact
    norm_mems = ok_results.map { |r| r[:normalized_max_rss_mb] }.compact
    language_family, = parse_implementation_name(impl)
    {
      implementation: impl,
      language_family: language_family,
      geo_mean_time: norm_times.any? ? geometric_mean(norm_times) : nil,
      geo_mean_memory: norm_mems.any? ? geometric_mean(norm_mems) : nil,
      benchmarks_ok: ok_results.count,
      benchmarks_errored: impl_results.count - ok_results.count
    }
  end.sort_by { |r| r[:geo_mean_time] || Float::INFINITY }

  output = {
    generated_at: Time.now.utc.iso8601,
    duration_seconds: duration_seconds.round(1),
    benchmarks: benchmarks.sort.to_a,
    language_colors: LANGUAGE_COLORS,
    results: results,
    rankings: rankings
  }

  File.write(path, JSON.pretty_generate(output))
  puts "Results written to #{path}"
end

def geometric_mean(arr)
  mean = arr.map {|v| BigDecimal(v, 5) }.reduce(:*) ** (1.0 / arr.count)
  mean.to_f
end

main if __FILE__ == $0

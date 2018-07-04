expected_output = <<EOF
7707d6ae4e027c70eea2a935c2296f21
82636e8ed2066ac036e6a3aacaf2e94d
7707d6ae4e027c70eea2a935c2296f21
EOF

if ARGF.read.include?(expected_output)
  exit(0)
else
  exit(1)
end
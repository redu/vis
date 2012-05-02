if environment.include?("production") or environment.include?("staging")
  run "nohup ey_bundler_binstubs/mongolicious config/jobs.yml 2>/dev/null 1>/dev/null &"
end

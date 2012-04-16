if environment.include?("production") or environment.include?("staging")
  run "mongolicious config/jobs.yml"
end

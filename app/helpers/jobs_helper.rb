module JobsHelper

  def render_job_status(job)
    if job.is_hidden
      "(Hidden)"
    else
      "(public)"
    end

  end
end

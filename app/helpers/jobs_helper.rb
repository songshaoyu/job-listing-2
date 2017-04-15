module JobsHelper

  def render_job_status(job)
    if job.is_hidden
      content_tag(:span, "", :class => "	glyphicon glyphicon-lock")
    else
       content_tag(:span, "",:class => "glyphicon glyphicon-globe" )
    end

  end
end

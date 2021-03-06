class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :add, :remove]
  before_action :validate_search_key, only: [:search]


  def index
    @jobs = case params[:order]

    when 'by_lower_bound'
      Job.published.order('wage_lower_bound').order('created_at DESC')
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound').order('created_at DESC')
    else
      Job.published.recent
    end
  end

  def new
    @job = Job.new
  end

  def show
    @job = Job.find(params[:id])

    @category = @job.category
    @sames = Job.where(:is_hidden => false, :category => @job.category).where.not(:id => @job.id ).limit(5).order("RANDOM()")

    if @job.is_hidden
      flash[:warning] = "再换个试试吧。 "
      redirect_to root_path
    end
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)

      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end

  def add
    @job = Job.find(params[:id])

    if !current_user.is_member_of?(@job)
      current_user.add_collection!(@job)
    end

    redirect_to :back
  end

  def remove
    @job = Job.find(params[:id])

    if current_user.is_member_of?(@job)
      current_user.remove_collection!(@job)
    end

    redirect_to :back
  end


  def developer
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.where(:category => "开发").order('wage_lower_bound').paginate(:page => params[:page], :per_page => 5)
            when 'by_upper_bound'
              Job.published.where(:category => "开发").order('wage_upper_bound').paginate(:page => params[:page], :per_page => 5)
            else
              Job.published.where(:category => "开发").recent.paginate(:page => params[:page], :per_page => 5)
            end
  end

  def product
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.where(:category => "产品").order('wage_lower_bound').paginate(:page => params[:page], :per_page => 5)
            when 'by_upper_bound'
              Job.published.where(:category => "产品").order('wage_upper_bound').paginate(:page => params[:page], :per_page => 5)
            else
              Job.published.where(:category => "产品").recent.paginate(:page => params[:page], :per_page => 5)
            end
  end

  def design
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.where(:caregory => "设计").order('wage_lower_bound').paginate(:page => params[:page], :per_page => 5)
    when 'by_upper_bound'
      Job.published.where(:category => "设计").order('wage_upper_bound').paginate(:page => params[:page], :per_page => 5)
    else
      Job.published.where(:category => "设计").recent.paginate(:page => params[:page], :per_page => 5)
    end
  end

  def search
   if @query_string.present?
     search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
     @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
   end
 end

 protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_city_cont: @query_string
      }
    end
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  def render_highlight_content(job,query_string)
    excerpt_cont = excerpt(job.title, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end



  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :category, :company, :city)
  end
end

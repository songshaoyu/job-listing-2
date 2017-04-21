class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    is_admin
  end

  has_many :jobs
  has_many :resumes
  has_many :collections
  has_many :collected_jobs, :through => :collections, :source => :job


   def is_member_of?(job)
     collected_jobs.include?(job)
   end

   def add_collection!(job)
     collected_jobs << job
   end

   def remove_collection!(job)
     collected_jobs.delete(job)
   end



end

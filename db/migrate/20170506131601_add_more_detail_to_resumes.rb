class AddMoreDetailToResumes < ActiveRecord::Migration[5.0]
  def change
    add_column :resumes, :name, :string
    add_column :resumes, :gender, :string
    add_column :resumes, :wechat, :string
  end
end

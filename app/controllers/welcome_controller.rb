class WelcomeController < ApplicationController
  def index
    flash[:notice] = "早起的鸟儿有虫吃"
  end
end

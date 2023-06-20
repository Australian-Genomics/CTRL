class WelcomeController < ApplicationController
  def index
    if current_user.present?
      redirect_to dashboard_index_path
    else
      render 'welcome/index'
    end
  end
end

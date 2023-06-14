class WelcomeController < ApplicationController
  def index
    pp user_session[:study_name] # TODO

    if current_user.present?
      redirect_to dashboard_index_path
    else
      render 'welcome/index'
    end
  end
end

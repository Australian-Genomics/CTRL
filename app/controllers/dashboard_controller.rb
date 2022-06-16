class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @steps = ConsentStep.ordered
    @active_tab = 'dashboard'
  end

  def news_and_info
    @active_tab = 'news_and_info'
    @info_link = ENV['MCRI_INFO_LINK'].present? ? ENV['MCRI_INFO_LINK'] : 'https://ctrldynamicconsent.wordpress.com'
  end

  def contact_us
    flash.clear
    @active_tab = 'contact_us'
  end

  def send_message
    @active_tab = 'contact_us'
    content = params[:contact_us][:message]
    if content.present?
      contact_us = ContactUs.new(current_user, content)
      contact_us.send_message
      redirect_to message_sent_path
    else
      flash[:alert] = "Message content can't be blank."
      render 'dashboard/contact_us'
    end
  end

  def message_sent
    @active_tab = 'contact_us'
  end
end

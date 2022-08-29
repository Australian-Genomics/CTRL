class GlossaryEntriesController < ApplicationController
  before_action :authenticate_user!

  def show
    @active_tab = 'glossary'
  end
end

class ConsentRefactorController < ApplicationController
  before_action :authenticate_user!
  before_action :find_steps, only: :index

  def edit; end

  def index
    render 'index.json.jbuilder'
  end

  def update
    binding.pry
  end

  private

  def find_steps
    @consent_steps = ConsentStep.all
  end
end

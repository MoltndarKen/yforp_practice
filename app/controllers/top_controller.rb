class TopController < ApplicationController

  def index
    @question = Question.new
  end

end


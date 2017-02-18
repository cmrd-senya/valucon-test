class FeedbacksController < ApplicationController
  def create
    if params["feedbackText"].present? && params["email"].present?
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end
end
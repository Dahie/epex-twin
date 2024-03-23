# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
  def authenticate_user!
    token = request.headers['Authorization']&.split&.last
    unless token && valid_token?(token)
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    # Your logic to validate the token
    # For example, check if the token exists in the database or matches a predefined value
    token == ENV.fetch("EPEX_TWIN_API_TOKEN", nil)
  end
end

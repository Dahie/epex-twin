# frozen_string_literal: true

class Api::V1::DataController < Api::V1::ApiController
  before_action :authenticate_user!

  def create
    outcome = CreateDataRecord.result(record_attributes: data_record_params)

    if outcome.success?
      render json: outcome.data_record, status: :created
    else
      render json: { error: outcome.error }, status: :unprocessable_entity
    end
  end

  private

  def data_record_params
    params.require(:data).permit(:type, :value, :unit, :source, :created_at, :updated_at, :starts_at, :ends_at)
  end
end

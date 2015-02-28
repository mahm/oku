class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: %i(show edit update destroy)

  def index
    @evaluations = Evaluation.find_by_evaluatee_id!(params[:evaluatee_id])
  end

  def new
    @evaluation = current_user.evaluations.build(evaluatee_id: params[:user_id])
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(auction_id, evaluatee_id, comment)
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:id])
  end
end

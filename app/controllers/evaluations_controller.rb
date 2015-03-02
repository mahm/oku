class EvaluationsController < ApplicationController
  before_action :set_auction, only: %i(new create)
  before_action :set_evaluation, only: %i(edit update destroy)

  def index
    @evaluatee = User.find(params[:user_id])
    @evaluations = Evaluation.where(evaluatee_id: @evaluatee.id)
  end

  def new
    @evaluation = Evaluation.new(auction_id: @auction.id,
                                 evaluatee_id: @auction.user.id,
                                 evaluater_id: current_user.id)
  end

  def create
    @evaluation = @auction.evaluations.build(evaluation_params)
    @evaluation.evaluatee_id = @auction.user.id
    @evaluation.evaluater_id = current_user.id
    respond_to do |format|
      if @evaluation.save
        format.html { redirect_to [@auction.category, @auction], notice: "#{@evaluation.evaluatee.email} への評価を登録しました。" }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
        format.html { redirect_to [@evaluation.auction.category, @evaluation.auction], notice: 'このオークションへの評価を変更しました。' }
      else
        format.html { render :html }
      end
    end
  end

  def destroy
    @evaluation.destroy!
    respond_to do |format|
      format.html { redirect_to [@evaluation.auction.category, @evaluation.auction], notice: 'このオークションに対するあなたの評価を取下げました。' }
    end
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:comment)
  end

  def set_auction
    @auction = Auction.find(params[:auction_id])
  end

  def set_evaluation
    @evaluation = current_user.evaluations.find(params[:id])
  end
end

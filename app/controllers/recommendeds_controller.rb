class RecommendedsController < ApplicationController
	before_action :authenticate_user!

	def create
	  @read_books = current_user.bookshelves.where(status: 2)
	  recommend = Recommended.create(user_id: current_user.id, book_id: recommend_params[:book_id])
	  flash[:create_recommend] = "技術書「#{recommend.book.title}」をお勧めしました"
	  render 'recommendeds/index.js.erb'
	end

	def destroy
	  @read_books = current_user.bookshelves.where(status: 2)
	  recommend = current_user.recommendeds.find(params[:id])
          recommend.destroy
          flash[:destroy_recommend] = "「#{recommend.book.title}」のお勧めを解除しました"
          render 'recommendeds/index.js.erb'
	end

	private

	def recommend_params
	  params.permit(:book_id)
	end

end

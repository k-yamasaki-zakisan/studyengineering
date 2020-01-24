class UsersController < ApplicationController
	before_action :authenticate_user!

	def show
	  @user = User.find(params[:id])
	  if @user.id != current_user.id
            redirect_to user_path(current_user.id)
          end

	  #TODOリスト表示用のインスタンス変数 && 未達ステータス更新用の処理
	  current_user.todolists.where(status: 0).each do |todo|
	    if current_user.ckeck_date(todo) < 0
	      todo.status = 2
	      todo.save
	    end
	  end
	  @todolists = current_user.todolists.where(status: 0).order(:deadline).limit(5)

          #TODOの達成率のチャート用インスタンス変数
	  @completes = current_user.todolists.where(status: 1)
	  @unachieved = current_user.todolists.where(status: 2)
	  @todochart = [['達成数', @completes.count], ['未達数', @unachieved.count]]

          #楽天ブックスからの取得データの表示用インスタンス変数
	  @interest_books = current_user.bookshelves.where(status: 0)
	  @reading_books = current_user.bookshelves.where(status: 1)
	  @read_books = current_user.bookshelves.where(status: 2)

	  #技術書お勧め用のインスタンス変数
	  @recommned = Recommended.new

	  #学習時間のグラフ用のインスタンス変数
          if  params[:study_term].to_i == 1
      	    @studytimes = current_user.records.where("created_at > :date", date: Date.today - 7)
          elsif  params[:study_term].to_i == 2
      	    @studytimes = current_user.records.where("created_at > :date", date: Date.today - 30)
          elsif  params[:study_term].to_i == 3
      	    @studytimes = current_user.records.where("created_at > :date", date: Date.today - 90)
          elsif  params[:study_term].to_i == 4
      	    @studytimes = current_user.records.where("created_at > :date", date: Date.today - 365)
          elsif  params[:study_term].to_i == 5
      	    @studytimes = current_user.records.all
          else
	    @studytimes = current_user.records.all
	  end

	  @studychart = []
	  @studytimes.each do |s|
	    @studychart << [s.created_at.strftime("%Y年%-m月%-d日") , s.until_today_studytime]
	  end
	end

	def edit
	  @user = User.find(params[:id])
          if @user.id != current_user.id
            redirect_to root_path
          end
	end

	def update
          user = current_user
          if  user.update(user_update_params)
	    flash[:user_update] = '登録情報を更新しました'
	    redirect_to user_path(current_user.id)
	  else
	    flash[:miss_user_update] = '登録情報の更新に失敗しました　空の項目があります'
	    redirect_to user_path(current_user.id)
	  end
	end

	def destroy
	  user = current_user
          user.destroy
          redirect_to root_path
	end

	private

	def user_update_params
          params.require(:user).permit(:name, :email)
	end

end

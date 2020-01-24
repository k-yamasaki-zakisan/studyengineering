class RecordsController < ApplicationController
	before_action :authenticate_user!
	before_action :twitter_client, only: [:create]

	def index
	  @records = current_user.records.order("id DESC").page(params[:page]).per(10)
	  @record = Record.new
	end

	def edit
	  @record = Record.find(params[:id])
	  if @record.user_id != current_user.id
      	    redirect_to root_path
          end
	end

	def create
	  @record = Record.new(record_params)
          @record.user_id = current_user.id
          #本日2回連続投稿を禁止するif文
          if  current_user.records.blank? || current_user.records.last.created_at.strftime("%Y-%m-%d") != Date.today.strftime("%Y-%m-%d")
            if  @record.save
      	      totalstudytime = current_user.records.sum(:studytime)
              @record.until_today_studytime = totalstudytime
              @record.save
              flash[:add_record] = "本日の進捗を追加しました"
              #Twitter投稿用の記述
              if current_user.snsCredentials.present?
                @client.update("タイトル：#{@record.title}\n内容：#{@record.body}\n学習時間：#{@record.studytime} h\n総計：#{@record.until_today_studytime} h")
              end
              render :newpost
            else
              flash[:miss_add_record] = "学習項目と学習時間を入力してください"
              render :message
            end
            #本日2回連続投稿の失敗処理を入れる
          else
      	    flash[:miss_sameday_record] = "同じ日に学習記録があります"
            render :message
          end
	end

	def update
	  @record = current_user.records.find(params[:id])
	  if @record.update(record_params)
	    allrecords =  current_user.records.all
	    allrecords.each.with_index(0) do |re, e|
	      i = 0
	      until_total_studytime = 0
	      while i <= e
	        until_total_studytime += allrecords[i].studytime
	  	i += 1
	      end
	      re.until_today_studytime = until_total_studytime
	      re.save
            end
	    flash[:success_record_update]  = "進捗内容を更新しました"
	    redirect_to records_path
	  else
	    flash[:miss_recored_update]  = "項目を埋めて下さい"
	    render 'edit'
	  end
	end

	private

	def record_params
	  params.require(:record).permit(:title, :body, :studytime)
	end

	def twitter_client
          @client = Twitter::REST::Client.new do |config|
            config.consumer_key = ENV['Twitter_API_KEY']
            config.consumer_secret = ENV['Twitter_API_secret_KEY']
            config.access_token = ENV['Twitter_Access_token']
            config.access_token_secret = ENV['Twitter_Access_token_secret']
          end
        end

end

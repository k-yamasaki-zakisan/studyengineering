class BooksController < ApplicationController

    def search
      @books = []
      @title = booktitle_params[:title]
      if @title.present?
          @books = search_items(@title)
      end
    end

  　def detail
  	 results = RakutenWebService::Books::Book.search({
        isbn: bookcode_params[:book_code]
      })
      @book = Book.new(read(results.first))
  	end

    def show
      @book = Book.find(params[:id])
    end

    private

    def booktitle_params
      params.permit(:title)
    end

    def bookcode_params
      params.permit(:book_code)
    end

end

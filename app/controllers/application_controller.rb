class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_in_path_for(resource)
      user_path(current_user.id)
    end

    def after_sign_out_path_for(resource)
      root_path
    end

    private

    def search_items(title)
      books = []
      results = RakutenWebService::Books::Book.search({
        title: title,
        booksGenreId: '001005',
        sort: 'sales',
        hits: '24',
      })
      results.each do |result|
        book = Book.new(read(result))
        books << book
      end

      rescue RakutenWebService::WrongParameter
        flash.now[:danger] = 'Error: キーワードが短すぎます'
      ensure

      return books
    end


    def read(result)
      title = result['title']
      url = result['itemUrl']
      sales_date = result['salesDate']
      book_code = result['isbn']
      caption = result['itemCaption']
      author = result['author']
      price = result['itemPrice']
      review_average = result['reviewAverage']
      review_count = result['reviewCount']
      small_image_url = result['smallImageUrl'].gsub('?_ex=60x60', '')
      medium_image_url = result['mediumImageUrl'].gsub('?_ex=120x120', '')
      large_image_url = result['largeImageUrl'].gsub('?_ex=190x190', '')

      {
        title: title,
        url: url,
        sales_date: sales_date,
        book_code: book_code,
        caption: caption,
        author: author,
        price: price,
        review_average: review_average,
        review_count: review_count,
        small_image_url: small_image_url,
        medium_image_url: medium_image_url,
        large_image_url: large_image_url,
      }
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
end







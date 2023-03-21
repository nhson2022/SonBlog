class PagesController < ApplicationController
  def home
    @articles = Article.search(params)
    @categories = Category.order(id: :desc)
  end
end

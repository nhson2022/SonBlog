class PagesController < ApplicationController
  def home
    @articles = Article.search(params)
    @categories = Category.order(id: :desc)
  end

  def about
    @info = About.first
    @title = 'Ruby Dev'
  end
end

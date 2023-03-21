class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_rich_text :content

  scope :filter_by_category, ->(params) { where(category_id: params[:cid]) if params[:cid].present? }
  # app/models/article.rb

  def self.search(params)
    if params[:q].present?
      return includes(:user).with_rich_text_content_and_embeds
               .where("LOWER(title) LIKE LOWER(?)", "%#{params[:q].to_s.squish}%")
               .order(id: :desc)
               .paginate(page: params[:page] || 1, per_page: 10)
    end

    includes(:user).with_rich_text_content_and_embeds
      .order(id: :desc)
      .paginate(page: params[:page] || 1, per_page: 10)
  end
end

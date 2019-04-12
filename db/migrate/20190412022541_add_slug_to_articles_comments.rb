class AddSlugToArticlesComments < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :uuid, :string
    add_column :articles, :slug, :string

    add_column :comments, :uuid, :string
    add_column :comments, :slug, :string


    Article.all.each do |article|
      @uuid = SecureRandom.uuid
      article.uuid = @uuid
      article.slug = @uuid
      article.save
    end

    Comment.all.each do |comment|
      @uuid = SecureRandom.uuid
      comment.uuid = @uuid
      comment.slug = @uuid
      comment.save
    end
  end
end

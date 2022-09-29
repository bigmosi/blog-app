class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :post, class_name: 'Post'

  after_save :update_comments_counter
  before_destroy :update_comments_counter_on_destroy

  def update_comments_counter
    post.update(comments_counter: post.comments.count)
  end

  def update_comments_counter_on_destroy
    post.update_columns('comments_counter' => post.comments_counter - 1)
  end
end

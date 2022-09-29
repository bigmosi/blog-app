class User < ApplicationRecord
<<<<<<< HEAD
  has_many :comments, foreign_key: :author_id
  has_many :posts, foreign_key: :author_id
  has_many :likes, foreign_key: :author_id
=======
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, allow_blank: false
  validates :posts_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
>>>>>>> dev

  validates :name, presence: true
  validates :posts_counter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

<<<<<<< HEAD
  def last_three_posts
    posts.includes(:author).order(created_at: :desc).limit(3)
=======
  after_initialize :set_defaults

  def recent_posts
    posts.order(created_at: :desc).limit(3)
>>>>>>> dev
  end

  private

  def set_defaults
    self.posts_counter ||= 0
  end
end

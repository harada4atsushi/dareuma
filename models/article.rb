class Article < ActiveRecord::Base
  has_many :likes
  belongs_to :theme
end
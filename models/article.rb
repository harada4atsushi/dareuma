class Article < ActiveRecord::Base
  has_many :likes, :dependent => :destroy
  belongs_to :theme
  paginates_per 10
end
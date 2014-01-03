class Article < ActiveRecord::Base
  has_many :likes, :dependent => :destroy
  belongs_to :theme
end
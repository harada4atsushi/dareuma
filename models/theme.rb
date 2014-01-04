class Theme < ActiveRecord::Base
  has_many :articles

  def img_exist?
    File.exist?("#{Sinatra::Application.settings.public_dir}/system/images/#{self.id}")
  end
end
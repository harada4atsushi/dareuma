# coding:utf-8

# カレントディレクトリをロードパスに追加
$:.unshift File.dirname(__FILE__)

# Gemfileに定義されているgemを一括require
Bundler.require

# modelクラスを全てrequire
Dir[File.join(File.dirname(__FILE__), "models", "**/*.rb")].each do |f|
  require f
end

require "db/connection.rb"
require "main_config"
require "main"

run Main


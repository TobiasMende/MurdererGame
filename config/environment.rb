# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MurdererGame::Application.initialize!

class String
  require 'iconv'
  def to_iso
    Iconv.conv('ISO-8859-1', 'utf-8', self)
  end
end
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MurdererGame::Application.initialize!

class String
  def to_iso
    self.encode('ISO-8859-1')
  end
end
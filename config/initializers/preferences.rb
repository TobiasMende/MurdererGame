#encoding: utf-8
module MurdererGame
  class Application < Rails::Application
    FROM_MAIL = "noreply@epic-mörderspiel.de"
    FROM_NAME = "EPIC MÖRDERSPIEL"
    FROM = MurdererGame::Application::FROM_NAME+" <"+MurdererGame::Application::FROM_MAIL+">"
  end
end
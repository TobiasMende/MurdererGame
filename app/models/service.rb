class Service
  def self.daily
    # Service for Games:
    handle_games
    
    # Service for Users:
    handle_users
  end
  
  def self.manual
    users = User.all
    puts "Sending information update request to "+users.size.to_s+" users ..."
    users.each do |user|
      puts "\t ... to "+user.name+" <"+user.email+">"
      UserMailer.information_update_request(user).deliver
    end    
  end
  
  # Loop Methods
  
  def self.handle_games
    games = Game.where("started <> ?", true).all
    puts "Checking "+games.size.to_s+" games to start ..."
    games.each do |game|
      game.handle_game_start_by_date
    end
    games = Game.where("finished <> ?", true).all
    puts "Checking "+games.size.to_s+" games to finish ..."
    games.each do |game|
      game.handle_game_end_by_date
    end
  end
  
  def self.handle_users
    inactive_user = User.incactive_users(2.weeks)
    inactive_user.each do |user|
      send_inactive_mail = false
      user.current_games.each do |game|
        if proved_victim_contracts_for_game(game).count == 0
          send_inactive_mail = true
          break
        end
      end
      if send_inactive_mail
        UserMailer.login_needed(user).deliver
      end
    end
    
    # Kick really inactive users:
     inactive_user = User.incactive_users(4.weeks)
    inactive_user.each do |user|
      user.current_games.each do |game|
        if proved_victim_contracts_for_game(game).count == 0
          user.suicide_in(game)
        end
      end
    end
    
  end
    
end
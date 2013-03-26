class Service
  def self.daily
    puts "Starting daily service script at "+Time.now.to_s
    # Service for Games:
    handle_games
    
    # Service for Users:
    handle_users
    
    # Service for Contracts:
    handle_contracts
    
    # other:
    clean_up
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
    puts "Handling Users ..."
    inactive_user = User.incactive_users(2.weeks)
    inactive_user.each do |user|
      send_inactive_mail = false
      user.current_games.each do |game|
        if user.proved_victim_contracts_for_game(game).count == 0
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
        if user.proved_victim_contracts_for_game(game).count == 0
          user.suicide_in(game)
        end
      end
    end
    
  end
  
  def self.handle_contracts
    puts "Checking contracts ..."
    contracts = Contract.where("executed_at < ? AND proved_at IS NULL", Date.today-2.days)
    contracts.each do |contract|
      puts "\t confirming contract "+contract.id.to_s
      contract.confirm
    end
    puts "Finishing contracts ..."
  end
    
  def self.clean_up
    # Delete non activated user:
    users = User.where("activation_token IS NOT NULL AND created_at < '"+(Date.today-2.days).to_s+"'").all
    users.each do |user| 
      user.image.destroy
      user.delete
    end
  end
end
namespace :dm_unibo_common do
  desc "Add a dm_unibo_user_search user in db"
  task add_user: :environment do
    upn = ENV['upn']
    u = User.syncronize(upn)
    puts "ciao #{u}"
  end
end

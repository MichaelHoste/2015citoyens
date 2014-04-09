namespace :app  do
  task :setup do
    if Rails.env.production?
      puts "Cannot use this task in production"
    else
      # the ruby version is automatically defined in the .rbenv-version file
      [ 'rm log/*.log',                                 # rm log files
        "/bin/bash #{Dir.pwd}/bin/rename_tab.sh Server" #
      ].each do |command|
        puts command
        system(command)
      end

      # Empty shell
      new_tab('Shell', ["cd #{Dir.pwd}", "clear"])

      # Launch server
      system('foreman start -f Procfile.development')
    end
  end

  task :reset => :environment do
    if Rails.env.production?
      puts "Cannot use this task in production"
    else
      system('rm -rf public/pictures')
      system('mkdir public/pictures')
      system('touch public/pictures/.keep')
      system('rake db:migrate:reset')
      system('rake db:seed')
    end
  end
end

def new_tab(name, commands)
  commands = ["/bin/bash #{Dir.pwd}/bin/rename_tab.sh #{name}"] + commands
  command_line = commands.collect! { |command| '-e \'tell application "Terminal" to do script "' + command + '" in front window\''}.join(' ')
  `osascript -e 'tell application "Terminal" to activate' \
             -e 'tell application "System Events" to tell process "Terminal" to keystroke "t" using command down' \
             #{command_line} > /dev/null`
end

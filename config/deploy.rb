set :application, '2015citoyens'
set :repo_url,    'git@github.com:MichaelHoste/2015citoyens.git'
set :deploy_to,   "/home/deploy/apps/2015citoyens"
set :linked_files, %w{config/database.yml config/initializers/facebook.rb config/initializers/errbit.rb config/newrelic.yml}
set :linked_dirs,  %w{bin log tmp vendor/bundle public/pictures}

set :rbenv_type, 'user'
set :rbenv_ruby, `cat .ruby-version`.strip

# had to put "deploy ALL=NOPASSWD: ALL" in the "sudo visudo" file to allow
# capistrano to start foreman
set :foreman_concurrency, 'web=1,worker=1'
set :foreman_procfile,    'Procfile.production'
set :foreman_env,         'env.production'
set :foreman_log,         "#{deploy_to}/shared/log"
set :foreman_user,        'deploy'

set :keep_releases, 3

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :started, :upload_config_files do
    on roles(:app) do
      upload! "config/initializers/facebook.rb", "#{deploy_to}/shared/config/initializers/facebook.rb"
      upload! "config/initializers/errbit.rb",   "#{deploy_to}/shared/config/initializers/errbit.rb"
      upload! "config/database.yml",             "#{deploy_to}/shared/config/database.yml"
      upload! "config/newrelic.yml",             "#{deploy_to}/shared/config/newrelic.yml"

      execute :sudo, "unlink /etc/nginx/sites-enabled/#{fetch(:application)};true"
      execute :sudo, "ln -s #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)};true"
    end
  end

  # CLONE PRODUCTION TO DEVELOPMENT : "cap production deploy:clone_to_development"
  task :clone_to_development do
    on roles(:app) do
      dev_config  = YAML::load(File.read('config/database.yml'))['development']
      prod_config = YAML::load(File.read('config/database.yml'))['production']

      execute "mysqldump -u #{prod_config["username"]} -p#{prod_config["password"]} #{prod_config["database"]} > /tmp/dump.sql"

      run_locally do
        execute "scp deploy@2015citoyens.be:/tmp/dump.sql /tmp/dump.sql"
        passwd_option = dev_config['password'].nil? ? '' : "-p#{dev_config['password']}"
        execute "mysql -u #{dev_config['username']} #{passwd_option} #{dev_config['database']} < /tmp/dump.sql"
      end

      execute "cd #{deploy_to}/shared/public && tar -jcf pictures.tar.bz2 pictures"

      run_locally do
        execute "scp deploy@2015citoyens.be:#{deploy_to}/shared/public/pictures.tar.bz2 public"
      end

      execute "rm #{deploy_to}/shared/public/pictures.tar.bz2"

      run_locally do
        execute "rm -rf public/pictures"
        execute "mkdir public/pictures"
        execute "touch public/pictures/.keep"
        execute "cd public && tar -jxf pictures.tar.bz2 && rm pictures.tar.bz2"
      end
    end
  end
end



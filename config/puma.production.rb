threads 0, 5
workers 1
preload_app!

bind 'unix:///tmp/puma.2015citoyens.sock'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid.database.name
  config.grid_fs_host = 'localhost'
  config.storage = :grid_fs
  config.grid_fs_access_url = "http://localhost:3000/uploads"
end

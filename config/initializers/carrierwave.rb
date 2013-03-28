if Rails.env.development? or Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.asset_host = "http://127.0.0.1:3000"
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :file
    config.asset_host = "http://tm.1trip.com"
  end
end
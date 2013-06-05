module TripMapCache
  @@trip_cache = ActiveSupport::Cache::MemoryStore.new
end
class M2m::Base < ApplicationModel
  self.abstract_class = true

  m2m_key = "#{Rails.env}_m2m"
  msg = if config = ActiveRecord::Base.configurations[m2m_key]
    begin
      M2m::Base.establish_connection little_planet_key
      "Connected #{m2m_key} to #{config.inspect}"
    rescue
      "Failed to connect #{m2m_key} to #{config.inspect}"
    end
  else
    "No #{m2m_key} connection"
  end
  puts msg
  Rails.logger.info msg
  M2m::Base.logger = ActiveRecord::Base.logger
  
end

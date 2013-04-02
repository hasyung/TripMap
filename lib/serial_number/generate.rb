module SerialNumber
  module Generate
    
    def create_sns serial_type = 0, options = {}
      options[:limit].times do
        create_single_sn serial_type
      end
    end
    
    def create_single_sn serial_type = 0
      result = ''
      uuid = generate_uuid
      map_id = generate_map_id
      use_count = generate_use_count serial_type
      random = []
      3.times { random << generate_random }
      
      # first
      2.times { result << random.first }
      result << map_id.first
      result << random.at(1)
      
      # second
      result << uuid.last
      
      # thirdly
      result << map_id.at(1)
      result << serial_type.to_i.to_s
      result << random.last
      result << map_id.last
      
      # fourthly
      result << uuid.first
      
      # model save
      self.map_serial_numbers.build code: result, type_cd: serial_type, count: use_count, printed_cd: 0
      self.save
    end
    
    private
    def generate_uuid
      UUIDTools::UUID.timestamp_create.to_s.split(/-/).first.scan(/..../)
    end
    
    def generate_use_count serial_type
      case serial_type
      when MapSerialNumber.types[:free]
        0
      when MapSerialNumber.types[:ordinary] || MapSerialNumber.types[:favorite]
        5
      else
        0
      end
    end
    
    def generate_map_id
      case self.id
      when 1..9
        [generate_random(:char), generate_random(:char), self.id.to_s]
      when 10..99
        [generate_random, self.id.to_s.first, self.id.to_s.last]
      when 100..999
        self.id.to_s.scan(/\d/)
      else
        '000'.scan(/\d/)
      end
    end
    
    def generate_random type = :mix
      nums = (0..9).to_a
      chars = ('a'..'z').to_a
      case type
      when :mix
        chars += nums
      when :num
        chars = nums
      else
        chars
      end
      chars[rand(chars.count)].to_s
    end
    
  end
end
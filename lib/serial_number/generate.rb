module SerialNumber
  module Generate
    
    def create_single_sn serial_type = 0, map_id = 99, order = 1
      use_count = generate_use_count serial_type
      result = format_by generate_random_array
      fill_serial_type result, serial_type
      fill_map_id result, map_id
      fill_order result, order
      # model save
      self.map_serial_numbers.build code: result.join, type_cd: serial_type, count: use_count, printed_cd: 0
      self.save
    end
    
    private
    
    def generate_random_array
      result = Random.new_seed.to_s.split(//).shuffle!.sample(11).shuffle!
      if result.first == '0'
        result = generate_random_array
      end
      result
    end
    
    def format_by array = []
      [] unless array.is_a?(Array)
      array.insert(3, nil).insert(6, nil).insert(9, nil).insert(11, nil).insert(14, nil) unless array.include?(nil)
      array
    end
    
    def fill_order result, order
      num = case order
      when 1..9
        ['0', order]
      when 10..99
        [order.to_s.first, order.to_s.last]
      else
        ['0', '0']
      end
      result[9] = num.last if result[9].blank?
      result[14] = num.first if result[14].blank?
    end
    
    def fill_serial_type result, serial_type
      num = case serial_type
      when MapSerialNumber.types[:ordinary]
        (2..5).to_a
      when MapSerialNumber.types[:favorite]
        (6..9).to_a
      else
        [0]
      end
      result[3] = num.sample(1).first.to_s if result[3].blank?
    end
    
    def fill_map_id result, map_id
      num = case map_id
      when 1..9
        ['0', self.id.to_s]
      when 10..99
        [map_id.to_s.first, map_id.to_s.last]
      else
        ['0', '0']
      end
      result[6] = num.last if result[6].blank?
      result[11] = num.first if result[11].blank?
    end
      
    def fill_map_province result, province_id
      num = case province_id
      when 1..9
        ['0', self.id.to_s]
      when 10..99
        [province_id.to_s.first, province_id.to_s.last]
      else
        ['0', '0']
      end
      result.insert(6, num.first).insert(3, num.last)
    end
    
    def generate_use_count serial_type
      case serial_type
      when MapSerialNumber.types[:free]
        1
      when (MapSerialNumber.types[:ordinary]..MapSerialNumber.types[:favorite])
        10
      else
        0
      end
    end
    
    def generate_random type = :mix
      nums = (2..9).to_a
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
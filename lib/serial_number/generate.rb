module SerialNumber
  module Generate

    def create_single_sn serial_type = 0
      use_count = generate_use_count serial_type
      result = generate_random_array
      fill_serial_type result, serial_type
      fill_map_province result, self.province_id
      fill_map_id result, self.id
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

    def fill_serial_type result, serial_type
      num = case serial_type
      when MapSerialNumber.types[:free]
        [1]
      when MapSerialNumber.types[:ordinary]
        (2..5).to_a
      when MapSerialNumber.types[:favorite]
        (6..9).to_a
      else
        [0]
      end
      result.insert(1, num.sample(1).first.to_s)
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
      result.insert(8, num.first).insert(12, num.last)
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
        5
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
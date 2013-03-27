class MapSerialGenerator
  # target:
  #       generator a serial number for a map.
  #       it looks like : 1001-8M0P-KNH4-2U43, 7001-P8H3-4N20-MK4U
  # params:
  #       <type>   : indicates current map is FREE or for SALE(COLLECTION | GENERAL) .
  #                  type = 0,  1bit(LTR) can be one of A-B, FREE
  #                  type = 1,  1bit(LTR) can be one of C-D, SALE(COLLECTION)
  #                  type = 2,  1bit(LTR) can be one of E-F, SALE(GENERAL)
  #                  type = 3+, [G,..,Z], system reserved for future use.
  #       <map_id> : map id, integer.
  #       <split>  : true or false. serial number whether will split by '-'.
  #output serial excludes:
  #       0, 1, I, O
  #reserved number in 5-16bits(LTR):
  #       [8,9]
  def self.generate_one_serial( options = {} )

    return nil if options.length.zero? or options[:type].nil? or options[:map_id].nil?

    bit1 = self.get_type( options[:type] )     # type: 0 = free; 1 = sale(general); 2 = sale(collection).
    bit3 = self.get_map_id( options[:map_id] ) # formatted map_id
    bit12 = self.get_random_password()         # generate random password

    return nil if  bit3.nil? or bit3.empty?
    #binding.pry
    code = options[:split].nil? ? (bit1 + bit3 + bit12) : self.format_serial_code( bit1 + bit3 + bit12 )

  end

  private

  def self.get_type( type ) # 1bit
    first_bit = ('A'..'B').to_a.sample(1) if type.zero?
    first_bit = ('C'..'D').to_a.sample(1) if type == 1
    first_bit = ('E'..'F').to_a.sample(1) if type == 2
    first_bit[0]
  end

  def self.get_map_id ( map_id ) # 3bit
    tmp = map_id.to_s.gsub(/1/, 'B').gsub(/0/, 'A')
    len = tmp.length

    return "" if tmp.length > 3

    formatted_map_id = tmp.insert(0, "FF") if len == 1
    formatted_map_id = tmp.insert(0, "F")  if len == 2
    formatted_map_id
  end

  def self.get_random_password() # 12bit = 6bit(number) + 6bit(capital letters)
    numbers = (2..8).to_a.sample(6)   # C(L7, H6)
    letters = ('A'..'Z').to_a         # exclude 'I', 'O'
    letters.delete('I')
    letters.delete('O')
    letters = letters.sample(6)       # C(L24, H6)
    result = (numbers + letters).sample(12).join('') # full permutation for 12 bits.
  end

  def self.format_serial_code( code )
    code.insert(4, "-").insert(9, "-").insert(14, "-")
  end

end
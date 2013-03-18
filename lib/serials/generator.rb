class MapSerialGenerator
  
  def self.generate_one_serial( options = {} )
    
    return nil if options.length.zero? or options[:type].nil? or options[:map_id].nil?
    
    bit1 = self.get_type( options[:type] )     # type: 0 = free; 1 = sale.
    bit3 = self.get_map_id( options[:map_id] ) # formatted map_id
    bit8 = self.get_random_password()          # generate random password
    
    return nil if  bit3.nil? or bit3.empty?
    
    code =  options[:split].nil? ? (bit1 + bit3 + bit8) : self.format_serial_code( bit1 + bit3 + bit8 )
    
  end
  
  private
  def self.get_type( type ) # 1bit
    rd = Random.new
    first_bit = type.zero? ? rd.rand(1..6).to_s : rd.rand(7..9).to_s 
  end
  
  def self.get_map_id ( map_id ) # 3bit
    tmp = map_id.to_s
    len = tmp.length
    
    return "" if tmp.length > 3
    
    formatted_map_id = tmp.insert(0, "00") if len == 1
    formatted_map_id = tmp.insert(0, "0")  if len == 2
    formatted_map_id
  end
  
  def self.get_random_password() # 8bit
    Random.new_seed.to_s[1..8]
  end
  
  def self.format_serial_code( code )
    code.insert(3, "-").insert(7, "-").insert(11, "-")
  end
  
end
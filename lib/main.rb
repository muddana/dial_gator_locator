require 'rubygems'
require 'sinatra'
require 'builder'
require 'net/http'
require 'uri'
require 'hpricot'
require 'open-uri'

class Route
  @@base_url = "http://www.gator-locator.com/t"
  #have a script for extracting the following info need to use some kind of cron script to automate it.
  @@route_number_to_name =  { 16=>"Shands to Sugar Hill", 5=>"Downtown to Oaks Mall", 17=>"Shands to Downtown Station", 12=>"McCarty to Campus Club", 34=>"Hub to Lexington Cross Apts.",  300 => "Later Gator A", 301=>"Later Gator B", 13=>"Shands to Florida Works", 35=>"McCarty to Homestead Apts.", 302=>"Later Gator C R", 8=>"Shands to Northwood Village", 20=>"McCarty to Oaks Mall", 9=>"McCarty to Hunters Run", 26=>"UF East/West Circulator R", 10=>"Downtown Station to SFC"}.merge( {126=>"UF East/West Circulator R", 401=>"Downtown to Oaks Mall via SW 20th Ave R", 407=>"Downtown to Gainesville Mall R", 402=>"Downtown to Gateway via Archer Rd R", 408=>"Shands to Northwood Village R", 403=>"Downtown to Lexington Cross R", 404=>"Shands to Florida Works/Sugar Hill Rt 40",405=>"Shands to Florida Works/Sugar Hill Rt 40", 400=>"Downtown to Oaks Mall via University Ave R", 406=>"Downtown to Waldo Rd at 39th Ave. R"})
  @@rts_to_tranloc_mapper =  {16=>66, 5=>75, 17=>67, 12=>61, 34=>59, 300 => 3, 301=>4, 13=>65, 35=>68, 302=>1, 8=>63, 20=>55, 9=>64, 26=>40, 10=>76}.merge({126=>40, 401=>71, 407=>48, 402=>57, 408=>74, 403=>72, 405=>78, 404=>78,400=>58, 406=>56})
  @@abbreviations = {/\sSW\s/ => ' south west ', /\sSE\s/ => ' south east ', /\sNW\s/ => ' north west ', /\sNE\s/ => ' north east ', /\sSt(\s|\.)/ => ' street ', /\sDr(\s|\.)/ => ' drive ' , /\sPl(\s|\.)/ => ' place '}

  def initialize(route_num)
    @route_number =route_num
    @route_name = @@route_number_to_name[route_num]
    @transloc_id = @@rts_to_tranloc_mapper[route_num]
  end

  def found?
    @transloc_id ? true : false
  end

  def self.find_route(route_num)
    new route_num
  end

  def get_info
    @busses = Array.new
    doc = open( "#{@@base_url}/route.php?id=#{@transloc_id}") { |f| Hpricot(f) }
    doc.search('li')[0..-3].each do |bus_html|
      bus_info = bus_html.children.inject("") {|bus_info, element| bus_info << ((!element.inner_text.strip.empty? && (element.inner_text + ". ") ) || "") }
      @@abbreviations.each_pair { |key, val| bus_info.gsub!(key, val) }
      @busses << bus_info
    end
    [@route_name, @busses]
  end
end

get '/' do
  erb :index
end

post '/handle' do
  content_type 'application/xml', :charset => 'utf-8'
  builder :handle
end

get  '/route_info/?*' do
  route = Route.find_route(params[:Digits].strip.to_i) if params[:Digits]
  content_type 'application/xml', :charset => 'utf-8'
  if route && route.found?
    @route_name, @busses = route.get_info
    builder :route_info
  else
    builder :not_found
  end
end


#test cases
class Testing
  def test_routes
    route = Route.find_route(12)
    if route.found?
      @route_name, @busses = route.get_info
      puts @busses.join(', ')
    end
    puts "Bus not found"
  end
end

xml.instruct! :xml, :version=>"1.0"
xml.Response do
 xml.Gather(:action=>"/calls/route_info", :method=>"GET", :timeout=>"10"> do
  xml.Say!("Sorry we couldn't find route #{@route_num}. Please try another route number followed by the pound key", :voice=>"woman")
 end
end
xml.instruct! :xml, :version => '1.0'
xml.Response do 
  xml.Gather (:action => "/calls/route_info", :method=>"GET", :timeout=>"10") do
    xml.Say("Route number #{params[:Digits]} . #{@route_name}",:voice => "man")
    @busses.each do |bus|
     xml.Say(bus.to_s, :voice=>"man")
    end
     xml.Pause
    xml.Say("Please press the rts-route number followed by the pound key or please hangup.", :voice=>"woman")
  end
end
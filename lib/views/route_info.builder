xml.instruct! :xml, :version => '1.0'
xml.Response do 
  xml.Gather (:action => "/route_info/", :method=>"GET", :timeout=>"10") do
    xml.Say("Route number #{params[:Digits]} . #{@route_name}",:voice => "man")
    if @busses && @busses.size>0
      @busses.each do |bus|
        xml.Say(bus.to_s, :voice=>"man")
      end
    else
      xml.Say( "Sorry, We couldn't find information about this route right now. This bus service might not be available at this time.",:voice=>"man") 
    end
    xml.Pause
    xml.Say("Please press the rts-route number followed by the pound key or please hangup.", :voice=>"woman")
  end
end

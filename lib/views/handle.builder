xml.instruct!
xml.Response {
  xml.Gather("action"=>"/route_info/", "method"=>"GET", "timeout"=>"10") {
    xml.Say("Welcome to Gainesville rts locator helper site. Please press the rts-route number followed by the pound key.", "voice"=> "woman")
  }
}

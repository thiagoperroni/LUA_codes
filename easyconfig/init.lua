--Small demo of internet/network controlled relay using ESP8266 (ESP-01) module and 2 channel optoisolated relay board
--Made by Sandeep Vaidya @ Robokits India - http://www.robokits.co.in for demo.
print("entrei")
--Configure relay ouutput pins, pins are floating and relay opto needs ground to be activated. So pins are kept high on startup.
Relay1 = 4
Relay2 = 4
gpio.mode(Relay1, gpio.OUTPUT)
gpio.write(Relay1, gpio.LOW);
--gpio.mode(Relay2, gpio.OUTPUT)
--gpio.write(Relay2, gpio.LOW);
local toggle = "off"
local i =0
wifi.setmode(wifi.STATION) --Set network mode to station to connect it to wifi router. You can also set it to AP to make it a access point allowing connection from other wifi devices.

--Set a static ip so its easy to access
cfg = {
    ip="192.168.0.92",
    netmask="255.255.255.0",
    gateway="192.168.2.15"
  }
wifi.sta.setip(cfg)

--Your router wifi network's SSID and password
wifi.sta.config("CITI-Terreo","1cbe991a14")
--Automatically connect to network after disconnection
wifi.sta.autoconnect(1)
print ("\r\n")
--Print network ip address on UART to confirm that network is connected
print(wifi.sta.getip())
--Create server and send html data, process request from html for relay on/off.
srv=net.createServer(net.TCP)
srv:listen(80,function(conn) --change port number if required. Provides flexibility when controlling through internet.
    conn:on("receive", function(client,request)
        
        
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        
        local _on,_off = "",""
        if(_GET.pin == "ON")then
              gpio.write(Relay1, gpio.HIGH)
              toggle = "on"
              i = i+1
        end      
        if(_GET.pin == "OFF")then
              gpio.write(Relay1, gpio.LOW)
              toggle = "off"
              i = i+1
        end
    --print(_GET.pin) 
    --print("\n")
    --print(toggle)
    --print(i)
    conn:send(toggle)
    conn:on("sent",function(conn) conn:close() end)    
    end)
end)

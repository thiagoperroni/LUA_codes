wifi.setmode(wifi.SOFTAP)
wifi.ap.config({ssid="ESP8266",pwd="12345678"})
print(wifi.getmode())
print(wifi.ap.getip())
print(wifi.ap.getmac())

sv = net.createServer(net.TCP) 
sv:listen(80, function(conn)
    conn:on("receive", function(conn, receivedData) 
        --if ssid
		--if pwd
		--if ssid and pwd
		--	sv:close() chama outro arquivo
    end) 
    conn:on("sent", function(conn) 
    end)
end)

--no outro arquivo
wifi.setmode(wifi.STATION)
wifi.sta.config("ssid","senha")
print(wifi.sta.getip())

function try_connect()
    if (wifi.sta.status() == 5) then
        print("Conectado!")
        print(wifi.sta.getip())
        tmr.stop(0)
    else
        print("Conectando...")
    end
end

tmr.alarm(0,1000,1, function() try_connect() end )

--a simple http web server
srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    --gpio2 1
	--gpio2 0
    end) 
end)
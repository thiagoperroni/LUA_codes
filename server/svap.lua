-- colocar no entrada.lua e depois mudar o nome para init.lua
--wifi.setmode(wifi.SOFTAP)
--wifi.ap.config({ssid="ESP01",pwd="12345678"})
wifi.setmode(wifi.STATIONAP)
wifi.ap.config({ssid="ESP01",pwd="12345678"})
cfg = { ip="192.168.0.93", netmask="255.255.255.0", gateway="192.168.2.15" }
wifi.sta.setip(cfg)

wifi.sta.config("CITI-Terreo","1cbe991a14")
wifi.sta.connect()
--print(wifi.getmode())
print(wifi.ap.getip())
print(wifi.sta.getip())
--print(wifi.ap.getmac())

server=net.createServer(net.TCP)
server:listen(80, function(conexao)
    conexao:on("receive", function(cliente, mensagem)
        if mensagem then
            ini1, ini2 = mensagem:find("GET")
            fim1, fim2 = mensagem:find("HTTP")
            dado = mensagem:sub(ini2+3, fim1-2)
            print(dado)
            --sk:send("POST /banana HTTP/1.1\r\nHost: 192.168.4.1\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")    
            --cliente:send("jojo")
            payloadLen = string.len("resposta")
            conexao:send("HTTP/1.1 200 OK\r\n")
            conexao:send("Content-Length:" .. tostring(payloadLen) .. "\r\n")
            conexao:send("Connection:close\r\n\r\n")
            conexao:send("resposta")
            conexao:on("sent", function(conexao) conexao:close() end)
        end
    end)
end)

--sk=net.createConnection(net.TCP, 0)
--print("oi?")
--sk:on("receive", function(sck, c) print(c) end )
--sk:connect(80,"192.168.4.1")
--sk:on("connection", function(sck,c)
    -- Wait for connection before sending.
    --print("enviou msg")
    --sk:send("POST /banana HTTP/1.1\r\nHost: 192.168.4.1\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
--end)

function restart()
    print("entrei no restart")
    file.remove("configuracoes.txt")
    gpio.write(rele, gpio.HIGH)
    node.restart()
end

function evento()
    print("entrei no evento")
    if gpio.read(botao) == 0 then
        inicio = tmr.now()
    end
    if gpio.read(botao) == 1 then
        fim = tmr.now()
        if (fim - inicio) > delay then
            restart()
        end
    end
end

function configurarPinos()
    print("iniciando pino de saida")
    rele = 3
    gpio.mode(rele, gpio.OUTPUT)
    gpio.write(rele, gpio.HIGH)
    status = "off"

    print("iniciando botao de configuracao")
    botao = 4
    inicio = 0
    fim = 0
    delay = 5000000
    gpio.mode(botao, gpio.INT)
    gpio.trig(botao, 'both', evento)
end

function configurarAccessPoint()
    wifi.setmode(wifi.SOFTAP)
    if wifi.getmode() == 2 then
        print("modo: access point")
    end
    
    ssidAP = "ESP_IOT_" .. wifi.ap.getmac()
    pwdAP = "12345678"
    ipAP, netmaskAP, gatewayAP = wifi.ap.getip()
    wifi.ap.config({ssid = ssidAP, pwd = pwdAP})
        
    print("Configuracoes do Acess Point")
    print("SSID: ".. ssidAP)
    print("SENHA: ".. pwdAP)
    print("IP: "..ipAP)
    print("MASCARA: ".. netmaskAP)
    print("GATEWAY: ".. gatewayAP)
end

function configurarStation()
    wifi.setmode(wifi.STATION)
    if wifi.getmode() == 1 then
        print("modo: station")
    end

    
    wifi.sta.setip({ip=ipSTA, netmask=netmaskSTA, gateway=gatewaySTA})
    wifi.sta.config(ssidSTA, pwdSTA)
    wifi.sta.connect()
    
    print("Configuracoes do Station")
    print("SSID: ".. ssidSTA)
    print("SENHA: ".. pwdSTA)
    print("IP: "..ipSTA)
    print("MASCARA: ".. netmaskSTA)
    print("GATEWAY: ".. gatewaySTA)
    print("NOME: ".. nome)
end

print("init.lua")

configurarPinos()

--wifi.setmode(wifi.STATIONAP)
--    if wifi.getmode() == 1 then
--        print("modo: station acess point")
--    end

if (file.open("configuracoes.txt","r"))then 
    print("lendo configuracoes previas")
    ssidSTA = file.readline()
    ssidSTA = ssidSTA:sub(1, string.len(ssidSTA)-1)
    pwdSTA = file.readline()
    pwdSTA = pwdSTA:sub(1, string.len(pwdSTA)-1)
    ipSTA = file.readline()
    ipSTA = ipSTA:sub(1, string.len(ipSTA)-1)
    netmaskSTA = file.readline()
    netmaskSTA = netmaskSTA:sub(1, string.len(netmaskSTA)-1)
    gatewaySTA = file.readline()
    gatewaySTA = gatewaySTA:sub(1, string.len(gatewaySTA)-1)
    nome = file.readline()
    file.close()
    configurarStation()
else
    print("sem configuracoes previas")
    configurarAccessPoint()
end

print("criando o server")
if server then
    server:close()
end
server = net.createServer(net.TCP) 
server:listen(80, function(conexao)
    conexao:on("receive", function(conexao, mensagem) 
        if mensagem then
            if mensagem:find("192.168.4.1") then
                print("recebeu mensagem de configuracao")
                ini1, ini2 = mensagem:find("GET")
                fim1, fim2 = mensagem:find("HTTP")
                dado = mensagem:sub(ini2+3, fim1-2)
                print(dado)
            
                ini1, ini2 = dado:find("SSID=")
                fim1, fim2 = dado:find("/",ini2)
                if ini2 and fim2 then
                    ssidSTA = dado:sub(ini2+1,fim2-1)
                    print("rede: " .. ssidSTA)
                end
                ini1, ini2 = dado:find("SENHA=")
                fim1, fim2 = dado:find("/", ini2)
                if ini2 and fim2 then
                    pwdSTA = dado:sub(ini2+1,fim2-1)
                    print("senha: " .. pwdSTA)
                end
                ini1, ini2 = dado:find("IP=")
                fim1, fim2 = dado:find("/", ini2)
                if ini2 and fim2 then
                    ipSTA = dado:sub(ini2+1,fim2-1)
                    print("ip: " .. ipSTA)
                end
                ini1, ini2 = dado:find("MASCARA=")
                fim1, fim2 = dado:find("/", ini2)
                if ini2 and fim2 then
                    netmaskSTA = dado:sub(ini2+1,fim2-1)
                    print("mascara: " .. netmaskSTA)
                end
                ini1, ini2 = dado:find("GATEWAY=")
                fim1, fim2 = dado:find("/", ini2)
                if ini2 and fim2 then
                    gatewaySTA = dado:sub(ini2+1,fim2-1)
                    print("gateway: " .. gatewaySTA)
                end
                ini1, ini2 = dado:find("NOME=")
                fim1, fim2 = dado:find("/", ini2)
                if ini2 and fim2 then
                    nome = dado:sub(ini2+1,fim2-1)
                    print("nome: " .. nome)
                end
                if ssidSTA and pwdSTA and ipSTA and netmaskSTA and gatewaySTA and nome then
                    file.open("configuracoes.txt","w") 
                    file.writeline(ssidSTA) 
                    file.writeline(pwdSTA) 
                    file.writeline(ipSTA) 
                    file.writeline(netmaskSTA) 
                    file.writeline(gatewaySTA) 
                    file.writeline(nome) 
                    file.close()
                    print("arquivo de configuracoes criado")
                    configurarStation()
                    resposta = "recebi tudo"
                else
                    resposta = "ainda nao recebi tudo"
                end                
                tamanho = string.len(resposta)
                conexao:send("HTTP/1.1 200 OK\r\n")
                conexao:send("Content-Length:" .. tostring(tamanho) .. "\r\n")
                conexao:send("Connection:close\r\n\r\n")
                conexao:send(resposta)
                conexao:on("sent", function(conexao) conexao:close() end)
            end
            
            if ipSTA and mensagem:find(ipSTA) then
                ini1, ini2 = mensagem:find("GET")
                fim1, fim2 = mensagem:find("HTTP")
                dado = mensagem:sub(ini2+3, fim1-2)
                print(dado)
        
                if dado == "?pin=on" then
                    gpio.write(rele, gpio.LOW)
                    status = "on"    
                end      
                if dado == "?pin=off" then
                    gpio.write(rele, gpio.HIGH)
                    status = "off"
                end
                if dado == "?=nome" then
                    gpio.write(rele, gpio.HIGH)
                    status = nome
                end
                tamanho = string.len(status)
                conexao:send("HTTP/1.1 200 OK\r\n")
                conexao:send("Content-Length:" .. tostring(tamanho) .. "\r\n")
                conexao:send("Connection:close\r\n\r\n")
                conexao:send(status)
                conexao:on("sent", function(conexao) conexao:close() end)
            end
        end
    end) 
end)

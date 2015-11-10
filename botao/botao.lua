pin = 4    --> GPIO2
inicio = 0
fim = 0

function qualquercoisinha()
    print("oi")
end

function onChange ()
    if gpio.read(pin) == 0 then
        inicio = tmr.now()
    end
    if gpio.read(pin) == 1 then
        fim = tmr.now()
        if (fim - inicio) > 5000000 then
            qualquercoisinha()
        end
    end
end

gpio.mode(pin, gpio.INT)
gpio.trig(pin, 'both', onChange)
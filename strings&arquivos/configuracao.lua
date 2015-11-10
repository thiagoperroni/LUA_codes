xxx0 = "xxx"
yyy0 = "yyy"
--num = 1

file.open("test.txt","w")
file.writeline(xxx0)
file.writeline(yyy0)
file.writeline(num)
file.close()

file.open("test.txt","r") 
xxx1 = (file.readline())
yyy1 = (file.readline())
num1 = (file.readline())
file.close()

print(xxx1)
print(yyy1)
print(num1)

num2 = num + 1
file.open("test.txt","a")
file.writeline(num2)
file.close()

dofile("leitura_das_conf.lua")
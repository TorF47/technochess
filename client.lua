socket = require("socket")

client_s_channel = love.thread.getChannel("send")
client_r_channel = love.thread.getChannel("receive")

print("Connecting to server...")
client = socket.try(socket.connect(client_s_channel:demand(), 18288))
client:settimeout(nil)
ip, port = client:getsockname()
client:send("connected\r\n")
local line, err = client:receive("*l")
if err or line ~= "connected" then
	error("Networking failed. " .. err)
end
print("Connected to server successfully.")

while 1 do
	local line, err = client:receive("*l")
	if err then
		error("Networking failed. " .. err)
	end
	local bx = tonumber(line:sub(2,2))
	local by = tonumber(line:sub(3,3))
	local ex = tonumber(line:sub(4,4))
	local ey = tonumber(line:sub(5,5))
	local promotion = line:sub(1,1) == "p"
	local pawn = 0
	if promotion then
		pawn = tonumber(line:sub(6,6))
	end
	client_r_channel:push(bx)
	client_r_channel:push(by)
	client_r_channel:push(ex)
	client_r_channel:push(ey)
	client_r_channel:push(promotion)
	if promotion then
		client_r_channel:push(pawn)
	end
	bx = client_s_channel:demand()
	by = client_s_channel:demand()
	ex = client_s_channel:demand()
	ey = client_s_channel:demand()
	promotion = client_s_channel:demand()
	if not promotion then
		client:send("m" .. bx .. by .. ex .. ey .. "\r\n")
	else
		local pawn = client_s_channel:demand()
		client:send("p" .. bx .. by .. ex .. ey .. pawn .. "\r\n")
	end
end

client:close()
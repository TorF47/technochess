socket = require("socket")

server_s_channel = love.thread.getChannel("send")
server_r_channel = love.thread.getChannel("receive")

server = socket.try(socket.bind("*", 18288))
ip, port = server:getsockname()
print("Server set up on " .. ip .. ":" .. port)
connected = false

print("Waiting for client...")
client = server:accept()
client:settimeout(nil)
local line, err = client:receive("*l")
	
if not err and line == "connected" then
	connected = true
	client:send("connected\r\n")
	server_r_channel:push(true)
	print("Client connected")
else
	client:close()
	error("Networking failed. " .. err)
end

while 1 do
	local bx = server_s_channel:demand()
	local by = server_s_channel:demand()
	local ex = server_s_channel:demand()
	local ey = server_s_channel:demand()
	local promotion = server_s_channel:demand()
	if not promotion then
		client:send("m" .. bx .. by .. ex .. ey .. "\r\n")
	else
		local pawn = server_s_channel:demand()
		client:send("p" .. bx .. by .. ex .. ey .. pawn .. "\r\n")
	end
	local line, err = client:receive("*l")
	if err then
		error("Networking failed. " .. err)
	end
	bx = tonumber(line:sub(2,2))
	by = tonumber(line:sub(3,3))
	ex = tonumber(line:sub(4,4))
	ey = tonumber(line:sub(5,5))
	promotion = line:sub(1,1) == "p"
	local pawn = 0
	if promotion then
		pawn = tonumber(line:sub(6,6))
	end
	server_r_channel:push(bx)
	server_r_channel:push(by)
	server_r_channel:push(ex)
	server_r_channel:push(ey)
	server_r_channel:push(promotion)
	if promotion then
		server_r_channel:push(pawn)
	end
end

client:close()
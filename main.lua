boardWidth = 8
boardHeight = 8
turn = 1
selected = {nil, nil}
turnCount = 0

animations = {}

animationTime = 0.25

check = false

P_USER = 1
P_BOT = 2 --do not use
P_NETWORK = 3

A_BEGINX = 1
A_BEGINY = 2
A_ENDX = 3
A_ENDY = 4
A_ENDTYPE = 5
A_ENDTEAM = 6
A_MOVINGTYPE = 7
A_MOVINGTEAM = 8
A_TIME = 9
A_COUNT = A_TIME

B_TYPE = 1
B_TEAM = 2
B_MOVED = 3
B_OLDX = 4
B_OLDY = 5
B_MOVEDAT = 6
B_COUNT = B_MOVEDAT

T_WHITE = 1
T_BLACK = 2
T_EMPTY = 1
T_PAWN = 2
T_ROOK = 3
T_KNIGHT = 4
T_BISHOP = 5
T_QUEEN = 6
T_KING = 7
T_SELECTED = 8
T_COUNT = T_SELECTED

N_PIECES = {nil, "", "R", "N", "B", "Q", "K"}
N_X = {"a", "b", "c", "d", "e", "f", "g", "h"}
N_Y = {"1", "2", "3", "4", "5", "6", "7", "8"}

players = {P_USER, P_USER}

pgn = ""

botWaitTime = 0
botWaitTimeMax = 0.25

pawnPromotion = false
pawnPromotionX = nil
pawnPromotionY = nil
pawnPromotionAnim = 0

board =
{
	{{T_ROOK, T_WHITE, false, 1, 1, 0}, {T_PAWN, T_WHITE, false, 1, 2, 0}, {T_EMPTY, 1, false, 1, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 1, 5, 0}, {T_EMPTY, 1, false, 1, 6, 0}, {T_PAWN, T_BLACK, false, 1, 7, 0}, {T_ROOK, T_BLACK, false, 1, 8, 0}},
	{{T_KNIGHT, T_WHITE, false, 2, 1, 0}, {T_PAWN, T_WHITE, false, 2, 2, 0}, {T_EMPTY, 1, false, 2, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 2, 5, 0}, {T_EMPTY, 1, false, 2, 6, 0}, {T_PAWN, T_BLACK, false, 2, 7, 0}, {T_KNIGHT, T_BLACK, false, 2, 8, 0}},
	{{T_BISHOP, T_WHITE, false, 3, 1, 0}, {T_PAWN, T_WHITE, false, 3, 2, 0}, {T_EMPTY, 1, false, 3, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 3, 5, 0}, {T_EMPTY, 1, false, 3, 6, 0}, {T_PAWN, T_BLACK, false, 3, 7, 0}, {T_BISHOP, T_BLACK, false, 3, 8, 0}},
	{{T_QUEEN, T_WHITE, false, 4, 1, 0}, {T_PAWN, T_WHITE, false, 4, 2, 0}, {T_EMPTY, 1, false, 4, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 4, 5, 0}, {T_EMPTY, 1, false, 4, 6, 0}, {T_PAWN, T_BLACK, false, 4, 7, 0}, {T_QUEEN, T_BLACK, false, 4, 8, 0}},
	{{T_KING, T_WHITE, false, 5, 1, 0}, {T_PAWN, T_WHITE, false, 5, 2, 0}, {T_EMPTY, 1, false, 5, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 5, 5, 0}, {T_EMPTY, 1, false, 5, 6, 0}, {T_PAWN, T_BLACK, false, 5, 7, 0}, {T_KING, T_BLACK, false, 5, 8, 0}},
	{{T_BISHOP, T_WHITE, false, 6, 1, 0}, {T_PAWN, T_WHITE, false, 6, 2, 0}, {T_EMPTY, 1, false, 6, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 6, 5, 0}, {T_EMPTY, 1, false, 6, 6, 0}, {T_PAWN, T_BLACK, false, 6, 7, 0}, {T_BISHOP, T_BLACK, false, 6, 8, 0}},
	{{T_KNIGHT, T_WHITE, false, 7, 1, 0}, {T_PAWN, T_WHITE, false, 7, 2, 0}, {T_EMPTY, 1, false, 7, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 7, 5, 0}, {T_EMPTY, 1, false, 7, 6, 0}, {T_PAWN, T_BLACK, false, 7, 7, 0}, {T_KNIGHT, T_BLACK, false, 7, 8, 0}},
	{{T_ROOK, T_WHITE, false, 8, 1, 0}, {T_PAWN, T_WHITE, false, 8, 2, 0}, {T_EMPTY, 1, false, 8, 3, 0}, {T_EMPTY, 1, false, 0}, {T_EMPTY, 1, false, 8, 5, 0}, {T_EMPTY, 1, false, 8, 6, 0}, {T_PAWN, T_BLACK, false, 8, 7, 0}, {T_ROOK, T_BLACK, false, 8, 8, 0}}
}
boardBuffer = {}

piecesQuad =
{
	{nil, nil, nil, nil, nil, nil, nil},
	{nil, nil, nil, nil, nil, nil, nil}
}

network = false
isServer = false

function love.load(arg)
	love.graphics.setDefaultFilter("nearest","nearest")
	pieces = love.graphics.newImage("default.png")
	for t=0, 1 do
		for p=0, T_COUNT-1 do
			piecesQuad[t+1][p+1] = love.graphics.newQuad(p * pieces:getWidth()/T_COUNT, t * pieces:getHeight()/2, pieces:getWidth()/T_COUNT, pieces:getHeight()/2, pieces:getWidth(), pieces:getHeight())
		end
	end
	background = love.graphics.newCanvas(boardWidth * (pieces:getWidth()/T_COUNT), boardHeight * (pieces:getHeight()/2))
	love.graphics.setCanvas(background)
	for x=1,boardWidth do
		for y=1,boardHeight do
			if math.fmod(y-1,2)+1 > 1 then
				b = math.fmod(x-1,2)+1
			else
				b = math.fmod(x,2)+1
			end
			love.graphics.draw(pieces, piecesQuad[b][1],(x-1)*(pieces:getWidth()/T_COUNT),(-y+boardHeight)*(pieces:getHeight()/2))
		end
	end
	love.graphics.setCanvas()
	
	if arg[1] == "-server" then players[2] = P_NETWORK end
	if arg[1] == "-client" then players[1] = P_NETWORK end
	
	if players[1] == P_NETWORK or players[2] == P_NETWORK then
		network = true
		isServer = players[2] == P_NETWORK
		isClient = players[1] == P_NETWORK
		
		if isServer and isClient then error("Both players are networks. This is probably bad and I don't want to know the consequences of this so I made it so that it crashed.") end
		
		if isServer then
			server_thread = love.thread.newThread("server.lua")
			server_thread:start()
		elseif isClient then
			client_thread = love.thread.newThread("client.lua")
			client_thread:start()
		end
		network_s_channel = love.thread.getChannel("send")
		network_r_channel = love.thread.getChannel("receive")
		if isClient then
			network_s_channel:push(arg[2])
		end
	end
	
	love.window.setTitle("Techno's Chess - White plays...")
end

function love.update(dt)
	if isServer and not connected then
		local v = network_r_channel:pop()
		if v == true then
			connected = true
		end
	else
		if pawnPromotion and pawnPromotionAnim < animationTime then
			pawnPromotionAnim = pawnPromotionAnim + dt
		end
		for i, animation in ipairs(animations) do
			animation[A_TIME] = animation[A_TIME] + dt
			if animation[A_TIME] > animationTime then
				table.remove(animations, i)
			end
		end
		if players[turn] == P_BOT then
			botWaitTime = botWaitTime + dt
			if botWaitTime >= botWaitTimeMax then
				botWaitTime = 0
				for by = boardHeight, 1, -1 do
					for bx = 1, boardWidth do
						if board[bx][by][B_TYPE] ~= T_EMPTY and board[bx][by][B_TEAM] == turn then
							for ey = boardHeight, 1, -1 do
								for ex = 1, boardWidth do
									if doMove(bx,by,ex,ey) then
										if pawnPromotion then doPawnPromotion(T_QUEEN) end
										return
									end
								end
							end
						end
					end
				end
			end
		elseif players[turn] == P_NETWORK then
			local bx = network_r_channel:pop()
			if bx then
				local by = network_r_channel:pop()
				local ex = network_r_channel:pop()
				local ey = network_r_channel:pop()
				local promotion = network_r_channel:pop()
				doMove(bx,by,ex,ey)
				if promotion then
					doPawnPromotion(network_r_channel:pop())
				end
			end
		end
	end
end

function love.draw()
	local sw = love.graphics.getWidth() / boardWidth
	local sh = love.graphics.getHeight() / boardHeight
	local s = math.min(sw,sh)
	if s == sw then
		love.graphics.translate(0, (love.graphics.getHeight()-love.graphics.getWidth())/2)
	elseif s == sh then
		love.graphics.translate((love.graphics.getWidth()-love.graphics.getHeight())/2, 0)
	end
	love.graphics.scale(s, s)
	love.graphics.draw(background,0,0,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
	for x=1,boardWidth do
		for y=1,boardHeight do
			if board[x][y][B_TYPE] > 1 then
				canDraw = true
				for i, animation in ipairs(animations) do
					if animation[A_ENDX] - math.floor(animation[A_ENDX]) == 0 or animation[A_ENDY] - math.floor(animation[A_ENDY]) then
						if animation[A_ENDX] == x and animation[A_ENDY] == y then
							canDraw = false
							break
						end
					end
				end
				if canDraw then
					love.graphics.draw(pieces, piecesQuad[board[x][y][B_TEAM]][board[x][y][B_TYPE]],x-1,-y+boardHeight,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
					if board[x][y][B_TYPE] == T_KING then
						if check then
							if turn == board[x][y][B_TEAM] then
								love.graphics.draw(pieces, piecesQuad[2][T_SELECTED],x-1,-y+boardHeight,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
							end
						end
					end
				end
			end
		end
	end
	for i, animation in ipairs(animations) do
		if animation[A_ENDTYPE] ~= T_EMPTY then love.graphics.draw(pieces, piecesQuad[animation[A_ENDTEAM]][animation[A_ENDTYPE]],animation[A_ENDX]-1,-animation[A_ENDY]+boardHeight,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2)) end
		if animation[A_MOVINGTYPE] ~= T_EMPTY then love.graphics.draw(pieces, piecesQuad[animation[A_MOVINGTEAM]][animation[A_MOVINGTYPE]],lerp(animation[A_BEGINX], animation[A_ENDX], animation[A_TIME]/animationTime)-1,-lerp(animation[A_BEGINY], animation[A_ENDY], animation[A_TIME]/animationTime)+boardHeight,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2)) end
	end
	if selected[1] ~= nil then
		love.graphics.draw(pieces, piecesQuad[1][T_SELECTED],selected[1]-1,-selected[2]+boardHeight,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
	end
	if pawnPromotion and pawnPromotionAnim >= animationTime and players[turn] == P_USER then
		local ppx = math.min(boardWidth - 0.75,math.max(1.75, pawnPromotionX))-1
		local ppy = -math.min(boardHeight - 0.75,math.max(1.75, pawnPromotionY))+boardHeight
		local sw = love.graphics.getWidth() / boardWidth
		local sh = love.graphics.getHeight() / boardHeight
		local s = math.min(sw,sh)
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		if s == sw then
			my = my - (love.graphics.getHeight()-love.graphics.getWidth())/2
		elseif s == sh then
			mx = mx - (love.graphics.getWidth()-love.graphics.getHeight())/2
		end
		mx = mx / s
		my = my / s
		if my > ppy-0.75 and my < ppy-0.75+1 then
			if mx > ppx-0.75 and mx < ppx-0.75+1 then
				love.graphics.draw(pieces, piecesQuad[1][T_SELECTED], ppx-0.75,ppy-0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
			elseif mx > ppx+0.75 and mx < ppx+0.75+1 then
				love.graphics.draw(pieces, piecesQuad[1][T_SELECTED], ppx+0.75,ppy-0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
			end
		elseif my > ppy+0.75 and my < ppy+0.75+1 then
			if mx > ppx-0.75 and mx < ppx-0.75+1 then
				love.graphics.draw(pieces, piecesQuad[1][T_SELECTED], ppx-0.75,ppy+0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
			elseif mx > ppx+0.75 and mx < ppx+0.75+1 then
				love.graphics.draw(pieces, piecesQuad[1][T_SELECTED], ppx+0.75,ppy+0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
			end
		end
		love.graphics.draw(pieces, piecesQuad[board[pawnPromotionX][pawnPromotionY][B_TEAM]][T_ROOK], ppx-0.75,ppy-0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
		love.graphics.draw(pieces, piecesQuad[board[pawnPromotionX][pawnPromotionY][B_TEAM]][T_KNIGHT],ppx+0.75,ppy-0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
		love.graphics.draw(pieces, piecesQuad[board[pawnPromotionX][pawnPromotionY][B_TEAM]][T_BISHOP],ppx-0.75,ppy+0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
		love.graphics.draw(pieces, piecesQuad[board[pawnPromotionX][pawnPromotionY][B_TEAM]][T_QUEEN],ppx+0.75,ppy+0.75,0,1/(pieces:getWidth()/T_COUNT),1/(pieces:getHeight()/2))
		
	end
end

function love.mousepressed(x, y)
	if not (isServer and not connected) then
		if players[turn] == P_USER then
			local sw = love.graphics.getWidth() / boardWidth
			local sh = love.graphics.getHeight() / boardHeight
			local s = math.min(sw,sh)
			if s == sw then
				y = y - (love.graphics.getHeight()-love.graphics.getWidth())/2
			elseif s == sh then
				x = x - (love.graphics.getWidth()-love.graphics.getHeight())/2
			end
			if not pawnPromotion then
				x = math.floor(x / s)+1
				y = math.floor(-y / s)+1+boardHeight
				if x > 0 and x <= boardWidth and y > 0 and y <= boardHeight then
					if board[x][y][B_TYPE] > 1 and board[x][y][B_TEAM] == turn then
						selected = {x,y}
					else
						if selected[1] ~= nil then
							doMove(selected[1],selected[2],x,y)
							selected = {nil,nil}
						end
					end
				end
			else
				local ppx = math.min(boardWidth - 0.75,math.max(1.75, pawnPromotionX))-1
				local ppy = -math.min(boardHeight - 0.75,math.max(1.75, pawnPromotionY))+boardHeight
				x = x / s
				y = y / s
				if y > ppy-0.75 and y < ppy-0.75+1 then
					if x > ppx-0.75 and x < ppx-0.75+1 then
						doPawnPromotion(T_ROOK)
					elseif x > ppx+0.75 and x < ppx+0.75+1 then
						doPawnPromotion(T_KNIGHT)
					end
				elseif y > ppy+0.75 and y < ppy+0.75+1 then
					if x > ppx-0.75 and x < ppx-0.75+1 then
						doPawnPromotion(T_BISHOP)
					elseif x > ppx+0.75 and x < ppx+0.75+1 then
						doPawnPromotion(T_QUEEN)
					end
				end
			end
		end
	end
end

function doMove(bx, by, ex, ey)
	if not pawnPromotion then
		local yes, moveName = move(bx,by,ex,ey)
		if yes then
			if turn == 1 then
				moveName = math.floor((turnCount / 2)+1) .. ". " .. moveName
			end
			pgn = pgn .. moveName
			if board[ex][ey][B_TYPE] == T_PAWN and ((board[ex][ey][B_TEAM] == 1 and ey == boardHeight) or (board[ex][ey][B_TEAM] == 2 and ey == 1)) then
				pawnPromotion = true
				pawnPromotionX = ex
				pawnPromotionY = ey
				pawnPromotionAnim = 0
				if players[turn] == P_USER then
					local ppx = math.min(boardWidth - 0.75,math.max(1.75, ex))
					local ppy = math.min(boardHeight - 0.75,math.max(1.75, ey))
					addAnimation(bx, by, ppx-0.75, ppy+0.75, T_EMPTY, nil, T_ROOK, turn)
					addAnimation(bx, by, ppx+0.75, ppy+0.75, T_EMPTY, nil, T_KNIGHT, turn)
					addAnimation(bx, by, ppx-0.75, ppy-0.75, T_EMPTY, nil, T_BISHOP, turn)
					addAnimation(bx, by, ppx+0.75, ppy-0.75, T_EMPTY, nil, T_QUEEN, turn)
				end
			else
				pgn = pgn .. " "
			end
			if network and players[turn] ~= P_NETWORK then
				network_s_channel:push(bx)
				network_s_channel:push(by)
				network_s_channel:push(ex)
				network_s_channel:push(ey)
				network_s_channel:push(pawnPromotion)
			end
			if not pawnPromotion then
				doTurn()
			end
		end
		return yes
	end
end

function doPawnPromotion(pawn)
	if pawn == T_QUEEN or pawn == T_BISHOP or pawn == T_ROOK or pawn == T_KNIGHT then
		if players[turn] == P_USER then
			local ppx = math.min(boardWidth - 0.75,math.max(1.75, pawnPromotionX))
			local ppy = math.min(boardHeight - 0.75,math.max(1.75, pawnPromotionY))
			local bx = ppx
			local by = ppy
			if pawn == T_ROOK or pawn == T_BISHOP then
				bx = bx - 0.75
			else
				bx = bx + 0.75
			end
			if pawn == T_ROOK or pawn == T_KNIGHT then
				by = by + 0.75
			else
				by = by - 0.75
			end
			addAnimation(bx, by, pawnPromotionX, pawnPromotionY, board[pawnPromotionX][pawnPromotionY][B_TYPE], board[pawnPromotionX][pawnPromotionY][B_TEAM], pawn, turn)
		end
		board[pawnPromotionX][pawnPromotionY][B_TYPE] = pawn
		pgn = pgn .. "=" .. N_PIECES[pawn] .. " "
		pawnPromotion = false
		updateBuffer()
		checkForCheck(pawnPromotionX, pawnPromotionY, false, getKing(board[pawnPromotionX][pawnPromotionY][B_TEAM]))
		if network and players[turn] ~= P_NETWORK then
			network_s_channel:push(pawn)
		end
		doTurn()
	end
end

function doTurn()
	turnCount = turnCount + 1
	if turn == 1 then
		turn = 2
		love.window.setTitle("Techno's Chess - Black plays...")
	else
		turn = 1
		love.window.setTitle("Techno's Chess - White plays...")
	end
end

function love.keypressed(key)
	if key == "s" then
		local i = 1
		if not love.filesystem.getInfo("games") then
			love.filesystem.createDirectory("games")
		end
		while love.filesystem.getInfo("games/" .. i .. ".pgn") do
			i = i + 1
		end
		local file = love.filesystem.newFile("games/" .. i .. ".pgn","w")
		file:write(pgn)
		file:flush()
		file:close()
	end
end

function move(bx,by,ex,ey)
	local yes, moveName = trymove(bx,by,ex,ey,true)
	if yes then
		addAnimation(bx, by, ex, ey, board[ex][ey][B_TYPE], board[ex][ey][B_TEAM], board[bx][by][B_TYPE], board[bx][by][B_TEAM])

		board[ex][ey][B_TYPE] = board[bx][by][B_TYPE]
		board[ex][ey][B_TEAM] = board[bx][by][B_TEAM]
		board[bx][by][B_TYPE] = T_EMPTY
		board[bx][by][B_MOVED] = true
		board[ex][ey][B_MOVED] = true
		board[ex][ey][B_OLDX] = bx
		board[ex][ey][B_OLDY] = by
		board[ex][ey][B_MOVEDAT] = turnCount
		
		return true, moveName
	end
	return false
end

function addAnimation(beginx, beginy, endx, endy, endtype, endteam, movingtype, movingteam)
	local animation = {}
	animation[A_BEGINX] = beginx
	animation[A_BEGINY] = beginy
	animation[A_ENDX] = endx
	animation[A_ENDY] = endy
	animation[A_ENDTYPE] = endtype
	animation[A_ENDTEAM] = endteam
	animation[A_MOVINGTYPE] = movingtype
	animation[A_MOVINGTEAM] = movingteam
	animation[A_TIME] = 0
	table.insert(animations, animation)
end

function trymove(bx, by, ex, ey, go, useBuffer)
	if useBuffer == nil then useBuffer = false end
	local _board = board
	if useBuffer then
		_board = boardBuffer
	end
	if bx == ex and by == ey then return false end
	if _board[bx][by][B_TYPE] == T_EMPTY then return false end
	local capture = false
	if _board[ex][ey][B_TYPE] ~= T_EMPTY then
		if _board[bx][by][B_TEAM] == _board[ex][ey][B_TEAM] then
			return false
		end
		capture = true
	end
	local moveName = nil
	local needX = false
	local needY = false
	if go then
		for x = 1, boardWidth do
			for y = 1, boardHeight do
				if not (x == bx and y == by) and _board[x][y][B_TYPE] == _board[bx][by][B_TYPE] and _board[x][y][B_TEAM] == _board[bx][by][B_TEAM] then
					if trymove(x,y,ex,ey,false) then
						if x ~= bx then needX = true
						elseif y ~= by then needY = true end
					end
				end
			end
		end
	end
	local ax = bx
	local castling = false
	--PAWN
	if _board[bx][by][B_TYPE] == T_PAWN then
		if _board[bx][by][B_TEAM] == T_WHITE then
			if ey < by + 1 then return false end
			if ex == bx then
				if _board[ex][ey][B_TYPE] > 1 then return false end
				if by ~= ey - 1 and (_board[bx][by][B_MOVED] or _board[bx][by+1][B_TYPE] ~= T_EMPTY or by ~= ey - 2) then return false end
			elseif math.abs(ex-bx) == 1 and math.abs(ey-by) == 1 then
				if _board[ex][ey][B_TYPE] == T_EMPTY then
					if ey < 8 and _board[ex][ey-1][B_TYPE] == T_PAWN and _board[ex][ey+1][B_TYPE] == T_EMPTY and _board[ex][ey-1][B_OLDX] == ex and _board[ex][ey-1][B_OLDY] == ey+1 and _board[ex][ey-1][B_MOVEDAT] == turnCount-1 then
						needX = true
						capture = true
						if go then
							_board[ex][ey-1][B_TYPE] = T_EMPTY
						end
					else return false end
				else
					needX = true
				end
			else return false end
		elseif _board[bx][by][B_TEAM] == T_BLACK then
			if ey > by - 1 then return false end
			if ex == bx then
				if _board[ex][ey][B_TYPE] > 1 then return false end
				if by ~= ey + 1 and (_board[bx][by][B_MOVED] or _board[bx][by-1][B_TYPE] ~= T_EMPTY or by ~= ey + 2) then return false end
			elseif math.abs(ex-bx) == 1 and math.abs(ey-by) == 1  then
				if _board[ex][ey][B_TYPE] == T_EMPTY then
					if ey > 1 and _board[ex][ey+1][B_TYPE] == T_PAWN and _board[ex][ey-1][B_TYPE] == T_EMPTY and _board[ex][ey+1][B_OLDX] == ex and _board[ex][ey+1][B_OLDY] == ey-1 and _board[ex][ey+1][B_MOVEDAT] == turnCount-1 then
						needX = true
						capture = true
						if go then
							_board[ex][ey+1][B_TYPE] = T_EMPTY
						end
					else return false end
				else
					needX = true
				end
			else return false end
		end
	--ROOK
	elseif _board[bx][by][B_TYPE] == T_ROOK then
		if bx-ex ~= 0 and by-ey ~= 0 then return false end
		if not pathclear(bx,by,ex,ey,useBuffer) then return false end
	--KNIGHT
	elseif _board[bx][by][B_TYPE] == T_KNIGHT then
		dx = math.abs(bx-ex)
		dy = math.abs(by-ey)
		if not((dx == 1 and dy == 2) or (dx == 2 and dy == 1)) then return false end
	--BISHOP
	elseif _board[bx][by][B_TYPE] == T_BISHOP then
		if math.abs(bx-ex) ~= math.abs(by-ey) then return false end
		if not pathclear(bx,by,ex,ey,useBuffer) then return false end
	--QUEEN
	elseif _board[bx][by][B_TYPE] == T_QUEEN then
		if not pathclear(bx,by,ex,ey,false,useBuffer) then return false end
	--KING
	elseif _board[bx][by][B_TYPE] == T_KING then
		if not check and by-ey == 0 and not _board[bx][by][B_MOVED] then
			if ex == bx + 2 then
				ax = bx + 3
			elseif ex == bx - 2 then
				ax = bx - 4
			end
			if _board[ax][by][B_TYPE] == T_ROOK and (not _board[ax][by][B_MOVED]) and _board[ax][by][B_TEAM] == _board[bx][by][B_TEAM] and pathclear(bx,by,ax,by) then
				castling = true
				if bx > ex then
					moveName = "O-O-O"
				elseif bx < ex then
					moveName = "O-O"
				end
			end
		end
		if not castling then
			if math.max(math.abs(bx-ex), math.abs(by-ey)) > 1 then
				return false
			end
		end
	end
	if not useBuffer then
		updateBuffer()
		moveBuffer(bx,by,ex,ey)
		local fkx, fky = getKing(boardBuffer[bx][by][B_TEAM] == 1 and 2 or 1, true)
		local ekx, eky = getKing(boardBuffer[bx][by][B_TEAM], true)
		if fkx ~= nil then
			for x = 1, boardWidth do
				for y = 1, boardHeight do
					if boardBuffer[x][y][B_TYPE] > T_EMPTY then
						if boardBuffer[x][y][B_TEAM] ~= board[bx][by][B_TEAM] then
							if trymove(x,y,fkx,fky,false,true) then
								return false
							end
						end
					end
				end
			end
		end
		checkForCheck(ex,ey,true, ekx,eky)
	end
	if castling then
		move(ax,by,ax > bx and ex-1 or ex+1,ey, go, useBuffer)
	end
	if moveName == nil then
		moveName = N_PIECES[_board[bx][by][B_TYPE]]
		if needX then moveName = moveName .. N_X[bx] end
		if needY then moveName = moveName .. N_Y[by] end
		if capture then moveName = moveName .. "x" end
		moveName = moveName .. N_X[ex] .. N_Y[ey]
		if check then moveName = moveName .. "+" end
	end
	return true, moveName
end

function checkForCheck(ex,ey,useBuffer,ekx,eky)
	local _board = board
	if useBuffer then _board = boardBuffer end
	check = trymove(ex,ey,ekx,eky,false,true)
	if check then love.system.vibrate(0.1) end
end
function getKing(team,useBuffer)
	local _board = board
	if useBuffer then _board = boardBuffer end
	for x = 1, boardWidth do
		for y = 1, boardHeight do
			if _board[x][y][B_TYPE] == T_KING then
				if _board[x][y][B_TEAM] ~= team then
					return x,y
				end
			end
		end
	end
end

function pathclear(bx,by,ex,ey,c,useBuffer)
	local _board = board
	if useBuffer then _board = boardBuffer end
	local dx = math.abs(bx-ex)
	local dy = math.abs(by-ey)
	local d = math.max(dx, dy)
	local diagonal = dx == dy
	local straight = dx == 0 or dy == 0
	if not diagonal and not straight then return c end
	local down = by > ey
	local up = by < ey
	local left = bx > ex
	local right = bx < ex
	local cx = left or right
	local cy = up or down
	for i = 1, (cx and dx or dy) - 1 do
		x = bx
		y = by
		if left then x = bx - i
		elseif right then x = bx + i end
		if up then y = by + i
		elseif down then y = by - i end
		if _board[x][y][B_TYPE] ~= T_EMPTY then return false end
	end
	return true
end

function updateBuffer()
	for x = 1, boardWidth do
		if boardBuffer[x] == nil then boardBuffer[x] = {} end
		for y = 1, boardHeight do
			if boardBuffer[x][y] == nil then boardBuffer[x][y] = {} end
			for i = 1, B_COUNT do
				boardBuffer[x][y][i] = board[x][y][i]
			end
		end
	end
end
function moveBuffer(bx,by,ex,ey)
	for i = 1, B_COUNT do
		boardBuffer[ex][ey][i] = boardBuffer[bx][by][i]
	end
	boardBuffer[bx][by][B_TYPE] = T_EMPTY
end
function lerp(a,b,t)
	return a*(1-t)+(b*t)
end
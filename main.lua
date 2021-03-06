-- COPYRIGHT: KISELEV NIKOLAY
-- Licence: MIT
-- StoneDust
-- Version: 2.2.0.0

if not love.filesystem.exists("clr.i") then
	love.filesystem.write("clr.i", "#FF6E40")
end

protomet = love.filesystem.read("met.i")
if protomet == nil then
	protomet = "-5-3-2-503-606-505040206-504-602"
	love.filesystem.write("lvl.i", 1)
end
metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
love.filesystem.write("met.i", table.concat(metamet, ""))
st = love.filesystem.read("stndst.i")
if st ~= nil then
	score = tonumber(st)
else
	score = 1
end

sec = 0
fur = {w = 1500, h = 750}
met = {tonumber(metamet[1])*30+1100, tonumber(metamet[2])*30+400, tonumber(metamet[3])*30+1100, tonumber(metamet[4])*30+400, tonumber(metamet[5])*30+1100, tonumber(metamet[6])*30+400, tonumber(metamet[7])*30+1100, tonumber(metamet[8])*30+400, tonumber(metamet[9])*30+1100, tonumber(metamet[10])*30+400, tonumber(metamet[11])*30+1100, tonumber(metamet[12])*30+400, tonumber(metamet[13])*30+1100, tonumber(metamet[14])*30+400, tonumber(metamet[15])*30+1100, tonumber(metamet[16])*30+400}
stars = {}
for i = 1, 1000 do
	stars[i] = {love.math.random(0, fur.w * 3), love.math.random(-fur.h * 3, fur.h)}
end

function fit()
	local w, h = love.window.getMode()
	if w / fur.w < h / fur.h then
		s = w / fur.w
		t = {0, (h / s - fur.h) / 2}
	else
		s = h / fur.h
		t = {(w / s - fur.w) / 2, 0}
	end
end

function plymain()
	if not love.filesystem.exists("no.music") then
		mus = "__m"
		if love.audio.getSourceCount() < 1 then
			mainsou = love.audio.newSource("da.mp3", "stream")
			mainsou:setLooping(true)
			mainsou:play()
		end
	else
		mus = "nom"
		love.audio.stop()
	end
end

function hc(hex)
	hex = hex:gsub("#","")
	return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

colors = {
	{159, 168, 218},
	{92, 107, 192},
	{63, 81, 181},
	{hc(love.filesystem.read("clr.i"))},
	{33, 150, 243}
}

love.window.setMode(1200, 600, {borderless = true, fullscreen = true})
love.window.setPosition(0, 0)
love.graphics.setBackgroundColor(colors[3])
if love.filesystem.exists("main.ttf") then
	aqua = {
		love.graphics.newFont("main.ttf", 170),
		love.graphics.newFont("main.ttf", 170 * 0.75),
		love.graphics.newFont("main.ttf", 170 * 0.5),
		love.graphics.newFont("main.ttf", 170 * 0.4),
		love.graphics.newFont("main.ttf", 40)
	}
end
fit()
plymain()
do --MESH
	backimg = love.graphics.newImage("bg.bmp")
	backimg:setWrap("repeat")
	backimg:setFilter("nearest")
	local w, h = love.window.getMode()
	local iw, ih = backimg:getDimensions()
	iw = iw / s
	ih = ih / s
	if w / fur.w < h / fur.h then
		side = t[2]
		fortouch = {0, side}
		meshp = {x1 = 0, y1 = -side, x2 = 0, y2 = fur.h}
		vertices = {
		{ -- top-left
			0, 0,
			0, 0,
			255, 255, 255},
		{ -- top-right
			fur.w, 0,
			fur.w / iw, 0,
			255, 255, 255},
		{ -- bottom-right
			fur.w, side,
			fur.w / iw, side / ih,
			255, 255, 255},
		{ -- bottom-left
			0, side,
			0, side / ih,
			255, 255, 255}
		}
	else
		side = t[1]
		fortouch = {side, 0}
		meshp = {x1 = -side, y1 = 0, x2 = fur.w, y2 = 0}
		vertices = {
		{ -- top-left
			0, 0,
			0, 0,
			255, 255, 255},
		{ -- top-right
			side, 0,
			side / iw, 0,
			255, 255, 255},
		{ -- bottom-right
			side, fur.h,
			side / iw, fur.h / ih,
			255, 255, 255},
		{ -- bottom-left
			0, fur.h,
			0, fur.h / ih,
			255, 255, 255}
		}
	end
	mesh = love.graphics.newMesh(vertices, "fan")
	mesh:setTexture(backimg)
end

function love.mousepressed(x, y)
	local w, h = love.window.getMode()
	x = (x - (fortouch[1] * s)) / (fur.w * s)
	y = (y - (fortouch[2] * s)) / (fur.h * s)
	if y < 0.6 and y > 0.4 and x > 0.1 and x < 0.6 then
		love.filesystem.load("start.lua")()
	end
	if y < 0.8 and y > 0.6 and x > 0.15 and x < 0.55 then
		love.filesystem.load("deshop.lua")()
	end
	if y < 0.9 and y > 0.8 and x > 0.2 and x < 0.5 then
		love.event.quit()
	end
	if x > 0.9 and y < 0.1 then
		if love.filesystem.exists("no.music") then
			love.filesystem.remove("no.music")
		else
			love.filesystem.write("no.music", "")
		end
		plymain()
	end
end

function love.update(dt)
	if love.keyboard.isDown("0") then
		love.filesystem.remove("lvl.i")
		love.filesystem.remove("met.i")
		love.filesystem.remove("stndst.i")
		love.filesystem.remove("clr.i")
		love.event.quit()
	end
	if love.keyboard.isDown("9") then
		protomet = "-5-3-2-503-606-505040206-504-602"
		love.filesystem.write("lvl.i", 1)
		metamet = {protomet:sub(1,2), protomet:sub(3,4), protomet:sub(5,6), protomet:sub(7,8), protomet:sub(9,10), protomet:sub(11,12), protomet:sub(13,14), protomet:sub(15,16), protomet:sub(17,18), protomet:sub(19,20), protomet:sub(21,22), protomet:sub(23,24), protomet:sub(25,26), protomet:sub(27,28), protomet:sub(29,30), protomet:sub(31,32)}
		love.filesystem.write("met.i", table.concat(metamet, ""))
		st = love.filesystem.write("stndst.i", 1000)
		love.event.quit()
	end
	sec = sec + dt
	if sec > 0.05 then
		sec = 0
		for i = 1, #stars do
			local old = stars[i]
			stars[i] = {old[1] + (love.math.random(-20, 20) / 50) - 0.2, old[2] + (love.math.random(-20, 20) / 50) + 0.5}
		end
		for i = 1, #met / 2 do
			local old = met[i * 2 - 1]
			met[i * 2 - 1] = old + (love.math.random(-20, 20) / 20) - 0.2
			local old = met[i * 2]
			met[i * 2] = old + (love.math.random(-20, 20) / 20) + 0.5
		end
	end
end

function love.draw()
	love.graphics.scale(s, s)
	love.graphics.translate(t[1], t[2])
	love.graphics.setLineStyle("smooth")
	love.graphics.setLineWidth(1)	
	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.print(mus, 1400, 10, 0, 0.5)
	love.graphics.setColor(255, 255, 255, 200)
	for i = 1, #stars do
		love.graphics.circle("line", stars[i][1], stars[i][2], 1)
	end
	love.graphics.setColor(255, 255, 255, 50)
	love.graphics.setLineWidth(3)
	for i = 1, #met / 2 do
		love.graphics.circle("line", met[i * 2 - 1], met[i * 2], 1)
	end
	love.graphics.setLineWidth(1)
	love.graphics.polygon("line", met)
	love.graphics.setColor(colors[1])
	love.graphics.setFont(aqua[1])
	love.graphics.print("Stone Dust", 30, 110, math.rad(-8))
	love.graphics.setFont(aqua[2])
	love.graphics.print("Start game", 170, 300, math.rad(-7))
	love.graphics.setFont(aqua[3])
	love.graphics.print("De Shop", 320, 460, math.rad(-6))
	love.graphics.setFont(aqua[4])
	love.graphics.print("Exit", 410, 570, math.rad(-5))
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, meshp.x1, meshp.y1)
	love.graphics.draw(mesh, meshp.x2, meshp.y2)
end

function pause()
	local screen = love.draw
	local mousen = love.mousepressed
	local updatn = love.update
	local met = {tonumber(metamet[1])*30+1100, tonumber(metamet[2])*30+400, tonumber(metamet[3])*30+1100, tonumber(metamet[4])*30+400, tonumber(metamet[5])*30+1100, tonumber(metamet[6])*30+400, tonumber(metamet[7])*30+1100, tonumber(metamet[8])*30+400, tonumber(metamet[9])*30+1100, tonumber(metamet[10])*30+400, tonumber(metamet[11])*30+1100, tonumber(metamet[12])*30+400, tonumber(metamet[13])*30+1100, tonumber(metamet[14])*30+400, tonumber(metamet[15])*30+1100, tonumber(metamet[16])*30+400}
	local stars = {}
	for i = 1, 1000 do
		stars[i] = {love.math.random(0, fur.w * 3), love.math.random(-fur.h * 3, fur.h)}
	end
	function love.update(dt)
		sec = sec + dt
		if bitso ~= nil then
			bitso:pause()
		end
		if sec > 0.05 then
			sec = 0
			for i = 1, #stars do
				local old = stars[i]
				stars[i] = {old[1] + (love.math.random(-20, 20) / 50) - 0.2, old[2] + (love.math.random(-20, 20) / 50) + 0.5}
			end
			for i = 1, #met / 2 do
				local old = met[i * 2 - 1]
				met[i * 2 - 1] = old + (love.math.random(-20, 20) / 20) - 0.2
				local old = met[i * 2]
				met[i * 2] = old + (love.math.random(-20, 20) / 20) + 0.5
			end
		end
	end
	function love.mousepressed(x, y)
		local w, h = love.window.getMode()
		x = (x - (fortouch[1] * s)) / (fur.w * s)
		y = (y - (fortouch[2] * s)) / (fur.h * s)
		if x < 0.7 and y > 0 then
			if y < 0.6 then
				love.draw = screen
				love.mousepressed = mousen
				love.update = updatn
				if bitso ~= nil then
					bitso:resume()
				end
			elseif y < 0.8 then
				love.filesystem.load("start.lua")()
			elseif y < 1 then
				love.filesystem.load("main.lua")()
			end
		end
	end
	function love.draw()
		love.graphics.scale(s, s)
		love.graphics.translate(t[1], t[2])
		love.graphics.setLineStyle("smooth")
		love.graphics.setLineWidth(1)	
		love.graphics.setColor(255, 255, 255, 200)
		for i = 1, #stars do
			love.graphics.circle("line", stars[i][1], stars[i][2], 1)
		end
		love.graphics.setColor(255, 255, 255, 50)
		love.graphics.setLineWidth(3)
		for i = 1, #met / 2 do
			love.graphics.circle("line", met[i * 2 - 1], met[i * 2], 1)
		end
		love.graphics.setLineWidth(1)
		love.graphics.polygon("line", met)
		love.graphics.setColor(colors[1])
		love.graphics.setFont(aqua[1])
		love.graphics.print("Star Pause", 10, 110, math.rad(-8))
		love.graphics.setFont(aqua[2])
		love.graphics.print("Resume game", 140, 300, math.rad(-7))
		love.graphics.setFont(aqua[3])
		love.graphics.print("Restart", 330, 440, math.rad(-6))
		love.graphics.setFont(aqua[4])
		love.graphics.print("Exit", 410, 570, math.rad(-5))
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(mesh, meshp.x1, meshp.y1)
		love.graphics.draw(mesh, meshp.x2, meshp.y2)
	end
end
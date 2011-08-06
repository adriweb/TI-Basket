-----------------
--- TI-Basket ---
---- Adriweb ----
-----------------
-- Contact : adrienbertrand@msn.com
-----------------
-- Version 2.1 --
-----------------
-- Thanks go Jimbauwens, Levak, ldebroux, John Powers, Todd Wostrel
-- Ti-Bank, Omnimaga, Cemetech and everybody else I forgot :P
-----------------

-- 'Globals'

power = 50
pi = 3.1416
angle = pi/4
xcoord = 0
ycoord = 0
cstGrav = 9.81
tablex = {0}
tabley = {0}
valtmp = 1
mass = 2
kx = 0.00001 -- min : -0.5, default : 0.00001, max = 0.5
ky = 0.00001 -- min : -0.5, default : 0.00001, max = 0.5
mustGo = false
isRunning = false
hauteur = 70
posxmin = 285
posxmax = 313
win = false
goingup = true
hardcoreMode = false
needMenu = true
tmpsignx = 1
tmpsigny = 1
alwaysMove = false
needScore = false
score = 0
tries = 0
accuracy = 0
timeattack = false
starTime = 0
timeleft = -1
gameover = false


-- End 'Globals'


-- From BetterLuaAPI

function drawPoint(x, y)
	myGC:setPen("thin", "smooth")
	myGC:drawLine(x, y, x, y)
end

function drawCircle(x, y, diameter)
	myGC:drawArc(x - diameter*0.5, y - diameter*0.5, diameter,diameter,0,360)
end

function drawCenteredString(str)
	myGC:drawString(str, (pww() - platform.gc():getStringWidth(str)) / 2, pwh() / 2, "middle")
end

function drawSquare(x,y,l)
	myGC:drawPolyLine({(x-l*0.5),(y-l*0.5), (x+l*0.5),(y-l*0.5), (x+l*0.5),(y+l*0.5), (x-l*0.5),(y+l*0.5), (x-l*0.5),(y-l*0.5)})
end

function drawRoundRect(x,y,width,height,radius)
	x = x-width*0.5  -- let the center of the square be the origin (x coord)
	y = y-height*0.5 -- same for y coord
	if radius > height*0.5 then radius = height*0.5 end -- avoid drawing cool but unexpected shapes. This will draw a circle (max radius)
	myGC:drawLine(x + radius, y, x + width - (radius), y);
	myGC:drawArc(x + width - (radius*2), y + height - (radius*2), radius*2, radius*2, 270, 90);
	myGC:drawLine(x + width, y + radius, x + width, y + height - (radius));
	myGC:drawArc(x + width - (radius*2), y, radius*2, radius*2,0,90);
	myGC:drawLine(x + width - (radius), y + height, x + radius, y + height);
	myGC:drawArc(x, y, radius*2, radius*2, 90, 90);
	myGC:drawLine(x, y + height - (radius), x, y + radius);
	myGC:drawArc(x, y + height - (radius*2), radius*2, radius*2, 180, 90);
end

function fillRoundRect(x,y,width,height,radius)  -- renders badly when transparency (alpha) is not at maximum >< will re-code later
	if radius > height*0.5 then radius = height*0.5 end -- avoid drawing cool but unexpected shapes. This will draw a circle (max radius)
    myGC:fillPolygon({(x-width*0.5),(y-height*0.5+radius), (x+width*0.5),(y-height*0.5+radius), (x+width*0.5),(y+height*0.5-radius), (x-width*0.5),(y+height*0.5-radius), (x-width*0.5),(y-height*0.5+radius)})
    myGC:fillPolygon({(x-width*0.5-radius+1),(y-height*0.5), (x+width*0.5-radius+1),(y-height*0.5), (x+width*0.5-radius+1),(y+height*0.5), (x-width*0.5+radius),(y+height*0.5), (x-width*0.5+radius),(y-height*0.5)})
    x = x-width*0.5  -- let the center of the square be the origin (x coord)
	y = y-height*0.5 -- same
	myGC:fillArc(x + width - (radius*2), y + height - (radius*2), radius*2, radius*2, 1, -91);
    myGC:fillArc(x + width - (radius*2), y, radius*2, radius*2,-2,91);
    myGC:fillArc(x, y, radius*2, radius*2, 85, 95);
    myGC:fillArc(x, y + height - (radius*2), radius*2, radius*2, 180, 95);
end

function pww()
	return platform.window:width()
end

function pwh()
	return platform.window:height()
end

function test(arg)
		if arg == true then
			return 1
		elseif arg == false then
			return 0
		end
end

function refresh()
	platform.window:invalidate()
end

-- End BetterLuaAPI


function on.paint(gc)
	if not myGC then myGC = gc end
	gc:setColorRGB(0,0,0)
	-- gc:drawString("memory usage=" .. tostring(collectgarbage("count")*1024) .. " bytes", 10, 10, "top")
	gc:drawString(" Ti-Basket - Adriweb 2011",0,0,"top")
		
	if (needMenu) then
		menu(gc)
	else
	
			drawBackground(gc)
			gc:drawImage(theguyImage,0,pwh()-image.height(theguyImage))
			if isRunning == false then
				gc:drawImage(theballImage,14,pwh()-image.height(theguyImage)-2)
			end
			gc:setColorRGB(0,0,255)
			gc:drawLine(0,pwh(),power*math.cos(angle),pwh()-power*math.sin(angle))
			-- on trace la flèche de l'origine
			gc:setColorRGB(0,0,0)
			timer.start(0.01)
			mainStuff(gc)
		
		if gameover then

		mustGo = false
		isRunning = false
		alwaysMove = false
		xmax = pww()
		gc:setColorRGB(150,150,150)
		drawRoundRect(xmax*0.5,109,101,23,5)
		gc:setColorRGB(50,50,50)
		fillRoundRect(xmax*0.5,109,100,21,5)
		gc:setColorRGB(255,255,255)
		drawCenteredString("Time's up !")
		refresh()
		
		end
		
	end
		
	if win then
		goWin(gc)
	end
	
end

function drawBackground(gc)
	gc:setColorRGB(255,150,80)
	gc:fillRect(0,165,pww(),165)
	gc:setColorRGB(255,255,255)
	gc:drawArc(pww()*0.5-60,pwh()-30, 120,80,0,180)
end

function goWin(gc)
	if needScore then
	score = score + 1
	end
	needScore = false
	xmax = pww()
	if timeattack == false then
		gc:setColorRGB(150,150,150)
		drawRoundRect(xmax*0.5,109,101,23,5)
		gc:setColorRGB(50,50,50)
		fillRoundRect(xmax*0.5,109,100,21,5)
		gc:setColorRGB(255,255,255)
		drawCenteredString("You Win !")
	else
		on.arrowKey("left")
	end
	refresh()
end

function mainStuff(gc)
	gc:drawString(" Score : " .. score .. " - Attempts : " .. tries,0,17,"top")
	accuracy = (100 * score / tries)
	if tries ~= 0 then
		gc:drawString(" Accuracy : " .. math.floor(accuracy+0.5) .. "%",0,33,"top")
	end
	
	if tries > 0 then
		local tmpstr = "X values: " .. tostring(mass) .. " * " .. tostring(power) .. " * " .. tostring(math.ceil(1000*cosangle)/1000) .. " / " .. tostring(kx) .. " * ( exp(t*" .. tostring(kx) .. "/" .. tostring(mass) .. ") - 1 )"
		--gc:drawString(tmpstr,pww() - gc:getStringWidth(tmpstr),pwh()-26,"bottom")
	end
		
	if timeattack then
		gc:setColorRGB(255,0,0)
		tmpstr = " Time Left : " .. timeleft .. "s."
		gc:drawString(tmpstr,pww()-gc:getStringWidth(tmpstr)-1,0,"top")
		gc:setColorRGB(0,0,0)
	end

	kxp = math.floor(kx*200) -- converts the wind values into %
	kyp = math.floor(ky*200) -- same

	gc:setColorRGB(0,0,0)
	gc:drawLine(posxmin,hauteur,posxmax-2,hauteur) -- tracé du panier (horiz)
	gc:drawLine(posxmax-2,hauteur-10,posxmax-2,hauteur+35) -- tracé du panier (vertical)
	gc:drawLine(posxmax-3,hauteur-10,posxmax-3,hauteur+35)

	gc:drawLine(posxmin,hauteur,posxmin+4,hauteur+9)
	gc:drawLine(posxmax-4,hauteur,posxmax-8,hauteur+9)
	gc:drawLine(posxmax-22,hauteur,posxmax-20,hauteur+9)
	gc:drawLine(posxmax-16,hauteur,posxmax-16,hauteur+9)
	gc:drawLine(posxmax-9,hauteur,posxmax-13,hauteur+9)

	gc:drawLine(posxmin+2,hauteur+3,posxmax-6,hauteur+3)
	gc:drawLine(posxmin+3,hauteur+6,posxmax-7,hauteur+6)
	gc:drawLine(posxmin+4,hauteur+9,posxmax-8,hauteur+9)

	str = "Angle = " .. math.floor(angle*180/pi+0.1) .. "°  /  Power = " .. power .. " "	
	gc:drawString(str,pww() - gc:getStringWidth(str),pwh(),"bottom")
	
	if (hardcoreMode and win == false) then
	
		if (math.random(1,2)>1) then
			tmpsignx = 1
		else
			tmpsignx = -1
		end
		if (math.random(1,2)>1) then
			tmpsigny = 1
		else
			tmpsigny = -1
		end			
		if (kx > 0.4) then tmpsignx = -1 end
		if (kx < -0.4) then tmpsignx = 1 end
		if (ky > 0.4) then tmpsigny = -1 end
		if (ky < -0.4) then tmpsigny = 1 end

		if (math.random(0,10) > 9) then
		kx = kx + tmpsignx*math.random(0,3)*0.01
		end
		if (math.random(0,10) > 9) then
		ky = ky + tmpsigny*math.random(0,3)*0.01
		end
	
		str2 = "Wind : x=" .. kxp .. "%  y=" .. kyp .. "% "
	
		gc:drawString(str2,pww() - 	gc:getStringWidth(str2),pwh()-14,"bottom")
		moveBasket(gc)
				
	end

	if mustGo then
		for j=1,valtmp do
			drawPoint(tablex[j],pwh()-tabley[j])
			
			if j%2 == 0 then
			gc:drawImage(theballImage,tablex[valtmp]-4,pwh()-tabley[valtmp]-1)
			--gc:setColorRGB(255,255,255)
			--gc:drawRect(0,0, pww(), pwh())
			gc:setColorRGB(0,0,0)
			end
			isRunning = true
			if (math.abs(pwh()-tabley[j]-hauteur)<10 and (tablex[j]>285) and win == false) then
				needScore = true ; win = true
			end
		end
	end
	
	refresh()
end

function moveBasket()
	hauteur = hauteur - 1 + 2*test(goingup)
	if (hauteur < 45) then
		hauteur = 45
		goingup = not(goingup)
	end
	if (hauteur > 135) then
		hauteur = 135
		goingup = not(goingup)
	end
	refresh()
end

function on.timer()

	timer.stop()
	
	if (hardcoreMode and win == false and alwaysMove) then
	moveBasket()
	end
	
	if timeattack then
		timeleft = 60-math.floor((math.abs(timer.getMilliSecCounter()) - math.abs(starTime))*0.001)
		if math.abs(math.floor(timeleft)) == 0 then gameover = true end
		refresh()
	end
	
	if valtmp < table.getn(tablex)-1 then
	valtmp = valtmp + 5
	end
	if valtmp > table.getn(tablex)-2 then
		isRunning = false
		mustGo = false
	else
	refresh()
	end
end

function on.charIn(ch)
	if (needMenu == true) then
		if ch == "1" then
		hardcoreMode = false
		kx = 0.00001
		ky = 0.00001
		needMenu = false
		refresh()
		end
		if ch == "2" then
		hardcoreMode = true
		needMenu = false
		refresh()
		end
		if ch == "3" then
		hardcoreMode = false
		timeattack = true
		kx = 0.00001
		ky = 0.00001
		needMenu = false
		starTime = timer.getMilliSecCounter()
		refresh()
		end
		if ch == "4" then
		hardcoreMode = true
		timeattack = true
		kx = 0.00001
		ky = 0.00001
		needMenu = false
		starTime = timer.getMilliSecCounter()
		refresh()
		end
	end
	if ch == "m" then
		alwaysMove = not(alwaysMove)
		refresh()
	end
end

function on.arrowKey(key)
	if win then
		hauteur = math.random(45,135)
	end

	win = false	
	if (isRunning == false) then

	valtmp = 1
	mustGo = false
	
if not(gameover) then
	
	if (angle > 0 and angle < 1.57) then
		if (key == "left") then
			angle = angle+pi/180
		elseif (key == "right") then
			angle = angle-pi/180
		end
	end
	
	if (power > 0 and power < 101) then
		if (key == "up") then
			power = power+1
			if power > 100 then power = 100 end
		elseif (key == "down") then
			power = power-1
			if power < 1 then power = 1 end
		end
	end	
	
	refresh()
end
	
	end --isRunning
end

function on.enterKey()
if not(gameover) then
	if (win == false) then
	if (isRunning == false) then
		win = false
		mustGo = true
		go(power,angle)
	end
	else 
		if (score > 0 and needScore) then score = score - 1 end -- dirty bug fix
	end
end
end

function on.escapeKey()
	isRunning = false
	mustGo = false
	needMenu = true
	refresh()
end

function go(power,angle)
	tries = tries + 1
	j=1
	valtmp=1
	refresh()
	cosangle = math.cos(angle)
	tanangle = math.tan(angle)
	powcosangle = power*cosangle
	powsinangle = power*math.sin(angle)
	mgsurky = mass * cstGrav / ky
	tablex = {0}
	tabley = {0}
	local t,maximum
	tmax = mass/kx*math.log(1+kx*312/(mass*powcosangle))
	maximum = 80
	
	for i=1,maximum do
		t = i*tmax/maximum
		tablex[i] = mass*powcosangle/kx*(math.exp(kx/mass*t)-1)
		tabley[i] = mgsurky*t + mass/ky*(powsinangle-mgsurky)*(math.exp(t*(ky/mass))-1)

		if (tabley[i] < 0 or tablex[i] ~= tablex[i]) then break end  --  (x ~= x) is a test for NaN
	end
		
	var.store("tablex",tablex)
	var.store("tabley",tabley)
	
	refresh()
end

function menu(gc)
	win = false
	gameover = false
	timeattack = false
	
	score = 0
	tries = 0

	local xmax,ymax

	xmax = pww()
	ymax = pwh()
	
	gc:setColorRGB(0,0,0)
	gc:fillRect(xmax/5, ymax/5,3*xmax/5,3*ymax/5)
	
	gc:setColorRGB(200,200,200)
	gc:fillRect(xmax/5+1, ymax/5+1,3*xmax/5-2,3*ymax/5-2)
	
	gc:setColorRGB(0,0,0)
	gc:drawString("Choose  Mode : ",xmax*0.5-46,48,"top")
		
	makeButton(gc,"1.  Normal",xmax*0.5,88)
	makeButton(gc,"2.  Hardcore",xmax*0.5,115)
	makeButton(gc,"3.  Time-Attack",xmax*0.5,142)
	
	gc:setColorRGB(100,100,100)
	tmpstr = "Arrows to adjust angle/power -  Enter to Shoot"
	gc:drawString(tmpstr,0.5*(pww()-gc:getStringWidth(tmpstr)),190,"top")

	tmpstr2 = "Esc to go to this Menu"
	gc:drawString(tmpstr2,0.5*(pww()-gc:getStringWidth(tmpstr2)),175,"top")
	
end

function on.help()
	needMenu = true
	refresh()
end

function makeButton(gc,string,x,y)
	gc:setColorRGB(150,150,150)
	drawRoundRect(x,y,140,20,5)
	gc:setColorRGB(50,50,50)
	fillRoundRect(x,y,139,18,5)
	gc:setColorRGB(255,255,255)
	gc:drawString(string,x-gc:getStringWidth(string)*0.5,y-12,"top")
end


ballImage = "\020\000\000\000\016\000\000\000\000\000\000\000\040\000\000\000\016\000\001\000wwwwwwwwwwwwwwk\238k\238\131\156\131\156k\238k\238wwwwwwwwwwwwwwwwwwwwwwwwk\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238wwwwwwwwwwwwwwwwwwk\238k\238k\238k\238\131\156\131\156\131\156k\238k\238k\238k\238k\238wwwwwwwwwwwwwwww\196\160\196\160k\238k\238\131\156\131\156k\238k\238k\238\228\164\228\164\196\160wwwwwwwwwwwwww\196\160\196\160\196\160\196\160\196\160\131\156\131\156\196\160\228\164\196\160\196\160\196\160\196\160\196\160wwwwwwwwwwwwk\238\196\160\196\160\196\160\196\160\131\156\131\156\196\160\196\160\196\160\196\160\196\160\196\160k\238wwwwwwwwwwk\238k\238k\238\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160k\238k\238k\238wwwwwwwwk\238k\238k\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238k\238k\238k\238k\238wwwwwwwwk\238k\238k\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238k\238k\238k\238k\238wwwwwwwwk\238k\238k\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238k\238k\238k\238k\238wwwwwwwwwwk\238\163\156\163\156\196\160\196\160\196\160\196\160\196\160\196\160\196\160\163\156\163\156k\238k\238wwwwwwwwwwww\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160\196\160\163\156\163\156\163\156\163\156wwwwwwwwwwwwww\196\160\196\160\163\156k\238\131\156\131\156k\238k\238\196\160\196\160\196\160\196\160wwwwwwwwwwwwwwwwk\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238k\238k\238wwwwwwwwwwwwwwwwwwk\238k\238k\238k\238\131\156\131\156k\238k\238k\238k\238wwwwwwwwwwwwwwwwwwwwwwwwk\238k\238\131\156\131\156k\238k\238wwwwwwwwwwwwww"

guyImage = "\022\000\000\000\052\000\000\000\000\000\000\000\044\000\000\000\016\000\001\000wwwwwwwwZ\235R\202\140\177k\173\016\194wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\016\194!\132\000\128\000\128*\165\247\222wwwwwwww\198\152\230\160wwwwwwwwwwwwwwwwwwww\008\161!\132\034\136B\136B\136\239\189Z\235wwwwww\008\161\165\148B\140wwwwwwwwwwwwwwww\156\243)\165!\132\034\132\034\132\166\148\181\214wwwwwwwwk\173\165\148\000\128c\140wwwwwwwwwwwwwwww\239\189B\136\034\132\034\132)\165\206\185wwwwww\239\189\008\161\000\128\000\128\165\148wwwwwwwwwwwwwwww\173\181B\136\034\132\034\136\132\144K\169\239\1891\1981\198)\165!\132\001\128!\132\199\152wwwwwwwwwwwwww\206\185c\140!\132C\136B\136B\136B\136c\140\140\1771\198\132\144\000\128\034\132B\136J\169wwwwwwwwwwwwww\140\177!\132B\136C\136B\136B\136B\136B\136C\136B\136\034\132B\136\034\136\133\144s\206wwwwwwwwwwwwwwJ\169\034\136B\136B\136B\136B\136B\136B\136\034\136\034\132C\140C\136\000\128\132\144<\231wwwwwwwwwwwwwwJ\169!\132\034\132B\136B\136B\136B\136B\136B\136B\136B\136!\132B\136\173\181wwwwwwwwwwwwwwww\173\181!\132\034\136B\136B\136B\136B\136B\136B\136\132\144B\136\034\136\008\161\173\181wwwwwwwwwwwwwwww\173\181!\132B\136B\136B\136B\136B\136\034\136C\136C\136\034\132k\1739\231wwwwwwwwwwwwwwwwww\016\194c\140\034\132B\136B\136B\136B\136B\136\034\132\132\144\239\189{\239wwwwwwwwwwwwwwwwwwww9\231\231\156!\132B\136C\136B\136B\136\034\132!\132k\173wwwwwwwwwwwwwwwwwwwwwwwwwwk\173!\132\034\132B\136B\136B\136\034\132\199\156\148\210wwwwwwwwwwwwwwwwwwwwwwwwwwk\173!\132\034\132B\136B\136\034\132B\136\206\185wwwwwwwwwwwwwwwwwwwwwwwwwwww\207\185c\140\034\132C\136B\136\034\132B\136\173\181\247\222wwwwwwwwwwwwwwwwwwwwwwwwwws\206\199\156\034\132B\136B\136B\136!\132\231\156\173\181wwwwwwwwwwwwwwwwwwwwwwwwwwwwk\173B\136\034\132B\136C\136\001\128\132\144\140\177wwwwwwwwwwwwwwwwwwwwwwwwwwww\173\181\034\132\034\132B\136B\136\001\132C\136s\206wwwwwwwwwwwwwwwwwwwwwwwwww{\239)\165!\132B\136B\136B\136B\136!\132*\165\247\222wwwwwwwwwwwwwwwwwwwwwwww\140\177C\136\034\132C\136B\136B\136B\136\034\136\000\128\198\152\181\214wwwwwwwwwwwwwwwwwwwwww)\165\034\132\034\132C\136B\136B\136B\136B\136\034\136\000\128\165\148\215\218wwwwwwwwwwwwwwwwwwww\008\161B\136\034\132B\136B\136B\136C\136B\136B\136B\136\000\128\165\148\024\227wwwwwwwwwwwwwwwwww)\165\034\136\034\132C\136B\136B\136B\136B\136C\136C\136B\136\001\128\198\152Z\235wwwwwwwwwwwwwwwwk\173B\136\034\136B\136\034\136C\136B\136B\136\034\136\034\136B\136B\136\001\128\165\148wwwwwwwwwwwwwwww\016\194d\140!\132B\136C\136B\136B\136C\136B\136B\136B\136B\136B\136B\136\207\185wwwwwwwwwwwwwwwwJ\169!\132\034\136B\136C\136C\136C\136B\136B\136C\136B\136B\136\034\132\132\144\025\227wwwwwwwwwwwwww\016\194c\140\034\132B\136\034\136C\136B\136!\132!\132!\132B\136C\140B\136!\132\132\144\156\243wwwwwwwwwwwwZ\235\232\160!\132B\136B\136\034\132C\140\133\148c\140\001\132\000\128!\132c\140B\136\034\132J\169wwwwwwwwwwwwww\206\185c\140\034\132C\140\034\136\034\136J\169wwwwk\173\000\128\001\128C\136\034\132B\136\206\185wwwwwwwwwwww\156\243\231\156\001\128B\136\034\136!\132l\177wwww\214\2182\198B\136\034\132B\136!\132)\165wwwwwwwwwwwwww\148\210\199\152B\136!\132!\132\206\185wwwwwwww1\198\001\128B\136!\132\008\161wwwwwwwwwwwwww\181\214)\165c\140!\132!\132\173\181wwwwww\174\181K\173\000\128B\136B\136\173\181wwwwwwwwwwwwwwww\024\227\232\156\000\128!\132\173\181wwwwww\017\194\034\132!\132B\136\132\1449\231wwwwwwwwwwwwwwww{\239\199\152\000\128!\132\172\181wwwwww\148\210\001\128B\136!\132\231\156wwwwwwwwwwwwwwww\016\194\198\152C\136\000\128c\140s\206wwwwww1\198\001\128\034\136c\140\016\194wwwwwwwwwwwwww\016\194B\136!\132\000\128c\140J\169\148\210wwww\148\210\174\181\000\128B\136\132\144\148\210wwwwwwwwwwww\024\227\165\148!\132\000\128c\140k\173\206\185wwwwwwR\202l\177\000\128B\136\231\156wwwwwwwwwwwwwwl\173B\136\000\128\132\144\173\181\140\177wwwwwwww\016\194k\173\000\128c\140\247\222wwwwwwwwwwww\181\214\165\148\000\128\132\144\206\185wwwwwwwwwwww\174\181J\169\000\128\008\161wwwwwwwwwwww\174\181\231\156\000\128\132\144\240\189wwwwwwwwwwwwww1\198\165\148B\136\214\218wwwwwwwwJ\169\132\144\009\161!\132\165\148R\202wwwwwwwwwwwwwwww\247\222!\132\198\152wwwwwwwws\206\165\148\132\144\000\128\165\148\214\218wwwwwwwwwwwwwwww\024\227\206\185B\1361\198wwwwwwww\165\148\000\128B\136\000\128\016\194\181\214wwwwwwwwwwwwww\016\194\173\181B\136\132\144wwwwwwwwww)\165!\132!\132B\136R\202\247\222wwwwwwwwwwwws\206\206\185\231\156\000\128\133\144Z\235wwwwwwwwk\173!\132!\132\239\189\214\218wwwwwwwwwwww\247\222\016\194\132\144\000\128\034\132C\136\173\181wwwwwwwwc\140\000\128\132\144:\231wwwwwwwwwwwwww\247\222J\169\000\128\034\132C\136\034\132\232\156wwwwwwww\001\132\001\128\165\148\181\214wwwwwwwwwwwwww\247\222R\202\198\152B\136!\132\034\132d\144\214\218wwwwwwc\140\000\128\198\152\198\152wwwwwwwwwwwwwwwwww\016\194s\206\165\148\000\128!\132\165\1489\231wwwwR\202B\136\231\156)\165wwwwwwwwwwwwwwwwwwwwww9\231\231\156!\132!\132\008\161wwwwww1\198\148\210\181\214wwwwwwwwwwwwwwwwwwwwwwwwww\148\210\231\156\198\152wwww"

theballImage = image.new(ballImage)
theguyImage = image.new(guyImage)

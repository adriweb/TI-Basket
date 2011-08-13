-----------------
--- TI-Basket ---
---- Adriweb ----
-----------------
-- Contact : adrienbertrand@msn.com
-----------------
-- Version 2.1 --
-----------------




 function on.paint(gc)
     gc:setColorRGB(0,0,0)
     gc:setFont("serif","r",9)
     tab = wrap(gc,regeqn)    
     local tmpstr = "Equ :"
     for i,v in pairs(tab) do
        gc:drawString(tmpstr .. v,0,12*(i-1),"top")
        tmpstr = "  "
     end 
     tab = {} 
     --gc:drawString("Equ2 : " .. regeqn,0,40,"top")
 end                                   
 
 function on.create()
    tab = {}
    local a = check(roundstr(var.recall("stat.a"),9),"x" .. string.uchar(0x2074) .. " + ")
    local b = check(roundstr(var.recall("stat.b"),9),"x" .. string.uchar(0x00B3) .. " + ")
    local c = check(roundstr(var.recall("stat.c"),9),"x" .. string.uchar(0x00B2) .. " + ")
    local d = check(roundstr(var.recall("stat.d"),9),"x + ")
    local e = check(roundstr(var.recall("stat.e"),9),"")
    regeqn = a .. b .. c .. d .. e
    var.monitor("stat.a")
end
 
 function on.varChange(list)
    local a = check(roundstr(var.recall("stat.a"),9),"x" .. string.uchar(0x2074) .. " + ")
    local b = check(roundstr(var.recall("stat.b"),9),"x" .. string.uchar(0x00B3) .. " + ")
    local c = check(roundstr(var.recall("stat.c"),9),"x" .. string.uchar(0x00B2) .. " + ")
    local d = check(roundstr(var.recall("stat.d"),9),"x + ")
    local e = check(roundstr(var.recall("stat.e"),9),"")
    regeqn = a .. b .. c .. d .. e
    return 0
 end    
 
function check(str1,str2)
    if str1:len()>0 then
	    return (str1 .. str2)
	else 
	    return ""
	end
end


function roundstr(num, idp)
 	local res = string.format("%." .. (idp or 0) .. "e", num)
 	if tonumber(res)==0 then res = "" end
   return res
end

function wrap(gc,str)
   local length1 = gc:getStringWidth(str)
   local length2 = str:len()
   local width = platform.window:width() 
   local condition = (length1 > width)
   if not condition then tab = {str} else
       tab = {}
       local newlen = length2
       while gc:getStringWidth(str:sub(1,newlen)) > width do
          newlen = newlen - 3
       end
       table.insert(tab,str:sub(1,newlen))
       table.insert(tab,str:sub(newlen))
   end
   return tab 
end
    
    
    
    

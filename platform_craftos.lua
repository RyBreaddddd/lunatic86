local keysDown = {}
local lastKey = nil

<<<<<<< HEAD
function platform_event_loop()
    while true do
        local e = {os.pullEvent()}
        if e[1] == "key" then 
            keysDown[e[2]] = true
            lastKey = e[2]
        elseif e[1] == "char" then
            lastKey = e[2]
        elseif e[1] == "key_up" then
            keysDown[e[2]] = nil
            lastKey = nil
        end
    end
end

function platform_sleep(t)
	-- for what pvrpose
=======
band = {}
bor = {}
bxor = {}
bnot = {}
blshift = {}
brshift = {}

setmetatable(band, {__sub = function(lhs)
    local mt = {lhs, __sub = function(self, b) return bit.band(self[1], b) end}
    return setmetatable(mt, mt)
end})

setmetatable(bor, {__sub = function(lhs)
    local mt = {lhs, __sub = function(self, b) return bit.bor(self[1], b) end}
    return setmetatable(mt, mt)
end})

setmetatable(bxor, {__sub = function(lhs)
    local mt = {lhs, __sub = function(self, b) return bit.bxor(self[1], b) end}
    return setmetatable(mt, mt)
end})

setmetatable(blshift, {__sub = function(lhs)
    local mt = {lhs, __sub = function(self, b) return bit.blshift(self[1], b) end}
    return setmetatable(mt, mt)
end})

setmetatable(brshift, {__sub = function(lhs)
    local mt = {lhs, __sub = function(self, b) return bit.blogic_rshift(self[1], b) end}
    return setmetatable(mt, mt)
end})

setmetatable(bnot, {__sub = function(_, rhs) return bit.bnot(rhs) end})

io_seek = {open = function(_sPath, _sMode)

    if _G.type( _sPath ) ~= "string" then
        error( "bad argument #1 (expected string, got " .. _G.type( _sPath ) .. ")", 2 )
    end
    if _sMode ~= nil and _G.type( _sMode ) ~= "string" then
        error( "bad argument #2 (expected string, got " .. _G.type( _sMode ) .. ")", 2 )
    end
	local sMode = _sMode or "r"
	local file, err = fs.open( _sPath, sMode )
	if not file then
		return nil, err
	end
	
	if sMode == "r"then
		return {
			bFileHandle = true,
            bClosed = false,		
            pos = 0,		
			close = function( self )
				file.close()
				self.bClosed = true
			end,
			read = function( self, _sFormat )
                local sFormat = _sFormat or "*l"
				if sFormat == "*l" then
                    local r = file.readLine()
                    self.pos = self.pos + string.len(r)
                    return r
				elseif sFormat == "*a" then
                    local r = file.readAll()
                    self.pos = self.pos + string.len(r)
                    return r
                elseif _G.type( sFormat ) == "number" then
                    self.pos = self.pos + sFormat
                    return file.read( sFormat )
				else
					error( "Unsupported format", 2 )
				end
				return nil
			end,
			lines = function( self )
				return function()
					local sLine = file.readLine()
					if sLine == nil then
						file.close()
						self.bClosed = true
                    end
                    self.pos = self.pos + string.len(sLine)
					return sLine
				end
            end,
            seek = function(self, whence, offset)
                whence = whence or "cur"
                offset = offset or 0
                if whence == "set" then
                    if offset < self.pos then
                        file.close()
                        file = fs.open(_sPath, sMode)
                        self.pos = 0
                    end
                    while self.pos < offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                elseif whence == "cur" then
                    local lastoff = self.pos
                    if lastoff + offset < self.pos then
                        file.close()
                        file = fs.open(_sPath, sMode)
                        self.pos = 0
                    end
                    while self.pos < lastoff + offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                elseif whence == "end" then
                    file.close()
                    file = fs.open(_sPath, "r")
                    local sz = 0
                    while file.read() ~= nil do sz = sz + 1 end
                    file.close()
                    file = fs.open(_sPath, sMode)
                    self.pos = 0
                    while self.pos < sz + offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                end
                return self.pos
            end
		}
	elseif sMode == "w" or sMode == "a" then
		return {
			bFileHandle = true,
			bClosed = false,				
			close = function( self )
				file.close()
				self.bClosed = true
			end,
			write = function( self, ... )
                local nLimit = select("#", ... )
                for n = 1, nLimit do
				    file.write( select( n, ... ) )
                end
			end,
			flush = function( self )
				file.flush()
			end,
		}
	
	elseif sMode == "rb" then
		return {
			bFileHandle = true,
			bClosed = false,				
			close = function( self )
				file.close()
				self.bClosed = true
			end,
            read = function( self, c )
                if c then
                    local retval = ""
                    local oldpos = self.pos
                    while self.pos < oldpos + c do
                        retval = retval .. string.char(file.read())
                        self.pos = self.pos + 1
                    end
                    return retval
                else
                    self.pos = self.pos + 1
                    return file.read()
                end
            end,
            seek = function(self, whence, offset)
                whence = whence or "cur"
                offset = offset or 0
                if whence == "set" then
                    if offset < self.pos then
                        file.close()
                        file = fs.open(_sPath, sMode)
                        self.pos = 0
                    end
                    while self.pos < offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                elseif whence == "cur" then
                    local lastoff = self.pos
                    if lastoff + offset < self.pos then
                        file.close()
                        file = fs.open(_sPath, sMode)
                        self.pos = 0
                    end
                    while self.pos < lastoff + offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                elseif whence == "end" then
                    file.close()
                    file = fs.open(_sPath, "rb")
                    local sz = 0
                    while file.read() ~= nil do sz = sz + 1 end
                    file.close()
                    file = fs.open(_sPath, sMode)
                    self.pos = 0
                    while self.pos < sz + offset do
                        file.read()
                        self.pos = self.pos + 1
                    end
                end
                return self.pos
            end
		}
		
	elseif sMode == "wb" or sMode == "ab" then
		return {
			bFileHandle = true,
			bClosed = false,				
			close = function( self )
				file.close()
				self.bClosed = true
			end,
			write = function( self, ... )
                local nLimit = select("#", ... )
                for n = 1, nLimit do
				    file.write( select( n, ... ) )
                end
			end,
			flush = function( self )
				file.flush()
			end,
		}
	
	else
		file.close()
		error( "Unsupported mode", 2 )
		
    end
end}

function platform_sleep(t)
    -- for what pvrpose
    --platform_kbd_tick()
>>>>>>> parent of 202f250 (Fixed some things)
	os.sleep(t)
end

function platform_beep(freq)
	-- do nothing
end

function platform_key_down(v)
	return keysDown[v]
end

function emu_debug(level, s, tb)
	--[[if level >= 1 then
		io.stderr:write(s .. "\n")
		if tb then debug.traceback() end
		io.stderr:flush()
	end]]
end

local queued_up = {}

-- non-blocking, returns (ascii char, bios scan code) or nil on none
function platform_getc()
<<<<<<< HEAD
	local c = lastKey
	if type(c) == "string" then c = string.byte() end
	if c == 263 then c = 8 end
	emu_debug(2, string.format("getc %d", c))
	if c then
		if c >= 0 and c < 128 then return c,c
		else return 0,c end
	end
=======
    os.queueEvent("noblock")
    local ev, c = os.pullEvent()
    if ev == "key" then
        if c >= 0x80 then return nil end
        emu_debug(2, string.format("key %d %d", c, keys_to_char[c] or 0))
        last_key = c
        if keys_to_char[c] then return keys_to_char[c], c else return -1 end
    elseif ev == "char" then
        emu_debug(2, string.format("char %s %d", c, string.byte(c)))
        return string.byte(c), last_key
    elseif ev == "key_up" then
        last_key = nil
    end
    if ev ~= "noblock" then return -1 end
>>>>>>> parent of 202f250 (Fixed some things)
	return nil
end

function platform_error(msg)
<<<<<<< HEAD
    term.setGraphicsMode(false)
	error(msg, 2)
=======
    platform_finish()
    term.clear()
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.red)
    CCLog.default:traceback("lunatic86", msg)
    CCLog.default:close()
    error(msg, 2)
end

function platform_kbd_tick()
    local getmore = true
    while getmore do
		local ch, code = platform_getc()
		if ch ~= nil and ch ~= -1 then
			kbd_send_ibm(code, ch)
        elseif ch ~= -1 then getmore = false end
	end
>>>>>>> parent of 202f250 (Fixed some things)
end

function platform_render_cga_mono(vram, addr)
	os.queueEvent("noblock")
    os.pullEvent()
    --term.setGraphicsMode(true)
end

function platform_render_mcga_13h(vram, addr)
	os.queueEvent("noblock")
    os.pullEvent()
    --term.setGraphicsMode(true)
end

function platform_render_pcjr_160(vram, addr)
	os.queueEvent("noblock")
    os.pullEvent()
    --term.setGraphicsMode(true)
end

function platform_render_pcjr_320(vram, addr)
	os.queueEvent("noblock")
    os.pullEvent()
    --term.setGraphicsMode(true)
end

function platform_render_text(vram, addr, width, height, pitch)
	os.queueEvent("noblock")
	os.pullEvent()
    term.setGraphicsMode(false)
	local dlines = video_pop_dirty_lines()
	for y,v in pairs(dlines) do
		local base = addr + (y * pitch)
		for x=0,width-1 do
			local chr = vram[base + x*2] or 0
            local atr = vram[base + x*2 + 1] or 0
            local fg = bit.band(atr, 0x0F)
            local bg = bit.brshift(atr, 4)
            term.setCursorPos(x+1, y+1)
            term.blit(string.char(chr), string.sub("0123456789abcdef", fg+1, fg+1), string.sub("0123456789abcdef", bg+1, bg+1))
		end
	end
end

function platform_finish()
    term.setGraphicsMode(false)
    term.clear()
    term.setCursorPos(1, 1)
end

<<<<<<< HEAD
dofile("emu_core.lua")
=======
dofile(pwd .. "emu_core.lua")
>>>>>>> parent of 202f250 (Fixed some things)

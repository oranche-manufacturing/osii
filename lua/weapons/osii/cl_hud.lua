
function SWEP:DrawHUD()
end

local col_a = Color(127, 255, 255, 255)
local col_s = Color(0, 0, 0, 127)
local s_dist = 2

local ssss = ScreenScale(1)

surface.CreateFont("OSII_HUD_NumBig", {
	font = "Nirmala UI",
	size = 40*ssss
})
surface.CreateFont("OSII_HUD_NumSmall", {
	font = "Nirmala UI",
	size = 20*ssss
})

surface.CreateFont("OSII_HUD_TextSmall", {
	font = "Nirmala UI",
	size = 15*ssss
})

local function MyDrawText(tbl)
	local x = tbl.x
	local y = tbl.y
	surface.SetFont(tbl.font)

	if tbl.a_x or tbl.a_y then
		local w, h = surface.GetTextSize(tbl.text)
		if tbl.a_x then
			x = x - (w * tbl.a_x)
		end
		if tbl.a_y then
			y = y - (h * tbl.a_y)
		end
	end

	if tbl.shadow then
		surface.SetTextColor(Color(0, 0, 0, 127))
		surface.SetTextPos(x + tbl.shadow, y + tbl.shadow)
		surface.SetFont(tbl.font)
		surface.DrawText(tbl.text)
	end

	surface.SetTextColor(tbl.col)
	surface.SetTextPos(x, y)
	surface.SetFont(tbl.font)
	surface.DrawText(tbl.text)
end

function SWEP:DrawHUD()
    do return end
	local x1, y1 = 0, 0
	local x2, y2 = ScrW(), ScrH()
	local p = LocalPlayer()
	local w = p:GetActiveWeapon()
	local tobl = {
		x = x1 + (x2*0.75),
		y = y1 + (y2*0.9),
		text = w:Clip1(),
		font = "OSII_HUD_NumBig",
		col = Color(255, 255, 255),
		a_x = 0.5,
		a_y = 0.5,
		shadow = ssss*2
	}
	MyDrawText(tobl)

	tobl.text = w:Ammo1()
	tobl.font = "OSII_HUD_NumSmall"
	tobl.y = y1 + (y2*0.96)
	tobl.shadow = ssss*1.5
	MyDrawText(tobl)

	tobl.text = "AMMO"
	tobl.font = "OSII_HUD_TextSmall"
	tobl.y = y1 + (y2*0.85)
	tobl.shadow = ssss*1
	MyDrawText(tobl)
end

function SWEP:DoDrawCrosshair()
	local w = self
	local p = w:GetOwner()
	local x2, y2 = ScrW()/2, ScrH()/2
	local x, y = x2, y2

	local ss = ScreenScale(5)
	local gap = ss*1

	local spread = self.Stats["Bullet"]["Spread"]
	if istable(spread) then
		spread = Lerp( self:GetAccelInaccuracy(), spread.min, spread.max )
	end
	gap = ss*spread

	cam.Start3D()
		local lool = ( EyePos() + ( EyeAngles() + Angle(spread, 0, 0) ):Forward() ):ToScreen()
	cam.End3D()
	gap = (ScrH()/2) - lool.y

	local shad = 4
	local len, wid = 3, 2
	surface.SetDrawColor(col_s)
	for i=1, 2 do
		if i == 2 then
			surface.SetDrawColor(col_a)
			x, y = x2, y2
		else
			x, y = x+s_dist, y+s_dist
		end
		-- right
		surface.DrawRect(x + gap, y - (wid/2), len, wid)

		-- left
		surface.DrawRect(x - gap - len, y - (wid/2), len, wid)

		-- top
		surface.DrawRect(x - (wid/2), y + gap, wid, len)

		-- bottom
		surface.DrawRect(x - (wid/2), y - gap - len, wid, len)

		-- cent
		surface.DrawRect(x - (wid/2), y - (wid/2), wid, wid)
	end

	
	-- top
	local cl = self:Clip1()

	len = 44*1
	wid = 4
	local dist = ss*6

	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(x + (wid/2) - (ss*6), y + len/2 + ss*8)
	surface.SetFont("DermaDefault")
	surface.DrawText("Heat, firerate | Capacity, battery")
	
	do	-- Mag
		dist = ss*6
		prog = (cl/self.Stats["Magazines"]["Maximum loaded"])
		if prog == 0 then
			local soos = math.sin( CurTime() * math.pi / 0.5 )
			if soos > 0 then
				surface.SetDrawColor(127, 0, 0, 127)
			else
				surface.SetDrawColor(col_s)
			end
		else
			surface.SetDrawColor(col_s)
		end
		surface.DrawRect(x - (wid/2) + 16 + dist + s_dist, y - (len/2) + (len - (len*1)) + s_dist, wid, len * 1)

		if prog >= (2/3) then
			surface.SetDrawColor(127, 255, 127, 255)
		elseif prog >= (1/3) then
			surface.SetDrawColor(255, 255, 127, 255)
		elseif prog >= (0/3) then
			surface.SetDrawColor(255, 127, 127, 255)
		end
		surface.DrawRect(x - (wid/2) + 16 + dist, y - (len/2) + (len - (len*prog)), wid, len * prog)
	end
	
	do	-- Battery
		dist = ss*7
		prog = 1-self:GetBattery()
		if prog == 0 then
			local soos = math.sin( CurTime() * math.pi / 0.5 )
			if soos > 0 then
				surface.SetDrawColor(127, 0, 0, 127)
			else
				surface.SetDrawColor(col_s)
			end
			surface.SetFont("DermaDefault")
			surface.SetTextColor(color_white)
			surface.SetTextPos(x + 16 + dist - (wid/2), y + (len/2))
			surface.DrawText("Battery depleted!")
		else
			surface.SetDrawColor(col_s)
		end
		surface.DrawRect(x - (wid/2) + 16 + dist + s_dist, y - (len/2) + (len - (len*1)) + s_dist, wid, len * 1)

		if prog >= (2/3) then
			surface.SetDrawColor(255, 255, 127, 255)
		elseif prog >= (1/3) then
			surface.SetDrawColor(255, 127 + 64, 127, 255)
		elseif prog >= (0/3) then
			surface.SetDrawColor(255, 63 + 32, 63 + 32, 255)
		end
		surface.DrawRect(x - (wid/2) + 16 + dist, y - (len/2) + (len - (len*prog)), wid, len * prog)
	end

	do	-- Firerate
		dist = ss*6
		prog = self:GetAccelFirerate()
		if true then--if prog > 0 then
			if prog == 1 then
				local soos = math.sin( CurTime() * math.pi / 0.5 )
				if soos > 0 then
					surface.SetDrawColor(127, 0, 0, 127)
				else
					surface.SetDrawColor(col_s)
				end
			else
				surface.SetDrawColor(col_s)
			end
			surface.DrawRect(x - (wid/2) - 16 - dist + s_dist, y - (len/2) + (len - (len*1)) + s_dist, wid, len * 1)

			surface.SetDrawColor(Color(255, 55, 55))
			surface.DrawRect(x - (wid/2) - 16 - dist, y - (len/2) + (len - (len*prog)), wid, len * prog)
		end
	end

	do	-- Heat
		dist = ss*7
		prog = self:GetAccelHeat()
		if true then--if prog > 0 then
			if self:GetOverheated() then
				local soos = math.sin( CurTime() * math.pi / 0.5 )
				if soos > 0 then
					surface.SetDrawColor(127, 0, 0, 127)
				else
					surface.SetDrawColor(col_s)
				end
			else
				surface.SetDrawColor(col_s)
			end
			surface.DrawRect(x - (wid/2) - 16 - dist + s_dist, y - (len/2) + (len - (len*1)) + s_dist, wid, len * 1)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.DrawRect(x - (wid/2) - 16 - dist, y - (len/2) + (len - (len*prog)), wid, len * prog)
		end
	end

	return true
end
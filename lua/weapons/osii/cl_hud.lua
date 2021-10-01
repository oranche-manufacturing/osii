
function SWEP:DrawHUD()
end

local col_a = Color(127, 255, 255, 255)
local col_s = Color(0, 0, 0, 255)

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
			x, y = x+1, y+1
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

	len = 44
	wid = 3
	local dist = ss*6
	prog = (cl/self.Stats["Magazines"]["Maximum loaded"])
	wid = 4

	
	surface.SetDrawColor(col_s)
	surface.DrawRect(x - (wid/2) + 16 + dist + 1, y - (len/2) + (len - (len*1)) + 1, wid, len * 1)

	if prog >= (2/3) then
		surface.SetDrawColor(127, 255, 127, 255)
	elseif prog >= (1/3) then
		surface.SetDrawColor(255, 255, 127, 255)
	elseif prog >= (0/3) then
		surface.SetDrawColor(255, 127, 127, 255)
	end
	surface.DrawRect(x - (wid/2) + 16 + dist, y - (len/2) + (len - (len*prog)), wid, len * prog)

	prog = self:GetAccelFirerate()
	if prog > 0 then
		surface.SetDrawColor(col_s)
		surface.DrawRect(x - (wid/2) - 16 - dist + 1, y - (len/2) + (len - (len*1)) + 1, wid, len * 1)

		surface.SetDrawColor(Color(255, 55, 55))
		surface.DrawRect(x - (wid/2) - 16 - dist, y - (len/2) + (len - (len*prog)), wid, len * prog)
	end


	return true
end
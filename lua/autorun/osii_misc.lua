
-- basically stolen from ArcCW
hook.Add("SetupMove", "OSII_StartMove", function(ply, mv, cmd)
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().OSII then
		local w = ply:GetActiveWeapon()
		local s = 1
	
		local basespd = (Vector(cmd:GetForwardMove(), cmd:GetUpMove(), cmd:GetSideMove())):Length()
		basespd = math.min(basespd, mv:GetMaxClientSpeed())

		if basespd > 1 then
			w:Holster()
		end

		if IsValid(w:GetEmplacement()) then
			s = 0.001
		end

		mv:SetMaxSpeed(basespd * s)
		mv:SetMaxClientSpeed(basespd * s)
	end
end)
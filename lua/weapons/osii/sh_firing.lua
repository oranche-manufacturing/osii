
-- Firing

funks = {
	["Linear"] = function(i)
		return Lerp( i, 0, 1 )
	end,
	["Very Early"] = function(i)
		return Lerp( math.pow( math.sin( i * math.pi * 0.5 ), 0.5 ), 0, 1 )
	end,
	["Early"] = function(i)
		return Lerp( math.pow( math.sin( i * math.pi * 0.5 ), 1 ), 0, 1 )
	end,
	["Late"] = function(i)
		return Lerp( math.pow( math.sin( i * math.pi * 0.5 ), 2 ), 0, 1 )
	end,
	["Very Late"] = function(i)
		return Lerp( math.pow( math.sin( i * math.pi * 0.5 ), 3 ), 0, 1 )
	end,
	["Cosine"] = function(i)
		return Lerp( math.pow( math.cos( i * math.pi * 0.5 ), 1 ), 0, 1 )
	end,
	["Zero"] = function(i)
		return 0
	end,
	["One"] = function(i)
		return 1
	end,
}

function SWEP:PrimaryAttack(forced)
	local p = self:GetOwner()
	if self:GetFireDelay() > CurTime() then return false end
	if !forced and self:GetFireRecoveryDelay() > CurTime() then return false end
	if self:GetReloadDelay() > CurTime() then return false end
	
	if self.Stats["Function"]["Ammo required per shot"] > self:Clip1() then
		self:EmitSound( self.Stats["Appearance"]["Sounds"]["Dry"] )
		self:SetFireDelay( CurTime() + 0.2 )
		return false
	end

	if self:GetOverheated() then return end
	if self:GetBattery() >= 1 then return false end--if CLIENT then chat.AddText( string.FormattedTime(CurTime(), "[%i:%02i] ") .. "Battery depleted!") end self:SetFireDelay( CurTime() + 0.5 ) return false end

	if self.Stats["Function"]["Shots fired maximum"].max != 0 and
		self:GetBurstCount() >= self.Stats["Function"]["Shots fired maximum"].max then
		return false
	end

	-- Play shoot sound
	self:EmitSound( self.Stats["Appearance"]["Sounds"]["Fire"] )
	self:ShootBullet()

	local time = self.Stats["Function"]["Fire delay"]
	if istable(time) then
		time = Lerp( self:GetAccelFirerate(), time.min, time.max )
	end

	self:SetFireDelay( CurTime() + time )
	self:SetFireRecoveryDelay( CurTime() + self.Stats["Function"]["Fire recovery delay"] )
	self:SetBurstCount( self:GetBurstCount() + 1 )
	if self.Stats["Battery"] and self.Stats["Battery"]["Age per shot"] then
		self:SetBattery( math.Clamp(self:GetBattery() + self.Stats["Battery"]["Age per shot"], 0, 1) )
	end

	if self.qa["fire"] then self:SendAnim( self.qa["fire"] ) end

	self:SetClip1( math.max( self:Clip1() - self.Stats["Function"]["Ammo used per shot"], 0) )

	if p:IsPlayer() then
		local fun = funks["Linear"]
		local fuckly = 0

		if self.Stats["Recoil"] then
			local trolly = self.Stats["Recoil"]["Change per shot"]
			fun = funks[ self.Stats["Recoil"]["Function"] ]

			fuckly = Lerp( fun(self:GetAccelRecoil()), trolly.min, trolly.max )
		end

		p:SetEyeAngles( p:EyeAngles() + Angle( fuckly * (-1), 0, 0 ) )

		p.randv = VectorRand() * ( self.Stats["Appearance"]["Recoil mult"] or 1 )
	end	
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:ShootBullet()
	for i=1, self.Stats["Bullet"]["Count"] do
		local devi = Angle(0, 0, 0)

		local rnd = util.SharedRandom(CurTime()/11, 0, 360, i)
		local rnd2 = util.SharedRandom(CurTime()/22, 0, 1, i*2)

		local spread = self.Stats["Bullet"]["Spread"]
		if istable(spread) then
			spread = Lerp( self:GetAccelInaccuracy(), spread.min, spread.max )
		end
		local deviat = Angle( math.cos(rnd), math.sin(rnd), 0 ) * ( rnd2 * spread )
		
		local bullet = {}
		bullet.Num		= 1
		bullet.Attacker = self:GetOwner()
		bullet.Src		= self:GetOwner():GetShootPos()
		bullet.Dir		= ( self:GetOwner():EyeAngles() + deviat ):Forward()
		bullet.Spread	= vector_origin
		bullet.Tracer	= 0
		bullet.Force	= self.Stats["Bullet"]["Force"] or 1
		bullet.Damage	= 0
		bullet.AmmoType = self.Primary.Ammo
		bullet.Callback = function( atk, tr, dmg )
			local ent = tr.Entity

			dmg:SetDamage( self.Stats["Bullet"]["Damage"].max )
			dmg:SetDamageType(DMG_BULLET)

			-- ArcCW
			if IsValid(ent) then
				local d = dmg:GetDamage()
				local min, max = self.Stats["Bullet"]["Range"].min, self.Stats["Bullet"]["Range"].max
				local range = atk:GetPos():Distance(ent:GetPos())
				local XD = 0
				if range < min then
					XD = 0
				else
					XD = math.Clamp((range - min) / (max - min), 0, 1)
				end

				dmg:SetDamage( Lerp(XD, self.Stats["Bullet"]["Damage"].max, self.Stats["Bullet"]["Damage"].min) )

				if CLIENT and IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() then
					if GetConVar("osii_debug_dmgrange"):GetBool() then
						dmg:GetAttacker():ChatPrint( 100-math.Round(XD*100) .. "% range, " .. math.Round(dmg:GetDamage()) .. " dmg" )
					end
				end
			end
		end

		self:FireBullets( bullet )
	end
end
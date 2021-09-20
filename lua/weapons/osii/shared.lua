
--[[
	OSII
	made possible by:
	- 
	- 
	- 
]]

-- 1
SWEP.Spawnable				= false
SWEP.Base					= "weapon_base"
SWEP.PrintName				= "OSII Weapon Base"
SWEP.Category				= "OSII"
SWEP.Slot					= 0
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModel				= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands				= true

-- 3
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.m_WeaponDeploySpeed = 10

function Range( m, a )
	return { min = m, max = a }
end

-- 4
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= {
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 3, 10 ),
		["Range"]						= Range( 250, 1000 )
	},
	["Function"]	= {
		["Fire delay"]					= 0.1,
		["Fire recovery delay"]			= 0.2,
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 1, 1 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Pistol.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 15,
		["Maximum loaded"]				= 15,
		["Ammo type"]					= "pistol",
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle",
		},
		["fire"]	= {
			{
				seq = "fire_rand1",
				tpanim = tpa[2]
			},
			{
				seq = "fire_rand2",
				tpanim = tpa[2]
			},
			{
				seq = "fire_rand3",
				tpanim = tpa[2]
			},
		},
		["reload"]	= {
			seq = "reload",
			tpanim = tpa[1]
		},
		["draw"]	= {
			seq = "draw",
		},
	},
}

-- 5
function SWEP:Initialize()
	self:SetClip1( self.Stats["Magazines"]["Maximum loaded"] )
	self.Primary.Ammo = self.Stats["Magazines"]["Ammo type"]

	-- Quick for the animation table
	self.qa = self.Stats["Animation"]
end

function SWEP:OnReloaded()
	self.Primary.Ammo = self.Stats["Magazines"]["Ammo type"]
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "BurstCount")
	
	self:NetworkVar("Float", 1, "FireDelay")
	self:NetworkVar("Float", 2, "FireRecoveryDelay")
	self:NetworkVar("Float", 3, "ReloadDelay")
	self:NetworkVar("Float", 4, "ReloadLoadDelay")
	self:NetworkVar("Float", 5, "NextIdle")

	self:NetworkVar("Bool", 0, "ReloadingState")
end

function SWEP:Think()
	local p = self:GetOwner()

	if IsValid(p) then
		local maa = self.Stats["Function"]["Shots fired maximum"]
		if self:GetBurstCount() != 0 and maa.max != 0 and self:GetBurstCount() < maa.max then
			if self:Clip1() <= 0 then
				self:SetBurstCount(0)
			else
				self:PrimaryAttack(true)
			end
		end

		if self:GetBurstCount() >= self.Stats["Function"]["Shots fired maximum"].min and !p:KeyDown(IN_ATTACK) then
			self:SetBurstCount( 0 )
		end

		if self:GetNextIdle() <= CurTime() then
			self:SendAnim(self.qa["idle"])
		end

		if self:GetReloadLoadDelay() != 0 and self:GetReloadLoadDelay() <= CurTime() then
			self:SetReloadLoadDelay(0)
			self:Load()
		end
			
		if self:GetReloadingState() and self:Clip1() > 0 and ( p:KeyDown(IN_ATTACK) or p:KeyDown(IN_ATTACK2) ) then
			self:FinishReload()
		end

		if self:GetReloadingState() and self:GetReloadDelay() < CurTime() then
			if self:Clip1() < self.Stats["Magazines"]["Maximum loaded"] then
				self:InsertReload()
			else
				self:FinishReload()
			end
		end
	end
end

function SWEP:PrimaryAttack(forced)
	if self:GetFireDelay() > CurTime() then return false end
	if !forced and self:GetFireRecoveryDelay() > CurTime() then return false end
	if self:GetReloadDelay() > CurTime() then return false end
	
	if self.Stats["Function"]["Ammo required per shot"] > self:Clip1() then return false end

	if	self.Stats["Function"]["Shots fired maximum"].max != 0 and
		self:GetBurstCount() >= self.Stats["Function"]["Shots fired maximum"].max then
		return false
	end

	-- Make sure we can shoot first
	if self:Clip1() <= 0 then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		--self:Reload()
		return false
	end

	-- Play shoot sound
	self:EmitSound( self.Stats["Appearance"]["Sounds"]["Fire"] )
	self:ShootBullet()

	self:SetFireDelay( CurTime() + self.Stats["Function"]["Fire delay"] )
	self:SetFireRecoveryDelay( CurTime() + self.Stats["Function"]["Fire recovery delay"] )
	self:SetBurstCount( self:GetBurstCount() + 1 )

	self:SendAnim( self.qa["fire"] )

	self:SetClip1( math.max( self:Clip1() - self.Stats["Function"]["Ammo used per shot"], 0) )

	--self:TakePrimaryAmmo( 1 )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	if self:GetReloadDelay() > CurTime() then return end
	if math.min( self:Ammo1(), self.Stats["Magazines"]["Maximum loaded"] - self:Clip1() ) <= 0 then return end

	return self:StartReload()
end

function SWEP:StartReload()
	if self:GetReloadingState() then return end

	local selanim = nil
	if self.qa["reload_enter"] then
		selanim = self.qa["reload_enter"]
	elseif self:Clip1() == 0 and self.qa["reload_empty"] then
		selanim = self.qa["reload_empty"]
	elseif self.qa["reload_full"] then
		selanim = self.qa["reload_full"]
	elseif self.qa["reload"] then
		selanim = self.qa["reload"]
	else
		return
	end

	local playa = self:SendAnim( selanim )
	if playa then
		self:SetReloadDelay( CurTime() + playa[1] )
	end

	self:SetReloadingState(true)
	self:SetBurstCount(0)
	self:SetReloadDelay( CurTime() + self:GetVM():SequenceDuration() )
end

function SWEP:InsertReload()
	if self.qa["reload_insert"] then
		local playa = self:SendAnim(self.qa["reload_insert"])
		self:SetReloadDelay( CurTime() + self:GetVM():SequenceDuration() )
	end
end

function SWEP:FinishReload()
	if self.qa["reload_exit"] then
		local playa = self:SendAnim(self.qa["reload_exit"])
		self:SetReloadDelay( CurTime() + self:GetVM():SequenceDuration() )
	end
	self:SetReloadingState(false)
end

function SWEP:Load()
	local thing = math.min( self:Ammo1(), self.Stats["Magazines"]["Amount reloaded"], self.Stats["Magazines"]["Maximum loaded"] - self:Clip1() )
	self:GetOwner():SetAmmo( self:Ammo1() - thing, self:GetPrimaryAmmoType() )
	self:SetClip1( self:Clip1() + thing )
end

function SWEP:Deploy()
	self:SetHoldType( "pistol" )

	local playa = self:SendAnim( self.qa["draw"] )
	if playa then
		self:SetReloadDelay( CurTime() + playa[1] )
	end

	return true
end

function SWEP:Holster( wep )
	return true
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )
	for i=1, self.Stats["Bullet"]["Count"] do
		local devi = Angle(0, 0, 0)

		local rnd = util.SharedRandom(CurTime()/11, 0, 360, i)
		local rnd2 = util.SharedRandom(CurTime()/22, 0, 1, i*2)
		local deviat = Angle( math.cos(rnd), math.sin(rnd), 0) * ( rnd2 * self.Stats["Bullet"]["Spread"].max )
		
		
		
		
		--( math.max( self.Stats["Error"]["Minimum Error"] or 0, rnd2 * ( Lerp(self:GetInaccCELRate(), self.Stats["Error"]["Error Angle"].min, self.Stats["Error"]["Error Angle"].max ) ) + self.Stats["Projectiles"]["Spread"] ) ) )

		local bullet = {}
		bullet.Num		= 1
		bullet.Attacker = self:GetOwner()
		bullet.Src		= self:GetOwner():GetShootPos()
		bullet.Dir		= ( self:GetOwner():EyeAngles() + deviat ):Forward()
		bullet.Spread	= vector_origin
		bullet.Tracer	= 1
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

function SWEP:GetViewModelPosition(pos, ang)
	local offset = Vector()
	local affset = Angle()

	do
		offset = offset + self.Stats["Appearance"]["Viewmodel"].pos
		affset = affset + self.Stats["Appearance"]["Viewmodel"].ang
	end

	ang:RotateAroundAxis( ang:Right(),		affset.x )
	ang:RotateAroundAxis( ang:Up(),			affset.y )
	ang:RotateAroundAxis( ang:Forward(),	affset.z )
	pos = pos + offset.x * ang:Right()
	pos = pos + offset.y * ang:Forward()
	pos = pos + offset.z * ang:Up()
	
	return pos, ang
end

function SWEP:OnRemove()
end

function SWEP:OwnerChanged()
end

function SWEP:Ammo1()
	return self:GetOwner():GetAmmoCount( self:GetPrimaryAmmoType() )
end

function SWEP:Ammo2()
	return self:GetOwner():GetAmmoCount( self:GetSecondaryAmmoType() )
end

function SWEP:DoImpactEffect( tr, nDamageType )
	return false
end

function SWEP:FireAnimationEvent( pos, ang, event, options )
	return true
end





-- Client
--[[AddCSLuaFile
if CLIENT then
	include
end

-- Server
if SERVER then
	include
end]]

-- Shared
AddCSLuaFile("sh_anim.lua")
include("sh_anim.lua")
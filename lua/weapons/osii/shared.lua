
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

	self.ViewModelFOV_Init = self.ViewModelFOV
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
	self:NetworkVar("Float", 6, "ADSDelta")

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
			--self:SendAnim(self.qa["idle"])
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
		
		if CLIENT and p.randv then
			local fft = FrameTime() * ( self.Stats["Appearance"]["Recoil decay"] or 8 )
			p.randv.x = math.Approach(p.randv.x, 0, fft)
			p.randv.y = math.Approach(p.randv.y, 0, fft)
			p.randv.z = math.Approach(p.randv.z, 0, fft)
		end
		
		local canzoom = self:GetOwner():KeyDown(IN_ATTACK2) and !( self:GetReloadDelay() > CurTime() )
		self:SetADSDelta( math.Approach( self:GetADSDelta(), ( canzoom and 1 or 0 ), FrameTime() / ( self.Stats["ADS"] and self.Stats["ADS"]["Time"] or 0.3 ) ) )
	end
end

function SWEP:TranslateFOV(fov)
	return Lerp( math.pow( math.sin( self:GetADSDelta()*math.pi * 0.5 ), 2 ), fov, self.Stats["ADS"] and self.Stats["ADS"]["FOV"] or fov )
end

function SWEP:AdjustMouseSensitivity(def)
	if self:GetADSDelta() > 0 then
		return Lerp( self:GetADSDelta(), ( math.Clamp(GetConVar("fov_desired"):GetInt(), 75, 100) ), self:GetOwner():GetFOV() ) / ( math.Clamp(GetConVar("fov_desired"):GetInt(), 75, 100) )
	end
end

function SWEP:CalcView(p, pos, ang, fov)
	if p.randv then
		pos = pos + p.randv
	end

	return pos, ang, fov
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

SWEP.BobScale = 0
SWEP.SwayScale = 0
local pvel = 0

local LookX = 0
local LastX = 0
local LookY = 0
local LastY = 0

function SWEP:GetViewModelPosition(pos, ang)
	local p = LocalPlayer()
	local offset = Vector()
	local affset = Angle()
	
	if IsValid(p) then
		pvel = math.Approach(pvel, p:GetVelocity():Length(), FrameTime() * ( p:GetWalkSpeed() * 2 ) )
	else
		pvel = 0
	end

	do -- Offset
		offset = offset + self.Stats["Appearance"]["Viewmodel"].pos
		affset = affset + self.Stats["Appearance"]["Viewmodel"].ang
	end

	do -- Idle
		local mult = 1
		offset.x = offset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 2 ), 2 ) * 0 * mult )
		offset.y = offset.y + ( math.sin( CurTime() ) * 0 * mult )
		offset.z = offset.z + ( math.pow( math.sin( CurTime() * math.pi * 0.5 ), 2 ) * 0.125 * mult )

		affset.x = affset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.25 * 2 ), 2 ) * -0.125 * mult )
		affset.y = affset.y + ( math.pow( math.sin( CurTime() * math.pi * 0.25 * 1 ), 2 ) * -0.25 * mult )
		affset.z = affset.z + ( math.pow( math.sin( CurTime() * math.pi * 0.5 ), 2 ) * 0.125 * mult )
	end

	do -- Moving
		local mult = 1 * ( pvel / p:GetWalkSpeed() )
		offset.x = offset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 2 ), 2 ) * 0.5 * mult )
		offset.y = offset.y + ( math.sin( CurTime() ) * 0 * mult )
		offset.z = offset.z + ( math.pow( math.sin( CurTime() * math.pi * 2 ), 2 ) * -0.5 * mult )

		affset.x = affset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 4 ), 2 ) * 1 * mult )
		affset.y = affset.y + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 2 ), 2 ) * -1 * mult )
		affset.z = affset.z + ( math.pow( math.sin( CurTime() * math.pi * 2 ), 2 ) * 0.5 * mult )
	end

	do -- Sway
		local x = p:EyeAngles().x
		LookX = math.Approach( LookX, (x - LastX), FrameTime() * math.max( LookX, 0.2 ) )
		LookX = math.Clamp(LookX, -1, 1)
		LastX = x
		offset.z = offset.z + LookX * 0.25
		affset.x = affset.x + LookX * -15

		local y = p:EyeAngles().y
		LookY = math.Approach( LookY, (y - LastY), FrameTime() * 1 )
		LookY = math.Clamp(LookY, -1, 1)
		LastY = y
		offset.x = offset.x + LookY * 0.5
		affset.y = affset.y + LookY * 2
	end

	do -- ADS
		local mult = math.pow( math.sin( self:GetADSDelta() * math.pi * 0.5 ), 2 )
		if self.IronSightsPos then
			local midpoint = mult * math.cos(mult * (math.pi / 2))
			offset = offset + ( self.IronSightsPos * mult )

			midpointpos.x = self.IronSightsPos.x * 0.5
			offset = offset + ( midpointpos * midpoint )
		end

		if self.IronSightsAng then
			angset.x = angset.x + ( self.IronSightsAng.x * mult )
			angset.y = angset.y + ( self.IronSightsAng.y * mult )
			angset.z = angset.z + ( self.IronSightsAng.z * mult )
		end

		self.ViewModelFOV = Lerp(mult, self.ViewModelFOV_Init, self.ViewModelFOV_Init*1.1)
	end

	ang:RotateAroundAxis( ang:Right(),		affset.x )
	ang:RotateAroundAxis( ang:Up(),			affset.y )
	ang:RotateAroundAxis( ang:Forward(),	affset.z )
	pos = pos + offset.x * ang:Right()
	pos = pos + offset.y * ang:Forward()
	pos = pos + offset.z * ang:Up()
	if p.randv then
		pos = pos + p.randv
	end
	
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
AddCSLuaFile("sh_firing.lua")
AddCSLuaFile("sh_reload.lua")
include("sh_anim.lua")
include("sh_firing.lua")
include("sh_reload.lua")
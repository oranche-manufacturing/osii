
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
SWEP.Stats	= {}

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
	self:NetworkVar("Float", 7, "AccelFirerate")
	self:NetworkVar("Float", 8, "AccelInaccuracy")
	self:NetworkVar("Float", 9, "AccelHeat")
	self:NetworkVar("Float", 10, "Battery")

	self:NetworkVar("Bool", 0, "ReloadingState")
	self:NetworkVar("Bool", 1, "Overheated")
end

function SWEP:Think()
	local p = self:GetOwner()

	if IsValid(p) then

		do -- Accels
			local doo = ( self:GetFireDelay() >= ( CurTime() - engine.TickInterval() ) )-- or ( self:GetFireRecoveryDelay() >= ( CurTime() - engine.TickInterval() ) )

			local accelrange = self.Stats["Function"]["Fire acceleration time"]
			if accelrange then
				self:SetAccelFirerate( math.Approach(self:GetAccelFirerate(), ( doo and 1 or 0 ), FrameTime() / ( doo and accelrange.min or accelrange.max ) ) )
			end

			local inaccrange = self.Stats["Bullet"]["Spread acceleration time"]
			if inaccrange then
				self:SetAccelInaccuracy( math.Approach(self:GetAccelInaccuracy(), ( doo and 1 or 0 ), FrameTime() / ( doo and inaccrange.min or inaccrange.max ) ) )
			end

			if self.Stats["Heat"] then
				local heatrange = self.Stats["Heat"]["Heat acceleration time"]
				if heatrange then
					self:SetAccelHeat( math.Approach(self:GetAccelHeat(), ( doo and 1 or 0 ), FrameTime() / ( doo and heatrange.min or ( self:GetOverheated() and self.Stats["Heat"]["Deceleration while overheated"] or heatrange.max ) ) ) )
				end
				if !self:GetOverheated() and self:GetAccelHeat() >= self.Stats["Heat"]["Overheated threshold"] then
					self:SendAnim(self.qa["oh_enter"])
					self:SetOverheated(true)
				end
				if self:GetOverheated() and self:GetAccelHeat() <= self.Stats["Heat"]["Recovery threshold"] then
					self:SendAnim(self.qa["oh_exit"])
					self:SetOverheated(false)
				end
			end
		end

		do -- Burst features
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
		end
		
		-- Events
		for i, v in ipairs(self.EventTable) do
			for ed, bz in pairs(v) do
				if ed <= CurTime() then
					self:PlayEvent(bz)
					self.EventTable[i][ed] = nil
					if table.IsEmpty(v) and i != 1 then self.EventTable[i] = nil end
				end
			end
		end

		do -- Reloading
			if self:GetReloadLoadDelay() != 0 and self:GetReloadLoadDelay() <= CurTime() then
				self:SetReloadLoadDelay(0)
				self:Load()
			end
				
			if self:GetReloadingState() and self:Clip1() > 0 and ( p:KeyDown(IN_ATTACK) or p:KeyDown(IN_ATTACK2) ) then
				self:FinishReload()
			end

			if self:GetReloadingState() and self:GetReloadDelay() < CurTime() then
				if self:Clip1() < self.Stats["Magazines"]["Maximum loaded"] and self:Ammo1() > 0 then
					self:InsertReload()
				else
					self:FinishReload()
				end
			end
		end

		-- Recoil
		if CLIENT and p.randv then
			local fft = FrameTime() * ( self.Stats["Appearance"]["Recoil decay"] or 8 )
			p.randv.x = math.Approach(p.randv.x, 0, fft)
			p.randv.y = math.Approach(p.randv.y, 0, fft)
			p.randv.z = math.Approach(p.randv.z, 0, fft)
		end
		
		-- ADS
		local canzoom = self:GetOwner():KeyDown(IN_ATTACK2) and !( self:GetReloadDelay() > CurTime() )
		self:SetADSDelta( math.Approach( self:GetADSDelta(), ( canzoom and 1 or 0 ), FrameTime() / ( self.Stats["ADS"] and self.Stats["ADS"]["Time"] or 0.3 ) ) )

		-- Idles
		if self:GetNextIdle() <= CurTime() then
			if self:GetOverheated() and self.qa["idle_oh"] then
				self:SendAnim(self.qa["idle_oh"])
			elseif self.qa["idle"] then
				self:SendAnim(self.qa["idle"])
			end
		end
	end
end

function SWEP:TranslateFOV(fov)
	return Lerp( math.pow( math.sin( self:GetADSDelta() * math.pi * 0.5 ), 2 ), fov, self.Stats["ADS"]["FOV"] )
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
	self:SetADSDelta(0)
	self:SetReloadDelay(CurTime())

	local playa = self:SendAnim( self.qa["draw"] )
	if playa then
		self:SetReloadDelay( CurTime() + playa[1] )
	end

	return true
end

function SWEP:Holster( wep )
	self:SetReloadLoadDelay(0)
	self:SetReloadingState(false)

	return true
end

SWEP.BobScale = 0
SWEP.SwayScale = 0
local pvel = 0

local yaaa = Angle()
local laaa = Angle()

function SWEP:PreDrawViewModel(vm, wep, p)
	if vm == p:GetViewModel(0) then
		--[[local x = p:EyeAngles().x
		x = math.NormalizeAngle( x )
		LookX = Lerp( math.min( FrameTime(), 1 ), LookX, (x - LastX) )
		LastX = x
		
		local y = p:EyeAngles().y
		y = math.NormalizeAngle( y )
		LookY = Lerp( math.min( FrameTime(), 1 ), LookY, (y - LastY) )
		LastY = y]]

		yaaa = LerpAngle( FrameTime() * 4, yaaa, Angle( ( p:EyeAngles().x - laaa.x ), ( p:EyeAngles().y - laaa.y ), 0 ) )
		laaa.x = p:EyeAngles().x
		laaa.y = p:EyeAngles().y
	end
end

local midpointpos = Vector(0, 5, -5)
local midpointang = Angle(5, 5, -25)
function SWEP:GetViewModelPosition(pos, ang)
	local p = LocalPlayer()
	local offset = Vector()
	local affset = Angle()
	
	if IsValid(p) then
		pvel = math.Approach(pvel, p:OnGround() and p:GetVelocity():Length2D() or 0, FrameTime() * ( p:GetWalkSpeed() * 2 ) )
	else
		pvel = 0
	end

	do -- Offset
		offset:Add(self.Stats["Appearance"]["Viewmodel"].pos)
		affset:Add(self.Stats["Appearance"]["Viewmodel"].ang)
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
		local mult = Lerp( self:GetADSDelta(), 0.8, 0.4 ) * ( pvel / p:GetWalkSpeed() )
		local spe = 1
		local shar = 1
		offset.x = offset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 2 * spe ), 2*shar ) * 0.2 * mult )
		offset.y = offset.y + ( math.pow( math.sin( CurTime() * math.pi * 2 * spe ), 4*shar ) * -0.1 * mult )
		offset.z = offset.z + ( math.pow( math.sin( CurTime() * math.pi * 2 * spe ), 2*shar ) * -0.25 * mult )

		affset.x = affset.x + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 4 * spe ), 2*shar ) * 0.5 * mult )
		affset.y = affset.y + ( math.pow( math.sin( CurTime() * math.pi * 0.5 * 2 * spe ), 2*shar ) * -0.5 * mult )
		affset.z = affset.z + ( math.pow( math.sin( CurTime() * math.pi * 2 * spe ), 2*shar ) * 1 * mult )
	end

	do -- Sway
		local mult = Lerp( self:GetADSDelta(), 0.4, 0.01 )
		offset.z = offset.z + math.abs(yaaa.x) * -0.25 * mult
		affset.x = affset.x + yaaa.x * -1.5 * mult
		affset.z = affset.z + math.abs(yaaa.x) * -4 * mult

		offset.x = offset.x + yaaa.y * -1 * mult
		affset.y = affset.y + yaaa.y * 2 * mult
		
		affset.z = affset.z + math.abs(yaaa.y) * -2 * mult
		offset.x = offset.x + yaaa.y * 1.5 * mult
		offset.z = offset.z + math.abs(yaaa.y) * -0.22 * mult

	end

	do -- ADS
		local mult = math.pow( math.sin( self:GetADSDelta() * math.pi * 0.5 ), 2 )
		local midpoint = mult * math.cos(mult * (math.pi / 2))
		if self.Stats["ADS"]["Viewmodel"].pos then
			local contset = ( self.Stats["ADS"]["Viewmodel"].pos * mult )
			contset = contset + ( midpointpos * midpoint )

			offset = LerpVector( mult, offset, contset )
		end

		if self.Stats["ADS"]["Viewmodel"].ang then
			affset = LerpAngle( mult, affset, self.Stats["ADS"]["Viewmodel"].ang + ( midpointang * midpoint ) )
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
AddCSLuaFile("cl_hud.lua")
if CLIENT then
	include("cl_hud.lua")
end
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
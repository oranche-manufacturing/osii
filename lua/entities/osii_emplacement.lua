
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Spawnable = true
ENT.Category = "OSII"
ENT.PrintName = "Turret Emplacement"
ENT.TurretClass = "osii_turret"
ENT.Model = Model("models/props_combine/breendesk.mdl")

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if SERVER then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	self:PhysWake()
end

function ENT:OnRemove()
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Controller")
	self:NetworkVar("Entity", 1, "LinkedTurret")
end

local offset = Vector(0, -50, 0)
function ENT:Use( acti )
	if acti:IsPlayer() then
		local wept = weapons.Get(self.TurretClass)
		if acti:GetPos():Distance(self:GetPos()) > wept.Stats["Emplacement"]["Maximum distance"] then
			acti:ChatPrint("Too far")
		elseif acti:HasWeapon(self.TurretClass) then
			acti:ChatPrint("You already have the same weapon")
		else
			local wep = acti:Give(self.TurretClass)
			self:SetController(acti)
			self:SetLinkedTurret(wep)
			wep:SetEmplacement(self)
			acti:ChatPrint("Activated")
			local thing = self:GetPos() + ( self:GetAngles():Right() * offset.x ) + ( self:GetAngles():Forward() * offset.y ) + ( self:GetAngles():Up() * offset.z )
			local tr = util.TraceLine({
				start = thing,
				endpos = thing + Vector( 0, 0, -32 ),
				filter = {self},
			})
			acti:SetPos( tr.HitPos )
			acti:SetAbsVelocity( Vector(0, 0, 0) )
		end
	end
end

function ENT:Think()
	local wept = weapons.Get(self.TurretClass)
	if SERVER and IsValid(self:GetLinkedTurret()) and IsValid(self:GetLinkedTurret():GetOwner()) and self:GetLinkedTurret():GetOwner():IsPlayer() then
		if self:GetLinkedTurret():GetOwner():GetPos():Distance(self:GetPos()) > wept.Stats["Emplacement"]["Maximum distance"] then
			self:GetLinkedTurret():GetOwner():ChatPrint("Too far, deactivated")
			self:GetLinkedTurret():Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
		self:Draw()
	end
end
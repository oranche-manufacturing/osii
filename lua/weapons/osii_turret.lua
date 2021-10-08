
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Turret"
SWEP.Category				= "OSII"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel				= "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_DUEL, ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN }
SWEP.Stats	= {
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 3, 24 ),
		["Range"]						= Range( 1000, 3000 ), -- hammer units
		["Spread"]						= Range( 2, 2 ), -- degree(s)
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= 0.08, -- Mechanical firerate
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 0,
		["Ammo required per shot"]		= 0,
		["Shots fired maximum"]			= Range( 0, 0 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Turret.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(-2, -3, 0),
			["ang"] = Angle(0, 0, 0)
		},
		["Third Person"] = {
			["pos"] = Vector(16, -16, -8),
			["ang"] = Angle(0, 0, 0),
			["fov"] = 75,
		},
		["Holdtypes"] = {
			["Active"] = "crossbow"
		}
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 200,
		["Maximum loaded"]				= 200,
		["Ammo type"]					= "smg1",
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle1",
		},
		["fire"]	= {
			{
				seq = "shoot1",
				tpanim = tpa[2]
			},
			{
				seq = "shoot2",
				tpanim = tpa[2]
			},
		},
		["reload"]	= {
			seq = "reload",
			tpanim = tpa[1],
			time_load = 1
		},
		["draw"]	= {
			seq = "draw",
		},
	},
	["ADS"] = {
		["Viewmodel"] = {
			pos = Vector(-4, -4, 2),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.25,
	},
	["Emplacement"] = {
		["Maximum distance"] = 80,
	}
}
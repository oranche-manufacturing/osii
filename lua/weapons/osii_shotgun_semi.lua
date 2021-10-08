
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Semi Shotgun"
SWEP.Category				= "OSII"
SWEP.Slot					= 2
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/assault_rifle.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --this is shit probably ill balance later lmao
	["Bullet"]		= {
		["Count"]						= 12,
		["Damage"]						= Range( 12, 24 ),
		["Range"]						= Range( 200, 500 ), -- hammer units
		["Spread"]						= Range( 6, 11 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.6, 0.6 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= 0.25, -- Mechanical firerate, start to finish
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 1, 1 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Pistol_Magnum.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0.25, 0, -1.5),
			["ang"] = Angle(0, 0, 0)
		},
		["Holdtypes"] = {
			["Active"] = "shotgun",
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 1,
		["Maximum loaded"]				= 8,
		["Ammo type"]					= "ar2",
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle",
		},
		["fire"]	= {
			{
				seq = "fire1",
				tpanim = tpa[2]
			},
			{
				seq = "fire2",
				tpanim = tpa[2]
			},
			{
				seq = "fire3",
				tpanim = tpa[2]
			},
		},
		["reload"]	= {
			seq = "reload_empty",
			tpanim = tpa[1],
			time_load = 1
		},
		["draw"]	= {
			seq = "ready",
		},
		["holster"]	= {
			seq = "put_away",
		},
	},
	["ADS"] = {
		["Viewmodel"] = {
			pos = Vector(-1.5, -4, -0.3),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.3,
	}
}
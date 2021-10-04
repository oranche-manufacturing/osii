
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Sub-Machine Gun"
SWEP.Category				= "OSII"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/smg.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --The idea is that this is just a superior Machine Pistol. -OP
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 20, 20 ),
		["Range"]						= Range( 300, 600 ), -- hammer units
		["Spread"]						= Range( 0.5, 5 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.6, 0.4 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= ( 60 / 800 ), -- Mechanical firerate, start to finish
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 0, 0 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Pistol.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0, 0, -0.8),
			["ang"] = Angle(-2, 0, 0)
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 30,
		["Maximum loaded"]				= 30,
		["Ammo type"]					= "pistol",
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle",
		},
		["fire"]	= {
			seq = "fire1",
			tpanim = tpa[2]
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
			pos = Vector(-3.65, -8, -0.2),
			ang = Angle(0, -1.2, 0)
		},
		["FOV"] = 75,
		["Time"] = 0.28,
	}
}
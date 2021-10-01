
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Caseless Battery Rifle"
SWEP.Category				= "OSII"
SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.Trivia					= {
	["Description"]	= [[An internal engine powers the mechanism inside.
	]]
}

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/assault_rifle.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= {
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 7, 15 ),
		["Range"]						= Range( 500, 2000 ), -- hammer units
		["Spread"]						= Range( 2, 5 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 3, 5 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= Range( 0.15, 0.04 ), -- Mechanical firerate, start to finish
		["Fire acceleration time"]		= Range( 3, 5 ), -- Time to spin up/down barrels
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 0, 0 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.AssaultRifle.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0, 0, -1),
			["ang"] = Angle(0, 0, 0)
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 55,
		["Maximum loaded"]				= 55,
		["Ammo type"]					= "smg1",
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
			pos = Vector(-2, -4, 0.3),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.3,
	}
}
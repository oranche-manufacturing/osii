
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Pistol"
SWEP.Category				= "OSII"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/automag lite.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --its a gun.
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 22, 22 ),
		["Range"]						= Range( 250, 1000 ), -- hammer units
		["Spread"]						= Range( 1, 6 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.25, 0.25 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= 0.12, -- Mechanical firerate, start to finish
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 1, 1 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Pistol.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0, 2, -0.5),
			["ang"] = Angle(0, 0, 0)
		},
		["Holdtypes"] = {
			["Active"] = "pistol",
		}
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
			pos = Vector(-4.05, -2, 1.2),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.28,
	}
}
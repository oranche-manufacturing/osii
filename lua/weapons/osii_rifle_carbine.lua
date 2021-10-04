
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Carbine"
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
SWEP.Stats	= { --Actually a burst weapon. Id rather name it "Burst Rifle", but apparently that conflicts with something.. or something.
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 11, 19 ),
		["Range"]						= Range( 500, 2000 ), -- hammer units
		["Spread"]						= Range( 0.75, 9 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.9, 1.1 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= 0.059, -- Mechanical firerate, start to finish
		["Fire recovery delay"]			= 0.17, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 3, 3 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.MG_Light.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0, 0, -1),
			["ang"] = Angle(0, 0, 0)
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 30,
		["Maximum loaded"]				= 30,
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
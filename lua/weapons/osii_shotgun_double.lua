
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Double-Barreled Shotgun"
SWEP.Category				= "OSII"
SWEP.Slot					= 2
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --Supposed to be for the shotgun users who want more accuracy or bang for buck, with the obvious downside of low capacity
	["Bullet"]		= {
		["Count"]						= 15,
		["Damage"]						= Range( 3, 10 ),
		["Range"]						= Range( 300, 600 ), -- hammer units
		["Spread"]						= Range( 4, 10 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.125, 0.4 ), -- How long it takes to accurate
		["Force"]						= 2
	},
	["Function"]	= {
		["Fire delay"]					= 0.125, -- Mechanical firerate, start to finish
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 1, 2 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Shotgun.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(0, 0, -0.5),
			["ang"] = Angle(-2, 0, 0)
		},
		["Recoil mult"] = 16,
		["Recoil decay"] = 48,
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 2,
		["Maximum loaded"]				= 2,
		["Ammo type"]					= "buckshot",
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle",
		},
		["fire"]	= {
			{
				seq = "fire1",
				tpanim = tpa[2],
			},
			{
				seq = "fire2",
				tpanim = tpa[2],
			},
			{
				seq = "fire3",
				tpanim = tpa[2],
			},
		},
		["reload_enter"]	= {
			seq = "reload_enter",
			tpanim = tpa[1],
			events = { { t = 0, s = "OSII.Shotgun.Reload_Start" } }
		},
		["reload_insert"]	= {
			seq = "reload_insert",
			tpanim = tpa[1],
			time_load = 0.3,
			events = { { t = 0, s = "OSII.Shotgun.Reload_Insert" } }
		},
		["reload_exit"]	= {
			seq = "reload_exit",
			tpanim = tpa[1],
			events = { { t = 0, s = "OSII.Shotgun.Reload_Finish" } }
		},
		["draw"]	= {
			seq = "ready",
			events = { { t = 0, s = "OSII.Shotgun.Pump" } }
		},
		["holster"]	= {
			seq = "put_away",
		},
	},
	["ADS"] = {
		["Viewmodel"] = {
			pos = Vector(-2, -1, 0),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.35,
	}
}
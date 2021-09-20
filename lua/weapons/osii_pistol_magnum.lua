
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Magnum Pistol"
SWEP.Category				= "OSII"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/magnum.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= {
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 17, 30 ),
		["Range"]						= Range( 250, 1000 ), -- hammer units
		["Spread"]						= Range( 2, 2 ), -- degree(s)
		["Force"]						= 5
	},
	["Function"]	= {
		["Fire delay"]					= 0.3, -- Mechanical firerate
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
			["pos"] = Vector(0, 0, 0),
			["ang"] = Angle(-5, 0, 0)
		},
		["Recoil mult"] = 4,
		["Recoil decay"] = 16,
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 8,
		["Maximum loaded"]				= 8,
		["Ammo type"]					= "357",
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
			{
				seq = "fire4",
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
			pos = Vector(-4.05, -2, 1.3),
			ang = Angle()
		},
		["FOV"] = 75,
		["Time"] = 0.25,
	}
}
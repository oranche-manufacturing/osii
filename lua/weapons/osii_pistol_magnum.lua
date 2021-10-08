
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
SWEP.ViewModel				= "models/gh3_temp/fp/automag.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --Supposed to be a middle-ground between the capacity and recoil of the Pistol and the punch and kick of the Revolver.
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 35, 35 ),
		["Range"]						= Range( 250, 1000 ), -- hammer units
		["Spread"]						= Range( 0.8, 7 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.3, 0.3 ), -- How long it takes to accurate
		["Force"]						= 3
	},
	["Function"]	= {
		["Fire delay"]					= 0.3, -- Mechanical firerate, start to finish
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
			["pos"] = Vector(0, 2, -0.5),
			["ang"] = Angle(0, 0, 0)
		},
		["Holdtypes"] = {
			["Active"] = "pistol",
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
				tpanim = tpa[2],
				rate = 0.5,
			},
			{
				seq = "fire2",
				tpanim = tpa[2],
				rate = 0.5,
			},
			{
				seq = "fire3",
				tpanim = tpa[2],
				rate = 0.5,
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
		["Time"] = 0.28,
	}
}
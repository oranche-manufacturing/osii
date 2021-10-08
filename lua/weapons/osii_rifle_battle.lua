
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Battle Rifle"
SWEP.Category				= "OSII"
SWEP.Slot					= 2
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/battle_rifle.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_m4a1.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --semi-auto hard-hitter meant as an alternate to the Carbine
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 12, 24 ),
		["Range"]						= Range( 500, 1500 ), -- hammer units
		["Spread"]						= Range( 1, 8 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.6, 0.25 ), -- How long it takes to accurate
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
			["pos"] = Vector(0.25, 0, -0.5),
			["ang"] = Angle(-2, 0, 0)
		},
		["Holdtypes"] = {
			["Active"] = "ar2",
		}
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 18,
		["Maximum loaded"]				= 18,
		["Ammo type"]					= "ar2",
	},
	["Recoil"] = {
		["Change per shot"]				= Range( 2, 8 ),
		["Recoil acceleration time"]	= Range( 0.6, 0.25 ), -- How long it takes to accurate
		["Function"]					= "Late", -- Linear, Early, Very Early, Late, Very Late, Cosine, Zero, One
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
			pos = Vector(-1.5, -4, -0.3),
			ang = Angle()
		},
		["FOV"] = 60,
		["Time"] = 0.3,
	}
}
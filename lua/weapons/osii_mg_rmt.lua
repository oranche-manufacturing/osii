
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Rotary Machine Turret"
SWEP.Category				= "OSII"
SWEP.Slot					= 3
SWEP.SlotPos				= 0
SWEP.Trivia					= {
	["Description"]	= [[Large heavy rotary machine turret.
	High inaccuracy under sustained fire. Use in bursts.]]
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
		["Damage"]						= Range( 9, 16 ),
		["Range"]						= Range( 500, 4000 ), -- hammer units
		["Spread"]						= Range( 1.5, 6 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 2.5, 0.5 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= Range( 0.15, 0.08 ), -- Mechanical firerate, start to finish, start to finish
		["Fire acceleration time"]		= Range( 2.5, 1 ), -- Time to spin up/down barrels
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 0, 0 )
	},
	["Appearance"]	= {
		["Sounds"]		= {
			["Fire"]					= "OSII.Pistol_Magnum.Fire",
			["Dry"]						= "OSII.Pistol.Dry",
		},
		["Viewmodel"] = {
			["pos"] = Vector(-0.5, -3, -1),
			["ang"] = Angle(0, 0, 0)
		},
		["Holdtypes"] = {
			["Active"] = "crossbow",
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 200,
		["Maximum loaded"]				= 200,
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
			pos = Vector(-1, -4, 0.3),
			ang = Angle()
		},
		["FOV"] = 60,
		["Time"] = 0.5,
	}
}
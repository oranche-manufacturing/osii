
-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Shotgun"
SWEP.Category				= "OSII"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3/fp/shotgun.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_p228.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= {
	["Bullet"]		= {
		["Count"]						= 15,
		["Damage"]						= Range( 3, 13 ),
		["Range"]						= Range( 250, 1000 ), -- hammer units
		["Spread"]						= Range( 6, 6 ), -- degree(s)
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= 1, -- Mechanical firerate
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
			["pos"] = Vector(0, 0, 0),
			["ang"] = Angle(-5, 0, 0)
		},
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 1,
		["Maximum loaded"]				= 6,
		["Ammo type"]					= "buckshot",
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
		["reload_enter"]	= {
			seq = "reload_enter",
			tpanim = tpa[1]
		},
		["reload_insert"]	= {
			seq = "reload_insert",
			tpanim = tpa[1],
			time_load = 0.3
		},
		["reload_exit"]	= {
			seq = "reload_exit",
			tpanim = tpa[1]
		},
		["draw"]	= {
			seq = "ready",
		},
		["holster"]	= {
			seq = "put_away",
		},
	},
}
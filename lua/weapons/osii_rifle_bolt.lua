
-- OSII weapon
--This is scuffed as all hell, probably. I took the pump shotgun and basically made it into a slow-acting no-scope machine.. thing. For now. -OP
-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Bolt-Action Rifle"
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
SWEP.Stats	= { --Single most powerful weapon in the pack other than the Railgun. -OP
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 90, 90 ),
		["Range"]						= Range( 500, 1000 ), -- hammer units
		["Spread"]						= Range( 0.25, 5 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 0.1, 1 ), -- How long it takes to accurate
		["Force"]						= 2
	},
	["Function"]	= {
		["Fire delay"]					= 1, -- Mechanical firerate, start to finish/ I hate math. Making it 1 second for now. -OP
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 1,
		["Ammo required per shot"]		= 1,
		["Shots fired maximum"]			= Range( 1, 1 )
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
		["Recoil mult"] = 8,
		["Recoil decay"] = 16,
	},
	["Magazines"]	= {
		["Amount reloaded"]				= 1,
		["Maximum loaded"]				= 6,
		["Ammo type"]					= "ar2", --Still debating if using the sniper ammo is necessary. ar2 for now. -OP
	},
	["Animation"] = {
		["idle"]	= {
			seq = "idle",
		},
		["fire"]	= {
			{
				seq = "fire1",
				tpanim = tpa[2],
				events = { { t = 0.2, s = "OSII.Shotgun.Pump" } }
			},
			{
				seq = "fire2",
				tpanim = tpa[2],
				events = { { t = 0.2, s = "OSII.Shotgun.Pump" } }
			},
			{
				seq = "fire3",
				tpanim = tpa[2],
				events = { { t = 0.2, s = "OSII.Shotgun.Pump" } }
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
		["FOV"] = 50,
		["Time"] = 0.75,
	}
}

-- OSII weapon

-- 1
SWEP.Spawnable				= true
SWEP.Base					= "osii"
SWEP.PrintName				= "Cordless Energy Rifle"
SWEP.Category				= "OSII"
SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.Trivia					= {
	["Description"]	= [[Advancements in technology have made it possible to use energy as a projectile without the use of an external power supply.
	An internal engine powers the mechanism inside.]]
}

-- 2
SWEP.ViewModelFOV			= 60
SWEP.ViewModel				= "models/gh3_temp/fp/plasma_rifle.mdl"
SWEP.WorldModel				= "models/weapons/w_rif_galil.mdl"
SWEP.UseHands				= true

-- 3
local tpa = { ACT_HL2MP_GESTURE_RELOAD_PISTOL, ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL }
SWEP.Stats	= { --Energy weapons do low damage but have infinite ammo and get more accurate as youre shooting, but can overheat.
	["Bullet"]		= {
		["Count"]						= 1,
		["Damage"]						= Range( 7, 15 ),
		["Range"]						= Range( 500, 2000 ), -- hammer units
		["Spread"]						= Range( 6, 2 ), -- degrees, min to max
		["Spread acceleration time"]	= Range( 2, 2 ), -- How long it takes to accurate
		["Force"]						= 1
	},
	["Function"]	= {
		["Fire delay"]					= Range( 0.15, 0.07 ), -- Mechanical firerate, start to finish
		["Fire acceleration time"]		= Range( 4, 2 ), -- Time to spin up/down barrels
		["Fire recovery delay"]			= 0, -- Delay between each burst
		["Ammo used per shot"]			= 0,
		["Ammo required per shot"]		= 0,
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
		["Amount reloaded"]				= 0,
		["Maximum loaded"]				= 0,
		["Ammo type"]					= "none",
	},
	["Battery"] = {
		["Age per shot"] = 1/3000, -- X shots until inoperable
		["Age heat recovery penalty"] = 0.2, -- Heat will take x longer to recover
		["Age rate of fire penalty"] = 0.2, -- Gun will take x longer to shoot
		["Misfire threshold"] = 0.10, -- at X battery left, the gun begins to misfire
		["Misfire chance"] = 0.05, -- at 0% battery, the chance the gun will misfire
	},
	["Heat"] = {
		["Heat acceleration time"] = Range( 2.5, 0.34 ), -- Time to overheat or cooldown
		["Deceleration while overheated"] = 2.5, -- Deceleration time under overheat
		["Recovery threshold"] = 0.1, -- Gun is usable past this threshold
		["Overheated threshold"] = 1, -- Gun overheats past this threshold
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
		["oh_enter"]	= {
			seq = "oh_heating",
		},
		["idle_oh"]	= {
			seq = "oh_heated",
		},
		["oh_exit"]	= {
			seq = "oh_exit",
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
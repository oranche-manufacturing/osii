


local chans = {}
chans.weapfire = CHAN_STATIC
chans.weapfiredist = CHAN_STATIC
chans.weapreload = CHAN_STATIC

local addsound = {
	{
		name = "OSII.AssaultRifle.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/assaultrifle/fire1.wav",
			")osii/weap/assaultrifle/fire2.wav",
			")osii/weap/assaultrifle/fire3.wav",
			")osii/weap/assaultrifle/fire4.wav",
		},
	},
	{
		name = "OSII.Shotgun.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/shotgun/fire1.wav",
			")osii/weap/shotgun/fire2.wav",
			")osii/weap/shotgun/fire3.wav",
			")osii/weap/shotgun/fire4.wav",
			")osii/weap/shotgun/fire5.wav",
		},
	},
	{
		name = "OSII.Shotgun.Pump",
		channel = chans.weapreload,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/shotgun/pump1.wav",
			")osii/weap/shotgun/pump2.wav",
			")osii/weap/shotgun/pump3.wav",
		},
	},
	{
		name = "OSII.Shotgun.Reload_Start",
		channel = chans.weapreload,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/shotgun/reload_start1.wav",
			")osii/weap/shotgun/reload_start2.wav",
			")osii/weap/shotgun/reload_start3.wav",
		},
	},
	{
		name = "OSII.Shotgun.Reload_Insert",
		channel = chans.weapreload,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/shotgun/reload_insert1.wav",
			")osii/weap/shotgun/reload_insert2.wav",
			")osii/weap/shotgun/reload_insert3.wav",
		},
	},
	{
		name = "OSII.Shotgun.Reload_Finish",
		channel = chans.weapreload,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = ")osii/weap/shotgun/reload_finish.wav",
	},
	{
		name = "OSII.Pistol.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/pistol/fire.wav",
		},
	},
	{
		name = "OSII.Pistol.Dry",
		channel = chans.weapfire,
		volume = 0.5,
		level = 60,
		pitch = pn,
		sound = {
			")weapons/ar2/ar2_empty.wav",
		},
	},
	{
		name = "OSII.Pistol.FireDist",
		channel = chans.weapfiredist,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/pistol/fire_dist1.wav",
			")osii/weap/pistol/fire_dist2.wav",
			")osii/weap/pistol/fire_dist3.wav",
		},
	},
	{
		name = "OSII.Pistol_Magnum.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/pistol_magnum/fire1.wav",
			")osii/weap/pistol_magnum/fire2.wav",
			")osii/weap/pistol_magnum/fire3.wav",
			")osii/weap/pistol_magnum/fire4.wav",
			")osii/weap/pistol_magnum/fire5.wav",
		},
	},
	{
		name = "OSII.Revolver.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = ")weapons/357/357_fire2.wav",
	},
	{
		name = "OSII.SMG.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = {
			")osii/weap/smg/fire1.wav",
			")osii/weap/smg/fire2.wav",
			")osii/weap/smg/fire3.wav",
			")osii/weap/smg/fire4.wav",
		},
	},
	{
		name = "OSII.MG_Light.Fire",
		channel = chans.weapfire,
		volume = 0.5,
		level = 140,
		pitch = pn,
		sound = "^weapons/ar1/ar1_dist2.wav",
	},
}

for i, v in ipairs(addsound) do
	sound.Add(v)
end
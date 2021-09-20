


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
}

for i, v in ipairs(addsound) do
	sound.Add(v)
end
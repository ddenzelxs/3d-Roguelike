extends Node
class_name UpgradeData

enum Rarity { COMMON, RARE, EPIC }

# Each upgrade: { name, description, rarity, icon (optional), apply function name, stat key }
static var pool: Array[Dictionary] = [
	# ===== HEALTH =====
	{
		"id": "health_up",
		"name": "Iron Constitution",
		"description": "+20 Max HP",
		"rarity": Rarity.COMMON,
		"apply": "upgrade_max_health",
		"value": 20,
		"cost": 50,
	},
	{
		"id": "health_up_large",
		"name": "Titan's Vigor",
		"description": "+50 Max HP",
		"rarity": Rarity.RARE,
		"value": 50,
		"cost": 50,
		"apply": "upgrade_max_health",
	},
	{
		"id": "heal",
		"name": "Second Wind",
		"description": "Restore 30% of max HP",
		"rarity": Rarity.COMMON,
		"value": 0.3,
		"cost": 50,
		"apply": "upgrade_heal_percent",
	},

	# ===== DAMAGE =====
	{
		"id": "damage_up",
		"name": "Sharpened Blade",
		"description": "+15% Melee & Bullet Damage",
		"rarity": Rarity.COMMON,
		"value": 0.1,
		"cost": 50,
		"apply": "upgrade_damage_multiplier",
	},
	{
		"id": "damage_up_large",
		"name": "Berserker's Fury",
		"description": "+30% Melee & Bullet Damage",
		"rarity": Rarity.RARE,
		"value": 0.3,
		"cost": 50,
		"apply": "upgrade_damage_multiplier",
	},

	# ===== GOLD =====
	{
		"id": "gold_up",
		"name": "Golden Touch",
		"description": "+15% Gold Gain",
		"rarity": Rarity.COMMON,
		"value": 0.1,
		"cost": 50,
		"apply": "upgrade_gold_multiplier",
	},
	{
		"id": "gold_up_large",
		"name": "Midas Blessing",
		"description": "+35% Gold Gain",
		"rarity": Rarity.EPIC,
		"value": 0.3,
		"cost": 50,
		"apply": "upgrade_gold_multiplier",
	},

	# ===== BULLET =====
	{
		"id": "bullet_speed",
		"name": "Rifled Barrel",
		"description": "+25% Bullet Speed",
		"rarity": Rarity.COMMON,
		"value": 0.25,
		"cost": 50,
		"apply": "upgrade_bullet_speed",
	},
	{
		"id": "bullet_damage",
		"name": "Hollow Points",
		"description": "+10 Bullet Damage",
		"rarity": Rarity.RARE,
		"value": 10,
		"cost": 50,
		"apply": "upgrade_bullet_damage",
	},

	# ===== MOVEMENT =====
	{
		"id": "move_speed",
		"name": "Wind Walker",
		"description": "+12% Movement Speed",
		"rarity": Rarity.COMMON,
		"value": 0.12,
		"cost": 50,
		"apply": "upgrade_move_speed",
	},
	{
		"id": "sprint_duration",
		"name": "Marathon Runner",
		"description": "+1.5s Sprint Duration",
		"rarity": Rarity.RARE,
		"value": 1.5,
		"cost": 50,
		"apply": "upgrade_sprint_duration",
	},

	# ===== ATTACK SPEED =====
	{
		"id": "attack_speed",
		"name": "Quick Hands",
		"description": "-15% Melee Cooldown",
		"rarity": Rarity.RARE,
		"value": 0.15,
		"cost": 50,
		"apply": "upgrade_attack_speed",
	},
]

# Weighted random pick — rarer upgrades are less likely
static var rarity_weights: Dictionary = {
	Rarity.COMMON: 60,
	Rarity.RARE: 30,
	Rarity.EPIC: 10,
}

static func get_random_upgrades(count: int = 3) -> Array[Dictionary]:
	var weighted_pool: Array[Dictionary] = []
	for upgrade in pool:
		var weight = rarity_weights[upgrade.rarity]
		for i in weight:
			weighted_pool.append(upgrade)
	weighted_pool.shuffle()

	var selected: Array[Dictionary] = []
	var used_ids: Array[String] = []
	for candidate in weighted_pool:
		if candidate.id not in used_ids:
			selected.append(candidate)
			used_ids.append(candidate.id)
		if selected.size() >= count:
			break
	return selected

static func get_rarity_color(rarity: Rarity) -> Color:
	match rarity:
		Rarity.COMMON:
			return Color("b0b0b0")  # gray
		Rarity.RARE:
			return Color("4a9eff")  # blue
		Rarity.EPIC:
			return Color("a855f7")  # purple
		_:
			return Color.WHITE

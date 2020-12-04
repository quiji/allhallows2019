extends Node


var p = {
	#subway_werewolf_intro_played = true
	
	# GAME DEFAULTS
	subway_werewolf_intro_played = false
}

var bullets = {}
var current_bullet_type: int

var unloaded: bool = true
var solomon_health: float = 20.0

func _ready():
	add_bullet_type(Game.BulletTypes.Regular, -1)

	#add_bullet_type(Game.BulletTypes.Obsidian, -1)
	#add_bullet_type(Game.BulletTypes.Stronger, -1)
	#add_bullet_type(Game.BulletTypes.Silver, -1)

	current_bullet_type = Game.BulletTypes.Regular


func _process(delta):
	
	Console.add_log("solomon_health", solomon_health)
	Console.add_log("unloaded", unloaded)

func set_prop(prop: String, value) -> void:
	p[prop] = value

	
func get_prop(prop: String):
	return p[prop]

func has_prop(prop: String) -> bool:
	return p.has(prop)

func add_bullet_type(type: int, total_ammo: int) -> void:
	
	if bullets.has(type):
		bullets[type].ammo += total_ammo
	else:
		bullets[type] = {
			ammo = total_ammo
		}

func get_bullet_type_ammo(type: int) -> int:
	return bullets[type].ammo
	
func sub_bullet_type_ammo(type: int, amount: int):
	bullets[type].ammo -= amount

func add_bullet_type_ammo(type: int, amount: int):
	bullets[type].ammo += amount
	

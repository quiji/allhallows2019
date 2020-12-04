extends Node

var main = null
var level = null
var fx_master = null

################################
const DEV_MODE = false
################################

enum BulletTypes {Regular=0, Stronger, Obsidian, Silver}
enum ControllerTypes {Keyboard, Nintendo, Playstation, Xbox}


func _ready():
	if DEV_MODE:
		Console.active = true
	else:
		Console.active = false
	set_process(false)
	
	pause_mode = Node.PAUSE_MODE_PROCESS

func get_bullet_damage(bullet_type: int) -> float:
	
	match bullet_type:
		BulletTypes.Regular:
			return 1.0
		BulletTypes.Stronger:
			return 2.0
		BulletTypes.Obsidian:
			return 1.0
		BulletTypes.Silver:
			return 2.0
	
	return 0.0

func get_magazine_size(bullet_type: int) -> int:
	match bullet_type:
		BulletTypes.Regular:
			return 18
		BulletTypes.Stronger:
			return 10
		BulletTypes.Obsidian:
			return 14
		BulletTypes.Silver:
			return 6
	return 0

func gut_bullet_line_color(bullet_type: int, first: bool) -> Color:
	match bullet_type:
		BulletTypes.Regular:
			if first: 
				return Color("#eff77d")
			else:
				return Color("#ec6009")

		BulletTypes.Stronger:
			
			if first: 
				return Color("#96abab")
			else:
				return Color("#748790")

		BulletTypes.Obsidian:

			if first: 
				return Color("#3b2a5b")
			else:
				return Color("#2c112c")

		BulletTypes.Silver:
			if first: 
				return Color("#d5edd4")
			else:
				return Color("#3c348d")

			
	return Color("#ffffff")
	

func bullet_data(bullet_type: int) -> Dictionary:
	var result = {
		bullet_name = "",
		desc = ""
	}
	match bullet_type:
		BulletTypes.Regular:
			result.bullet_name = "Regular Bullets"
			result.desc = "Just some regular bullets, small size, average damage."
			
		BulletTypes.Stronger:
			result.bullet_name = "Big Bullets"
			result.desc = "Stronger bullets, bigger size, more damage."

		BulletTypes.Obsidian:
			result.bullet_name = "Obsidian Bullets"
			result.desc = "Bullets made of a strange black mineral. Very weak bullets that deal no damage to physical things."

		BulletTypes.Silver:
			result.bullet_name = "Silver Bullets"
			result.desc = "Made of silver that absorbed full moonlight for 10 years."

	result.magazine_size = get_magazine_size(bullet_type)

	return result



var freeze_timer: float = 0.0
var delay_timer: float = 0.0
func hit_freeze(how_much: float = 0.2, how_much_delay: float = 0.2):
	freeze_timer = how_much
	delay_timer = how_much_delay
	set_process(true)
	#get_tree().paused = true
	
func _process(delta):
	
	if delay_timer >= 0.0:
		delay_timer -= delta
		if delay_timer <= 0.0:
			get_tree().paused = true
	elif freeze_timer > 0.0:
		freeze_timer -= delta
	else:
		set_process(false)
		get_tree().paused = false
	


func get_input_type() -> int:
	var joys = Input.get_connected_joypads()
	
	
	if joys.size() == 0:
		return ControllerTypes.Keyboard
	else:
		
		var joy_name = Input.get_joy_name(joys[0])
		if joy_name.findn("nintendo") > -1:
			return ControllerTypes.Nintendo
		elif joy_name.findn("ps1") > -1 or joy_name.findn("ps2") > -1 or joy_name.findn("ps3") > -1:
			return ControllerTypes.Playstation
		elif joy_name.findn("xbox") > -1:
			return ControllerTypes.Xbox
			
		return ControllerTypes.Keyboard
	

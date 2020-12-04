extends CanvasLayer

signal screen_opened
signal screen_closed
signal item_prompt_finished

onready var bullet_bar = $hbox/bullets/bullet_bar
onready var health_bar = $hbox/health_bar
onready var text_bubble = $text_bubble
onready var blackout_screen = $blackout_screen
onready var anims: AnimationPlayer = $anims
onready var item_prompt = $item_prompt
onready var down_cue = $down_cue
onready var bullet_selection = $bullet_selection
onready var current_bullet = $hbox/current_bullet

export (NodePath) var player_node


var player = null



func _ready():
	
	blackout_screen.material.set_shader_param("blackness", 1.0)
	
	if player_node:
		player = get_node(player_node)
		
		player.get_gun().connect("magazine_change", self, "_on_magazine_change")
		player.get_gun().connect("magazine_reloaded", self, "_on_magazine_reloaded")
		player.get_gun().connect("bullet_shot", self, "_on_bullet_shot")
		player.get_gun().connect("must_reload", self, "_on_must_reload")
		player.connect("health_change", self, "_on_health_change")
		health_bar.health_ratio = player.get_health_ratio()
	
	text_bubble.connect("bubble_closed", self, "_on_bubble_closed")
	anims.connect("animation_finished", self, "_on_anim_finished")
	bullet_selection.connect("bullet_changed", self, "_on_bullet_changed")
	
	
	
func _on_magazine_change(ammo: int, type: int) -> void:
	bullet_bar.set_magazine(ammo, type)
	
func _on_magazine_reloaded(ammo: int, type: int) -> void:
	bullet_bar.set_magazine(ammo, type)
	current_bullet.stop_blink()


func _on_bullet_changed(bullet_type) -> void:
	current_bullet.bullet_type = bullet_type
	current_bullet.blink()

func _on_must_reload() -> void:
	current_bullet.blink()

func _on_bullet_shot() -> void:
	bullet_bar.shoot_bullet()

func _on_health_change(health_ratio: float) -> void:
	
	health_bar.health_ratio = health_ratio


func prompt_talk(pos: Vector2, msg: String) -> void:
	#player.blocked = true
	text_bubble.show_message(pos, msg)

func _on_bubble_closed() -> void:
	#player.blocked = false
	pass

func open_screen() -> void:
	anims.play("open_screen")

func close_screen() -> void:
	anims.play("close_screen")

func death_screen() -> void:
	anims.play("death_close_screen")
	Maestro.fade_out()

func _on_anim_finished(anim_name: String) -> void:
	
	if anim_name == "open_screen":
		emit_signal("screen_opened")
		
	if anim_name == "close_screen":
		emit_signal("screen_closed")

	if anim_name == "death_close_screen":
		get_tree().reload_current_scene()

	
func prompt_item(item: int, item_type:int, amount: int) -> void:
	
	
	item_prompt.prompt_item(item, item_type, amount)
	yield(item_prompt, "prompt_finished")
	emit_signal("item_prompt_finished")


func show_cue(who) -> void:
	down_cue.prompt(who)

func hide_cue(who) -> void:
	down_cue.stop()

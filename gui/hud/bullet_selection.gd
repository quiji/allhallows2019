extends CenterContainer

signal bullet_changed(which)

onready var bullet_list = $panel/bullet_icons/container/margins/bullet_list
onready var bullet_name_label = $panel/margins/vbox/bullet_info/bullet_name
onready var bullet_count = $panel/margins/vbox/bullet_info/size_bar/hbox/bullet
onready var magazine_count = $panel/margins/vbox/bullet_info/size_bar/hbox/magazines
onready var magazine_size = $panel/margins/vbox/bullet_info/size_bar/hbox/magazine_size
onready var lore_text = $panel/margins/vbox/lore/margin/text


var selected_icon = null
var sceen_opened: bool = false


func _ready():
	hide()

	for i in range(bullet_list.get_child_count()):
		var child = bullet_list.get_child(i)
		child.connect("icon_selected", self, "_on_icon_selected")
		child.connect("icon_focused", self, "_on_icon_focused")


func _unhandled_input(event):
	
	if event.is_action_pressed("change_magazine"):
		if not sceen_opened:
			show_grid()
		else:
			hide_grid()

	if event.is_action_pressed("ui_cancel") and sceen_opened:
		hide_grid()
		

func hide_grid() -> void:
	
	Console.count("sdfasdfasfasdfasdfhere")
	
		
	#anims.play("hide")
	#selected_icon.bounce()

	get_tree().paused = false
	sceen_opened = false
	hide()

func _on_icon_selected(bullet_type: int) -> void:

	GameState.current_bullet_type = bullet_type

	emit_signal("bullet_changed", bullet_type)

	if selected_icon != null:
		selected_icon.selected = false
		
	selected_icon = bullet_list.get_child(bullet_type)
	selected_icon.selected = true

	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().paused = false
	sceen_opened = false
	hide()


func _on_icon_focused(bullet_type: int) -> void:
	var data = Game.bullet_data(bullet_type)
	var extra_ammo: int = 0
	
	bullet_name_label.text = "    " +  data.bullet_name

	magazine_size.value = data.magazine_size
	if Game.level.player.gun.bullet_type == bullet_type and GameState.get_bullet_type_ammo(bullet_type) != -1:
		extra_ammo = Game.level.player.gun.ammo_count
	bullet_count.value = GameState.get_bullet_type_ammo(bullet_type) + extra_ammo
	
	if bullet_count.value > 0 and magazine_size.value > 0:

		magazine_count.value = bullet_count.value / magazine_size.value
		magazine_count.value += 1 if bullet_count.value % magazine_size.value else 0
	else:
		magazine_count.value = -1

	lore_text.clear()
	lore_text.append_bbcode(data.desc)


func show_grid() -> void:
	if selected_icon != null:
		selected_icon.selected = false

	for i in range(bullet_list.get_child_count()):
		if GameState.bullets.has(i):
			bullet_list.get_child(i).show()
		else:
			bullet_list.get_child(i).hide()

	
	selected_icon = bullet_list.get_child(GameState.current_bullet_type)
	selected_icon.selected = true
	selected_icon.grab_focus()


	#anims.play("show")
	#selected_icon.bounce()
	show()
	get_tree().paused = true
	sceen_opened = true
	

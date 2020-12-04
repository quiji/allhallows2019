extends CenterContainer


signal prompt_finished

onready var bullet_icon = $base/bkg/margins/container/bullet_icon
onready var text = $base/bkg/margins/container/text

func _ready():

	hide()
	
	set_process_unhandled_input(false)

func prompt_item(item: int, item_type:int, amount: int) -> void:
	
	match item:
		0:
			show()
			bullet_icon.bullet_type = item_type

			var data = Game.bullet_data(item_type)
			text.clear()
			text.append_bbcode("[b] Found " + str(amount) + " " + data.bullet_name + "[/b]!! \n\n")
			text.append_bbcode(data.desc + " \n\n")
			#text.append_bbcode(data.magazine_size)
			


	set_process_unhandled_input(true)
	
	
func _unhandled_input(event):
	
	
	if event.is_pressed():
		set_process_unhandled_input(false)
		hide()
		
		emit_signal("prompt_finished")
		


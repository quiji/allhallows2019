extends CharacterAction




func install() -> void:
	pass


func start(sub_state: String) -> void:

	actor.anims.play("SoldierIdle")
	
func end(new_state: String) -> void:
	pass

	
func run(delta: float) -> void:
	pass
	

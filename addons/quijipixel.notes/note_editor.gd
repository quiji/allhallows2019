tool
extends MarginContainer


func configure():
	$note_container/notes.add_color_region('>', '', Color(0.9, 0.5, 0.4), true)
	$note_container/notes.add_color_region('-', '', Color(0.4, 0.5, 0.9), true)
	$note_container/notes.add_color_region('*', '*', Color(0.9, 1, 0.9), true)

func set_notes(note):
	
	$note_container/notes.text = note

func get_notes():
	return $note_container/notes.text
	
	

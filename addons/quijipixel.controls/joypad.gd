
extends Node

export (float) var deadzone = 0.25

var device_id = 0

var left_joy = Vector2()
var right_joy = Vector2()

var buttons = {
	cross = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	square = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	triangle = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	circle = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	left1 = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	right1 = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	left2 = {
		just_pressed = false,
		just_released = false,
		pressed = false
	},
	right2 = {
		just_pressed = false,
		just_released = false,
		pressed = false
	}
}

func _update_button(btn, state):

	buttons[btn].just_pressed = not buttons[btn].pressed and state
	buttons[btn].just_released = buttons[btn].pressed and not state
	buttons[btn].pressed = state

func poll_input():
	
	left_joy = Vector2(Input.get_joy_axis(device_id, JOY_AXIS_0), Input.get_joy_axis(device_id, JOY_AXIS_1))
	right_joy = Vector2(Input.get_joy_axis(device_id, JOY_AXIS_2), Input.get_joy_axis(device_id, JOY_AXIS_3))

	var pad_length = left_joy.length()
	


	if pad_length < deadzone:
		left_joy = Vector2()
	else:
		left_joy = left_joy.normalized() * (pad_length - deadzone) / (1 - deadzone)
	
	pad_length = right_joy.length()

	if pad_length < deadzone:
		right_joy = Vector2()
	else:
		right_joy = right_joy.normalized() * (pad_length - deadzone) / (1 - deadzone)

	
	_update_button("cross", Input.is_joy_button_pressed(device_id, JOY_BUTTON_0))
	_update_button("circle", Input.is_joy_button_pressed(device_id, JOY_BUTTON_1))
	_update_button("square", Input.is_joy_button_pressed(device_id, JOY_BUTTON_2))
	_update_button("triangle", Input.is_joy_button_pressed(device_id, JOY_BUTTON_3))
	_update_button("left1", Input.is_joy_button_pressed(device_id, JOY_BUTTON_4))
	_update_button("right1", Input.is_joy_button_pressed(device_id, JOY_BUTTON_5))
	_update_button("left2", Input.is_joy_button_pressed(device_id, JOY_BUTTON_6))
	_update_button("right2", Input.is_joy_button_pressed(device_id, JOY_BUTTON_7))
	
	
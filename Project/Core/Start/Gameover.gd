extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed('clieck'):
		get_tree().change_scene("res://Core/Start/StartScreen.tscn")

extends Area2D

onready var EventManager = $".."

var walk_speed = 250
var movement

var cant_move = false

func _process(delta):
	if !cant_move:
		movement = Vector2()
		
		movement.x += int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
		movement.y += int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
		
		movement = movement.normalized()
		
		position += movement * walk_speed * delta

func _on_EventManager_lock_controls():
	cant_move = true


func _on_EventManager_unlock_controls():
	cant_move = false
extends KinematicBody2D



#CHILD NODES TO load
var footprints
var sprite
var area_2D


#EXPORTED
export(String) var facing = "south"
# 	north
# 	east
# 	south
# 	west
export(String) var animation_state



# 	idle
# 	walking
# 	hidden
var cover = null
var hide_speed = .2
export(String) var character_state = "normal"





#	normal
# 	locked
#	danger
#	involuntary
export(float) var speed = 4
export(float) var animation_speed = 0.1


export(float) onready var priority = 100
onready var type = Globals.DETECTABLE.PLAYER

#PRIVATES

var movement : Vector2 = Vector2(0,0)


export(float) var foot_print_distance = 20
var _last_foot_pos = Vector2(INF, INF)

var can_move = true
var hiding_place = null

func _ready():
	footprints = get_node("Footprints")
	sprite = get_node("sprite")
	area_2D = get_node("area_2D")
	add_to_group("detectable")



func _process(dt):
	if not Vectors.close_enough(_last_foot_pos, global_position, foot_print_distance):
		footprints.add(facing)
		_last_foot_pos = global_position
		
func _physics_process(dt):

	input_handler()

	match(character_state): #str comparison lol				
		"locked":
			pass
			#_player_set_locked()
		"danger":
			pass
			#_player_danger()
		"involuntary":
			pass
			#_player_involuntary()
		"hidden":
			_player_hidden()
					
		"enable_hide":    #DISPLAY UI HERE
			_player_enable_hide()
			_player_normal()

		"normal":
			_player_normal()	

			
			#_player_involuntary()

func input_handler():

	movement = Vector2(0, 0)

	#movement input
	if Input.is_action_pressed("player_up"):
		animation_state = "walking"
		facing = "north"
		movement.y -= 1

	if Input.is_action_pressed("player_down"):
		animation_state = "walking"
		facing = "south"
		movement.y += 1

	if Input.is_action_pressed("player_left"):
		animation_state = "walking"
		facing = "west"
		movement.x -= 1

	if Input.is_action_pressed("player_right"):
		animation_state = "walking"
		facing = "east"
		movement.x += 1

	#NO net movement
	if movement ==Vector2(0,0):
		animation_state = "idle"
		movement = Vector2(0,0)


	movement = movement.normalized()

func _player_lock():
	character_state = "hidden"

func _player_unlock():
	character_state = "normal"

func _player_set_visible():
	$sprite.visible = true

func _player_set_invisible():
	$sprite.visible = false


#states
func _player_normal():
	move_and_slide(movement * 250)
	pass

func _player_danger_update():
	#no movement
	pass

func _player_enable_hide_update():
	if Input.is_action_just_released("ui_accept"):
		player_hide()


func _player_hidden():
	if Input.is_action_just_released("ui_accept"):
		init_state("normal")


func _physics_process(dt):
	update_state(character_state)

func update_state(state):
	
	input_handler()

	match(state):
		"locked":
			pass
			#_player_set_locked()
		"danger":
			pass
			#_player_danger()
		"involuntary":
			pass
			#_player_involuntary()
		"hidden":
			_player_hidden_update()
					
		"enable_hide":    #DISPLAY UI HERE\
			_player_normal_update()	
			_player_enable_hide_update()

		"normal":
			_player_normal_update()	



func init_state(state, args=[]):
	if state == character_state:
		return 
		
	character_state = state					
					
	match(state):
		"locked":
			pass
			#_player_set_locked()
		"danger":
			pass
			#_player_danger()
		"involuntary":
			pass
			#_player_involuntary()
		"hidden":
			pass
						
		"enable_hide":    #DISPLAY UI HERE
			self.cover = args[0]
			
			#continue #also do normal movement
		"normal":
			priority = 100
			cover.z_index = 0
			self.cover = null
			pass


func player_hide():
	$HideTween.interpolate_property(self, "global_position", global_position, cover.global_position, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$HideTween.start()
	character_state = "hiding"
	can_move = false
	cover.z_index = 4
	priority = -1

func _player_lock():
	init_state('locked')

func _player_unlock():
	init_state('normal')

func _on_HideTween_tween_completed(object, key):
	character_state = "hidden"
	


func _on_area_2D_area_exited(area):
	if area.get_parent() == cover:
		cover = null
		add_to_group("detectable")
		character_state = "normal"

extends KinematicBody2D

onready var tween = $Tween
onready var camera = get_node('../Camera2D')
onready var cam_tween = camera.get_node('Tween')

export (int) var speed = 200

var velocity = Vector2()

func _ready():
	print('Player\'s position: ', self.global_position)
	
func _process(_delta):
	pass

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		
	velocity = velocity.normalized() * speed


#func _on_Camera2D_boundary_broken():
#	self.global_position.x += 10
#	print('Player\'s new position: ', self.global_position)

func _on_Area2D_body_entered(body):
	
#	print('There\'s a Player in here!')
#	pause()
	tween.interpolate_property(
		body, 
		"position",
		body.position.x, 
		body.position.x + 300, 
		1,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT)

	tween.start()


func pause() -> void:
	print('Player should be paused')
	set_physics_process(false)
	set_process_unhandled_input(false)
	
func unpause() -> void:
	print('Player should unpause now')
	set_physics_process(true)
	set_process_unhandled_input(true)

#func _on_Tween_tween_all_completed():
#	unpause()

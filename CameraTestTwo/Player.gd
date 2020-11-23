extends KinematicBody2D

onready var tween = $Tween

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

func start_transition_tween():
	
	tween.interpolate_property(
		self, 
		"position",
		self.position, 
		Vector2(get_node('../ViewContainer/View2').get_global_rect().position.x + 35, self.position.y), 
		1,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)

	tween.start()

func pause() -> void:
	print('Player should be paused')
	set_physics_process(false)
	set_process_unhandled_input(false)
	
func unpause() -> void:
	print('Player should unpause now')
	set_physics_process(true)
	set_process_unhandled_input(true)


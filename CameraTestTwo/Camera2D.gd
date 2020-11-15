extends Camera2D

signal transition_done

export (float) var transition_time
export (float) var start_delay

onready var default = self.get_viewport()
onready var player = get_node('../Player')
onready var vc = get_node('../ViewContainer')
onready var view2 = vc.get_node("View2")
onready var tween = $Tween
onready var process_value: bool = true


func _ready():
	set_process(true)
	set_camera_limits(vc.CAMERA_LIMIT_LEFT, vc.CAMERA_LIMIT_RIGHT, vc.CAMERA_LIMIT_TOP, vc.CAMERA_LIMIT_BOTTOM)

func _process(_delta):
	_move_to_target_paths_positions()


func set_camera_limits(l, r, t, b):
	self.limit_left = l
	self.limit_right = r
	self.limit_top = t
	self.limit_bottom = b
	
func _move_to_target_paths_positions():
	# This has a lot more going on in the original Megaman script, but there it's looking for Control nodes as
	# well for some reason. This just sets the camera's own position to that of the "follow_path", in this
	# case the player. The old script also had follow_path as an export variable for whatever reason.  
	var g_pos : Vector2 = player.get_global_position()
	self.global_position = g_pos


func _on_Area2D_body_entered(body):
	print('Camera tween should be starting now')
	# This is the part that moves the camera's global coordinates. I don't know how this should follow the player
	# or not - i think the Megaman script handles this with the "is_screen_transitioning?" function. 
	
	### Things to try turning off while transitioning ###
#	self.smoothing_enabled = false
#	remove_camera_limits()
#	process_value = false
#	set_process(false)
#	self.current = false
	player.pause()
	### ###
	
	start_transition_tween()
	
	yield(tween, "tween_started")
	remove_camera_limits()
	
	yield(tween, "tween_all_completed")
	tween_done()
	
	emit_signal("transition_done")

func remove_camera_limits() -> void:
	print('Removing camera\'s limits')
	self.limit_left = -10000000
	self.limit_right = 10000000
	self.limit_top = -10000000
	self.limit_bottom = 10000000
	
func start_transition_tween():
	
	tween.stop_all()
	
#	print('Player\'s global position: ', player.global_position)
#	print('Camera\'s global position: ', self.global_position)
#	print('Camera\'s "position" vs. its global position: ', self.position)
#	print('Camera\'s \"screen center\": ', self.get_camera_screen_center())
#	print('Viewport\'s size: ', get_viewport_rect())
#	print('The visible viewport rect: ', get_visible_rect())
	
		
	tween.interpolate_property(
		self,
		"limit_right",
		self.limit_right,
		view2.get_global_rect().position.x + view2.get_rect().size.x,
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		start_delay)
		
	tween.interpolate_property(
		self,
		"limit_left",
		self.limit_left,
		view2.get_global_rect().position.x, 
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		start_delay)

	tween.interpolate_property(
		self,
		"limit_top",
		self.limit_top,
		view2.get_global_rect().position.y,
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		start_delay)

	tween.interpolate_property(
		self,
		"limit_bottom",
		self.limit_bottom,
		view2.get_global_rect().position.y + view2.get_rect().size.y,
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		start_delay)
		
	# This part moves the camera itself... I think.
	tween.interpolate_property(
		self, 
		"position",
		self.position, 
		self.global_position.x + get_viewport_rect().size.x, 
		transition_time,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT)
		
		
	tween.start()
	
func tween_done():
	process_value = true
	vc.update_current_view(self)
	player.unpause()

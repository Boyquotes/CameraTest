extends Control

# To-do: need a way to determine which view container the character or camera is currently in.
# They'll hit a transition boundary and be teleported to the next view. Later, I'll make a transition
# using tweens to make it look nice.

# Could have a for loop that makes an array listing all the View children, and then another with
# tuples of their coordinates, and then... some other code that continuously references the player's
# global coordinates to know what View they're in. Although, it would be simpler to just know that they've entered
# the view once, which could be done with a signal. And, once the transitions are added, they'll be the ones
# signaling to update the View. Hmmmm. This could also all go in a global script.

# Really all I need this where-am-I knowledge for is to update the camera limits. I could just hardcode
# those into every transition area. An export variable for whether it's up-down or left-right, and export
# for whether it's one-way (or just overlap two areas), and then make the ween part of the scene without 
# the information for which view to which view one's transitioning (and hard-code that myself). 

# I'm starting to get the feeling that most of this should be in a global script to keep track of the 
# current global position of the camera without having to do parent-child-sister lookups. I have to make an onready var
# now to look BACK at the camera's coordinates reflexively when the camera's just signaled this node... messy. 

onready var CAMERA_LIMIT_LEFT : float
onready var CAMERA_LIMIT_RIGHT : float
onready var CAMERA_LIMIT_TOP : float
onready var CAMERA_LIMIT_BOTTOM : float

onready var view1 = $View1
onready var view2 = $View2
onready var camera = get_node('../Camera2D')

onready var current_view = view1
onready var coord_dict = create_view_coordinate_array()

func _ready():
	update_camera_limits(view1)
	pass


func update_camera_limits(view):
	CAMERA_LIMIT_LEFT = view.get_global_rect().position.x
	CAMERA_LIMIT_TOP = view.get_global_rect().position.y
	CAMERA_LIMIT_RIGHT = view.get_global_rect().position.x + view.rect_size.x
	CAMERA_LIMIT_BOTTOM = view.get_global_rect().position.y + view.rect_size.y
	
func create_view_coordinate_array():
	# This will presumably only be called once at _ready() to create the coordinate map for every View.
	# The views themselves will, perhaps unfortunately, be set manually in the editor. 
	var coord_dict = {}
	for i in self.get_children():
		print('Coordinates for ', i.name, ':')
		print('Left: ', i.get_global_rect().position.x, ' Top: ', i.get_global_rect().position.y)
		print('Right: ', i.get_global_rect().position.x + i.rect_size.x, ' Bottom: ', i.get_global_rect().position.y + i.rect_size.y)
		coord_dict[i.name] = [i.get_global_rect().position.x, i.get_global_rect().position.y, i.get_global_rect().position.x + i.rect_size.x, i.get_global_rect().position.y + i.rect_size.y]
	return coord_dict

func update_current_view(camera: Camera2D):
	var x = camera.get_camera_position().x
	var y = camera.get_camera_position().y
#	print('Camera\'s current coordinates in update_current_view: (', x, ',',y,')')
	for key in coord_dict.keys():
#		print(key, ' value 0: ', coord_dict[key][0])
		if x > coord_dict[key][0] and y > coord_dict[key][1] and x < coord_dict[key][2] and y < coord_dict[key][3]:
			current_view = key
#	print('Current view: ', current_view)

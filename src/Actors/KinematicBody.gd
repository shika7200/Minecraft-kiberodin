extends KinematicBody
var speed = 10
var sensitivity = 0.1


func _input(event):
	if event as InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity 
		rotation_degrees.x -= event.relative.y * sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -89, 89)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _process(delta):
	var move_vector = Vector3.ZERO
	
	if(!is_on_floor()):
		move_and_slide(Vector3(0,-1,0)*10 , Vector3(0,1,0))
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor()):
			move_and_slide(Vector3(0,1,0)*200)
		
	if Input.is_action_pressed("left"):
		move_vector.x -= 1
	if Input.is_action_pressed("right"):
		move_vector.x += 1
	if Input.is_action_pressed("forward"):
		move_vector.z -= 1
	if Input.is_action_pressed("back"):
		move_vector.z += 1
	#if move_vector.lenght() > 1:
	#	move_vector = move_vector.normolized()
	if move_vector != Vector3.ZERO:
		var move_direction = global_transform.basis.xform(move_vector)
		move_and_slide(move_direction* speed)


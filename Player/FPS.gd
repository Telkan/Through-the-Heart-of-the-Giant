extends KinematicBody

var speed = 7
const ACCEL_DEFAULT = 20
const ACCEL_AIR = 10
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.2
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _physics_process(delta):
	
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("s") - Input.get_action_strength("z")
	var h_input = Input.get_action_strength("d") - Input.get_action_strength("q")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()

	var grapplingPull = $Head/GrappleCast.calcGrappling()

	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		if grapplingPull == Vector3.ZERO:
			gravity_vec += Vector3.DOWN * gravity * delta
		
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	#movement += grapplingPull
	velocity += grapplingPull
	if grapplingPull == Vector3.ZERO:
		move_and_slide_with_snap(movement, snap, Vector3.UP)
		
	else:
		move_and_slide(movement, Vector3.UP)
		gravity_vec = Vector3.ZERO
		
	camera.set_as_toplevel(true)
	camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
	camera.rotation.y = rotation.y
	camera.rotation.x = head.rotation.x
	
	

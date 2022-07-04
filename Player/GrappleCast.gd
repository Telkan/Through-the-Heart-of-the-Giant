extends RayCast
onready var player = get_parent().get_parent()
onready var grappleOrient = get_parent().find_node("GrappleOrientation")
onready var grapple = grappleOrient.find_node("Grapple")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grapplingTarget = Vector3.INF
var grapplingSpeed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if(Input.is_action_just_pressed("GrapG")):
		grapple.set_visible(true)
		if(is_colliding()):
			grapplingTarget = get_collision_point()
	if(Input.is_action_pressed("GrapG")):
		grapplingSpeed += 1 *_delta
	if(Input.is_action_just_released("GrapG")):
		grapple.set_visible(false)
		grapplingTarget = Vector3.INF
		grapplingSpeed = 5
		
	pass # Replace with function body.
	
func drawGrapple():
	grappleOrient.look_at(grapplingTarget,Vector3.UP)
	var length = grapplingTarget.distance_squared_to(player.global_transform.origin)
	grapple.height = length
	grapple.translation.z = length/2
	

func calcGrappling() -> Vector3:
	if grapplingTarget == Vector3.INF:
		return Vector3.ZERO
	drawGrapple()
	
	var direction : Vector3 = (grapplingTarget - player.global_transform.origin).normalized()
	return direction * grapplingSpeed

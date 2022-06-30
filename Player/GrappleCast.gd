extends RayCast
onready var player = get_parent().get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grapplingTarget = Vector3.INF
var grapplingSpeed = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if(Input.is_action_just_pressed("GrapG")):
		if(is_colliding()):
			grapplingTarget = get_collision_point()
	if(Input.is_action_pressed("GrapG")):
		grapplingSpeed += 4 *_delta
	if(Input.is_action_just_released("GrapG")):
		grapplingTarget = Vector3.INF
		grapplingSpeed = 20
		
	pass # Replace with function body.
	
	
func calcGrappling() -> Vector3:
	if grapplingTarget == Vector3.INF:
		return Vector3.ZERO
	var direction : Vector3 = (grapplingTarget - player.global_transform.origin).normalized()
	return direction * grapplingSpeed

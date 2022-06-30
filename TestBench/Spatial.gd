extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if($FPS/Head/GrappleCast.is_colliding()):
		$Marker.global_transform.origin = $FPS/Head/GrappleCast.get_collision_point()
	pass

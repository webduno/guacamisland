extends Area

var speed = 10
var coco_gravity = 30

func _physics_process(delta):
	translate(transform.basis.z * speed * delta)
	translate(transform.basis.y * gravity * delta)

func _on_Spatial_body_entered(body):
	queue_free()

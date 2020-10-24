extends KinematicBody2D

var speed = 50
export var direction = 1
export var dectects_cliffs = true
var velocity = Vector2(0,0)

func _ready():
	if direction == -1:
		scale.x = -1
	$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floorchecker.enabled = dectects_cliffs

func _physics_process(delta):
	
	if is_on_wall() or not $floorchecker.is_colliding() and dectects_cliffs and is_on_floor():
		direction = direction * -1
		scale.x *= -1
		$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		$side_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = direction * speed
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_side_checker_body_entered(body):
	get_tree().change_scene(".")


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("reddead")
	speed = 0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4,false)
	$top_checker.set_collision_mask_bit(0,false)
	$side_checker.set_collision_layer_bit(4,false)
	$side_checker.set_collision_mask_bit(0,false)
	$top_checker/Timer.start()


func _on_Timer_timeout():
	queue_free()

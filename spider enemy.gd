extends KinematicBody2D

var speed = 50
export var direction = 1
export var dectects_cliffs = true
var velocity = Vector2(0,0)

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floorchecker.enabled = dectects_cliffs

func _physics_process(delta):
	
	if is_on_wall() or not $floorchecker.is_colliding() and dectects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floorchecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = direction * speed

	velocity = move_and_slide(velocity,Vector2.UP)

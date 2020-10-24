extends KinematicBody2D

var speed = 150
export var direction = 1
export var ACCELERATION = 300
export var MAX_SPEED = 150
export var FRICTION = 200

onready var sprite = $AnimatedSprite
onready var PlayerDetectionZone = $PlayerDetectionZone

export var dectects_cliffs = true
var velocity = Vector2(0,0)
enum{
	CHASE
}
var state = CHASE

func _ready():
	if direction == -1: 
		$AnimatedSprite.flip_h = true 
		$floorchecker.position = $CollisionShape2D.shape.get_extents().x * direction 
		$floorchecker.enabled = dectects_cliffs

#Cliff Detector
func _physics_process(delta):
	
	if is_on_wall() or not $floorchecker.is_colliding() and dectects_cliffs and is_on_floor(): 
		direction = direction * -1 
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h 
	
	velocity.y += 20
	
#Player Follower Code
	match state:
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("greendead")
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


func _on_side_checker_body_entered(body):
	get_tree().change_scene("res://Level1.tscn")

extends KinematicBody2D

var speed = 150
export var direction = 1
export var ACCELERATION = 300
export var MAX_SPEED = 150
export var FRICTION = 200

onready var sprite = $AnimatedSprite
onready var PlayerDetectionZone = $PlayerDetectionZone

var velocity = Vector2.ZERO
enum{
	IDLE,
	WANDER,
	CHASE
}
var state = CHASE


func _ready():
	if direction == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	if is_on_wall():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = PlayerDetectionZone.player
			if player != null:
				direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
				
	velocity = move_and_slide(velocity)
	
func seek_player():
	if PlayerDetectionZone.can_see_player():
		state = CHASE


func _on_top_checker_body_entered(body):
	$AnimatedSprite.play("browndead")
	speed = 0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4,false)
	$top_checker.set_collision_mask_bit(0,false)
	$top_checker/Timer.start(1)

func _on_Timer_timeout():
	queue_free()


func _on_side_checker_body_entered(body):
	get_tree().change_scene(".")

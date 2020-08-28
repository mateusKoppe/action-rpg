extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const FRICTION = 2
const ACCELERATION = 3
const MAX_SPEED = 60

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_colision = $SoftColision
onready var wander_control = $WanderControl
onready var animation_player = $AnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
			seek_player()
			if wander_control.get_time_left() == 0:
				update_wander()
			
		WANDER:
			seek_player()
			if wander_control.get_time_left() == 0:
				update_wander()
	
			if global_position.distance_to(wander_control.target_position) <= MAX_SPEED / 10:
				update_wander()
				
			accelerate_towards_point(wander_control.target_position)
				
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position)
			else:
				state = IDLE
				
	if (soft_colision.is_coliding()):
		velocity += soft_colision.get_push_vector() * 5
	velocity = move_and_slide(velocity)
			
func accelerate_towards_point(point):
	var direction =  global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	sprite.flip_h = velocity.x < 0
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_control.start_wander_timer(rand_range(1, 3))
	
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invencibility(.4)
	knockback = area.knockback_vector * 135

func _on_Stats_no_health():
	var enemy_death_effect = EnemyDeathEffect.instance()
	enemy_death_effect.position = position
	get_parent().add_child(enemy_death_effect)
	queue_free()


func _on_Hurtbox_invencibility_started():
	animation_player.play("Start")

func _on_Hurtbox_invencibility_ended():
	animation_player.play("Stop")

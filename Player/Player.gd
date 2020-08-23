extends KinematicBody2D

const ACCELERATION = 5
const FRICTION = 5
const ROLL_SPEED = 100
const MAX_SPEED = 80

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			state_move()
		
		ATTACK:
			state_attack()
			
		ROLL:
			state_roll()

func state_move():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func state_attack():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func state_roll():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	velocity = velocity * .4
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	state = MOVE
	
func attack_animation_finished():
	state = MOVE

extends Area2D

signal invencibility_started
signal invencibility_ended

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer
onready var colision_shape = $CollisionShape2D

var invencible = false setget set_invencible

func create_hit_effect():
	var hit_effect = HitEffect.instance()
	hit_effect.global_position = global_position
	var world = get_tree().current_scene
	world.add_child(hit_effect)
	
func start_invencibility(duration):
	timer.start(duration)
	self.invencible = true
	
func set_invencible(value):
	invencible = value
	if invencible:
		emit_signal("invencibility_started")
	else:
		emit_signal("invencibility_ended")

func _on_Timer_timeout():
	self.invencible = false	

func _on_Hurtbox_invencibility_started(): 
	colision_shape.set_deferred("disabled", true)

func _on_Hurtbox_invencibility_ended():
	colision_shape.set_deferred("disabled", false)

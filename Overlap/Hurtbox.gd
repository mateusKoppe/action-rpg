extends Area2D

export var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var hit_effect = HitEffect.instance()
		hit_effect.global_position = global_position
		var world = get_tree().current_scene
		world.add_child(hit_effect)

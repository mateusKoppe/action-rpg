extends Camera2D

onready var top_left = $limits/topLeft
onready var bottom_right = $limits/bottomRight

func _ready():
	limit_top = top_left.global_position.y
	limit_left = top_left.global_position.x
	limit_bottom = bottom_right.global_position.y
	limit_right = bottom_right.global_position.x

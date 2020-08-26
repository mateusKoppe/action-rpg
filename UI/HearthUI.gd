extends Control

const TEXTURE_RECT_SIZE = 15

var hearts setget set_hearts
var max_hearts setget set_max_hearts

func set_hearts(value):
	hearts = value
	$HealthTexture.rect_size.x = value * TEXTURE_RECT_SIZE
	
func set_max_hearts(value):
	max_hearts = value
	$MaxHealthTexture.rect_size.x = value * TEXTURE_RECT_SIZE

func _ready():
	self.hearts = PlayerStats.health
	self.max_hearts = PlayerStats.max_health
	
	PlayerStats.connect('health_changed', self, 'set_hearts')
	PlayerStats.connect('max_health_changed', self, 'set_max_hearts')

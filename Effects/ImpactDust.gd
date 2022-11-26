extends AnimatedSprite
var pos=Vector2(0,0)
func _ready():
	frame=0
	position=pos
	playing=true
func _on_AnimatedSprite_animation_finished():
	call_deferred("queue_free")

extends AnimatedSprite
var pos=Vector2.ZERO
func _ready():
	position=Vector2(pos.x-10,pos.y)
	playing=true
func _on_AnimatedSprite_animation_finished():
	call_deferred("queue_free")

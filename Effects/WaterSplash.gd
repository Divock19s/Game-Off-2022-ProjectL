extends AnimatedSprite
func _ready():
	playing=true
func _on_AnimatedSprite_animation_finished():
	call_deferred("queue_free")

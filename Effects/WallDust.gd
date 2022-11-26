extends AnimatedSprite
var flipp=1
var pos=Vector2(0,0)
func _ready():
	if flipp==1:
		flip_v=false
		position=Vector2(pos.x+1.5,pos.y-13)
	else:
		flip_v=true
		position=Vector2(pos.x+7.5,pos.y-13)
	playing=true
func _on_AnimatedSprite_animation_finished():
	call_deferred("queue_free")

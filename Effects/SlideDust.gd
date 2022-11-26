extends AnimatedSprite
var flipp=1
var pos=Vector2(0,0)
func _ready():
	if flipp==-1:
		flip_h=true
		position=Vector2(pos.x+0,pos.y-1)
	else:
		flip_h=false
		position=Vector2(pos.x-15,pos.y-1)
	playing=true
func _on_AnimatedSprite_animation_finished():
	call_deferred("queue_free")

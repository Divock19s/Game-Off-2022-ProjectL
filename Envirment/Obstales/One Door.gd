extends Node2D
export (bool) var open =false
var work = true
func _ready():
	if open:
		$Door/Sprite.frame=3
		$Handle/AnimatedSprite.frame=2
		$Door/CollisionShape2D.set_deferred("disabled",true)
	else:
		$Door/Sprite.frame=0
		$Handle/AnimatedSprite.frame=0
		$Door/CollisionShape2D.set_deferred("disabled",false)
		

func _open():
	$AudioStreamPlayer2.play()
	if work:
		if open:
			$AnimationPlayer.play("Close")
			$Handle/AnimatedSprite.play("Close")
			open=false
		else:
			$AnimationPlayer.play("Open")
			$Handle/AnimatedSprite.play("Open")
			open=true
		work = false


func _on_AnimationPlayer_animation_finished(anim_name):
	work = true

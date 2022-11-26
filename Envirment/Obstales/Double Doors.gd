extends Node2D
export (bool) var open =false
var work = true
func _ready():
	if open:
		$Door/Sprite.frame=3
		$Door/CollisionShape2D.set_deferred("disabled",true)
		$Door2/Sprite.frame=0
		$Door2/CollisionShape2D.set_deferred("disabled",false)
		$Handle/AnimatedSprite.frame=2
	else:
		$Door/Sprite.frame=0
		$Door/CollisionShape2D.set_deferred("disabled",false)
		$Door2/Sprite.frame=3
		$Door2/CollisionShape2D.set_deferred("disabled",true)
		$Handle/AnimatedSprite.frame=0
		

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

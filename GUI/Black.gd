extends CanvasLayer

func _ready():
	$ColorRect.modulate=Color8(0,0,0,255)
	$AnimationPlayer.play("New Anim")

func _on_AnimationPlayer_animation_finished(anim_name):
	call_deferred("queue_free")

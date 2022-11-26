extends Area2D
onready var explo=preload("res://Envirment/Explosion.tscn")
func _ready():
	$AnimatedSprite.play("Idle")
	if Global.diamonds>=1:
		call_deferred("queue_free")
func _on_Area2D_body_entered(body):
	if "Player" in body.name and Global.diamonds == 0:
		Global.posa="check"
		Global.glo_pos=body.global_position
		var r = explo.instance()
		r.global_position=global_position
		r.modulate=Color8(79,195,247)
		get_parent().add_child(r)
		if Global.progress<2:
			Global.progress=2
		body.diamonds=1
		Global.progress+=1
		$AnimatedSprite.play("Collect")
		Global._save()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.frame==8:
		call_deferred("queue_free")

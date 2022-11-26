extends Area2D
onready var explo=preload("res://Envirment/Explosion.tscn")
func _ready():
	if Global.diamonds>=4:
		$AnimatedSprite.play("Idle")
		call_deferred("queue_free")
func _on_Area2D_body_entered(body):
	if "Player" in body.name and Global.diamonds == 3:
		Global.posa="check"
		Global.glo_pos=body.global_position
		var r = explo.instance()
		r.global_position=global_position
		r.modulate=Color8(247,81,79)
		get_parent().add_child(r)
		if Global.progress<5:
			Global.progress=5
		Global.diamonds=4
		body.diamonds=4
		$AnimatedSprite.play("Collect")
		Global._save()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.frame==8:
		call_deferred("queue_free")

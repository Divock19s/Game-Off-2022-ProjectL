extends Area2D
onready var explo=preload("res://Envirment/Explosion.tscn")
func _ready():
	$AnimatedSprite.play("Idle")
func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		if body.health<4:
			$CollisionShape2D.set_deferred("disabled",true)
			var r = explo.instance()
			r.global_position=global_position
			r.modulate=Color8(247,81,79)
			get_parent().add_child(r)
			body.health+=1
			$AnimatedSprite.play("Collect")
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.frame==6:
		call_deferred("queue_free")

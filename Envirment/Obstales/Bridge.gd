extends StaticBody2D

export (bool) var broken = false

func _ready():
	if broken:
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		$CollisionShape2D.set_deferred("disabled",true)

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		$AudioStreamPlayer.play()
		body._shake(1,15,3,1)
		$AnimationPlayer.play("Fall")
		$Area2D/CollisionShape2D.set_deferred("disabled",true)


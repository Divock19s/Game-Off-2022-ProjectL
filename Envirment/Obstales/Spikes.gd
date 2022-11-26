extends Area2D
export (int) var up=150

func _on_Spikes_body_entered(body):
	if "Player" in body.name:
		body._kill(0,1,up)
		$CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
	if body.is_in_group("enemies"):
		if body.has_method("_piece"):
			body._piece()


func _on_Timer_timeout():
		$CollisionShape2D.set_deferred("disabled",false)

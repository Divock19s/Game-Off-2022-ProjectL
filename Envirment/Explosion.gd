extends Particles2D
func _ready():
	$Timer.start()
	emitting=true
func _on_Timer_timeout():
	call_deferred("queue_free")

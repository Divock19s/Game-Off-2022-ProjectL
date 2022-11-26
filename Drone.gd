extends AnimatedSprite

onready var effect=preload("res://Effects/DroneEffect.tscn")
onready var player=get_parent().get_node("Player")

var speed = 0.01
func _ready():
	pass # Replace with function body.

func _process(_delta):
	var distance = global_position.distance_to(player.global_position)
	if distance<100:
		if speed !=0.02:
			speed = 0.02
	elif distance<50:
		if speed !=0.005:
			speed = 0.005
	if distance>30:
		global_position=lerp(global_position,player.global_position,speed)

func _on_Drone_animation_finished():
	var b=effect.instance()
	b.pos=global_position
	get_parent().add_child(b)

extends Node2D
export (PackedScene) var Explosion1Scene
export (PackedScene) var Explosion2Scene
export (PackedScene) var Explosion3Scene
export (bool) var using_3
export (float) var timer_1_time
export (float) var timer_2_time
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var Explosion1 = Explosion1Scene.instance()
	Explosion1.position.x += 10
	add_child(Explosion1)
	$Timer.wait_time = timer_1_time
	$Timer.start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var Explosion2 = Explosion1Scene.instance()
	Explosion2.position.x -= 80
	add_child(Explosion2)
	if (using_3):
		$Timer2.wait_time = timer_2_time
		$Timer2.start()


func _on_LifeTime_timeout():
	queue_free()


func _on_Timer2_timeout():
	var Explosion3 = Explosion1Scene.instance()
	Explosion3.position.x += 70
	add_child(Explosion3)

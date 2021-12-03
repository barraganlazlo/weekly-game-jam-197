extends Area2D



func _on_SpikesArea2D_body_entered(body):
	Globals.launchingstatemachine.die();

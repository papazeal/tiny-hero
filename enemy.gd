extends Area2D
class_name Enemy

@onready var flashAnimation = $flashAnimation
var hp:int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hp == 0:
		queue_free()
	pass
	
func get_hit():
	flashAnimation.play("flash")
	hp -= 1
	pass

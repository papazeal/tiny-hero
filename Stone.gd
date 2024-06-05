extends Area2D

@export var state:bool = true

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !state:
		toggle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func toggle():
	
	if collision_layer == 0:
		collision_layer = 8
		sprite.show()
	else:
		collision_layer = 0
		sprite.hide()

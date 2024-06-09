extends Node2D

@onready var tile:TileMap = $TileMap
const EnemyScene = preload("res://Enemy.tscn")
var enemy_set = []

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemy()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func spawn_enemy():
	var cell = tile.local_to_map(Vector2(120,480))
	var pos = tile.map_to_local(cell)
	var e = EnemyScene.instantiate()
	enemy_set.append(e)
	e.position = pos
	self.add_child(e)
	pass

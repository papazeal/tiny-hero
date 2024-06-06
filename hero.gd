extends Area2D
signal hit

@export var move_slide = true

@onready var tile_map: TileMap = $"../TileMap"
@onready var sprite_container = $sp
@onready var sprite = $sp/sp2d
@onready var sfx_jump = $sfx_jump
@onready var ray = $RayCast2D
@onready var end_text = $end_text
@onready var animation = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D

var is_moving = false
var next_position = null
var check_point_tile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# init checkpoint
	check_point_tile = tile_map.local_to_map(global_position)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# stop at current tile if hit with stone
	if is_moving and ray.is_colliding():
		ray.enabled = false
		next_position = tile_map.map_to_local(tile_map.local_to_map(global_position))
		
	# user input
	if is_moving:
		return
		
	if Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
		sprite.flip_h = false
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
		sprite.flip_h = true
	
func _physics_process(delta):
	if sprite.scale != Vector2(1,1):
		sprite.scale.x = move_toward(sprite.scale.x, 1, 3*delta)
		sprite.scale.y = move_toward(sprite.scale.y, 1, 3*delta)
	
	if !is_moving:
		return
	
	if global_position == next_position:
		next_position = null
		is_moving = false
		return
	
	global_position = global_position.move_toward(next_position, 180*delta)
	

func move(direction: Vector2i):
	
	#get current tile
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	#get target tile
	var target_tile: Vector2i = current_tile
	#var walkable = false
	if move_slide:
		while tile_map.get_cell_tile_data(0, target_tile + direction):
			target_tile += direction
	else:
		if tile_map.get_cell_tile_data(0, target_tile + direction):
			target_tile += direction
	
	
	
	# start moving
	next_position = tile_map.map_to_local(target_tile)
	if direction == Vector2i.UP or direction == Vector2i.DOWN:
		sprite.scale = Vector2(0.6,1.5)
	else:
		sprite.scale = Vector2(1.5, 0.6)
		
	#set ray direction
	ray.target_position = direction * 16
	ray.enabled = true
	
	if target_tile == current_tile:
		return
	
	sfx_jump.pitch_scale = 1
	sfx_jump.play()
	
	is_moving = true
	print_debug('current tile', current_tile)
	print_debug('target tile', target_tile)
	
		
	
func reborn():
	global_position = tile_map.map_to_local(check_point_tile)
	next_position = global_position
	pass


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
var swipe_start = null
var minimum_drag = 15

func _unhandled_input(event):
	if is_moving:
		return
		
	if event.is_action_pressed("click"):
		swipe_start = event.get_position()
	if event.is_action_released("click"):
		_calculate_swipe(event.get_position())

func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag and abs(swipe.x) > abs(swipe.y):
		if swipe.x > 0:
			move(Vector2.RIGHT)
		else:
			move(Vector2.LEFT)
	if abs(swipe.y) > minimum_drag and abs(swipe.y) > abs(swipe.x):
		if swipe.y > 0:
			move(Vector2.DOWN)
		else:
			move(Vector2.UP)



func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		sfx_jump.pitch_scale = 2
		sfx_jump.play()
		area.queue_free()
		print_debug('coin hit')
	if area.get_collision_layer_value(3):
		sfx_jump.pitch_scale = 0.5
		sfx_jump.play()
		reborn()
		print_debug('fire hit')
	if area.get_collision_layer_value(4):
		sfx_jump.pitch_scale = 0.5
		sfx_jump.play()
		print_debug('checkpoint hit')
	if area.get_collision_layer_value(5):
		sprite.scale = Vector2(1.3,1.3)
		sfx_jump.pitch_scale = 2
		sfx_jump.play()
		area.toggle()
		print_debug('switch hit')
	if area.get_collision_layer_value(6):
		check_point_tile = tile_map.local_to_map(area.global_position)
		print_debug('checkpoint hit')
	if area.get_collision_layer_value(7):
		area.queue_free()
		sprite.scale = Vector2(1.4,1.4)
		sfx_jump.pitch_scale = 2.5
		sfx_jump.play()
		camera.position_smoothing_enabled = false
		next_position -= Vector2(0,200000)
		is_moving = true
		animation.play('end')
		print_debug('goal hit')
	
	
	pass # Replace with function body.

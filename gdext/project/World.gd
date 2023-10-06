extends Node2D

@onready var _zones := $Zones
@onready var _pathes := $Pathes

@onready var Zone := preload("res://Zone.tscn")
@onready var PathFlow := preload("res://PathFlow.tscn")
@onready var _network := Network.new()

@export var NODE_COLOR: Color = Color.WHITE
@export var LINK_COLOR: Gradient
@export var NODE_SIZE: float = 25.0
@export var LINK_WIDTH: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var node0 := _network.add_node(Vector2(100, 100), true, 3000.0, 4000.0)	
	var node1 := _network.add_node(Vector2(700, 100))	
	var node2 := _network.add_node(Vector2(700, 600), true, 5000.0, 6000.0)	
	var node3 := _network.add_node(Vector2(1000, 300), true, 3000.0, 6000.0)
	var node4 := _network.add_node(Vector2(600, 400))
	var node5 := _network.add_node(Vector2(200, 500))
	

	var link1 := _network.add_link(node0.id, node1.id)	
	link1.speed = 1.0
	_network.add_link(node0.id, node4.id)	
	_network.add_link(node1.id, node3.id)	
	var link2 := _network.add_link(node2.id, node3.id)
	link2.capacity = 1800.0
	_network.add_link(node1.id, node4.id)
	_network.add_link(node2.id, node4.id)
	_network.add_link(node0.id, node5.id)
	_network.add_link(node5.id, node2.id)

	update_zones()
	
	var path := _network.get_point_path(node0.id, node3.id)
	var pathflow := PathFlow.instantiate()
	pathflow.set_path(path, 20.0)
	_pathes.add_child(pathflow)
	
	path = _network.get_point_path(node3.id, node0.id)
	pathflow = PathFlow.instantiate()
	pathflow.set_path(path, 5.0)
	_pathes.add_child(pathflow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw() -> void:
	for link in _network._links.keys():
		var pos1: Vector2 = _network._nodes[link.x].position
		var pos2: Vector2 = _network._nodes[link.y].position
		# Offset
		var side := (pos2 - pos1).normalized().orthogonal()
		var capacity = _network._links[link].capacity
		var link_width: float = LINK_WIDTH * (capacity / 3600.0)
		var flow = _network._links[link].flow
		var saturation = flow / capacity
		var link_color: Color = LINK_COLOR.sample()
		draw_line(pos1+side*11.0, pos2+side*11.0, link_color, link_width)
	
	for node in _network._nodes.values():
		draw_circle(node.position, NODE_SIZE, NODE_COLOR)

func update_zones() -> void:
	for zone in _zones.get_children():
		zone.queue_free()
		
	for node in _network._nodes.values():
		if node.is_zone:
			var zone := Zone.instantiate()
			# Must added before setting properties
			_zones.add_child(zone)
			zone.position = node.position
			zone.produce = node.produce
			zone.attract = node.attract
			


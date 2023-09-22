extends Node2D

@onready var _zones := $Zones
@onready var Zone := preload("res://Zone.tscn")
@onready var _network := Network.new()

@export var NODE_COLOR: Color = Color.WHITE
@export var LINK_COLOR: Color = Color.WHITE
@export var LINK_WIDTH: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var node0 :=_network.add_node(Vector2(100, 100), true)	
	var node1 :=_network.add_node(Vector2(700, 100))	
	var node2 :=_network.add_node(Vector2(700, 600))	
	var node3 :=_network.add_node(Vector2(1000, 300), true)

	var link1 := _network.add_link(node0.id, node1.id)	
	link1.speed = 1.0
	_network.add_link(node0.id, node2.id)	
	_network.add_link(node1.id, node3.id)	
	_network.add_link(node2.id, node3.id)

	update_zones()
	
	print(node0.id, node3.id)
	print(_network.get_id_path(node0.id, node3.id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw() -> void:
	for link in _network._links.keys():
		var pos1 = _network._nodes[link.x].position
		var pos2 = _network._nodes[link.y].position

		draw_line(pos1, pos2, LINK_COLOR, LINK_WIDTH)
	
	for node in _network._nodes.values():
		draw_circle(node.position, 10, NODE_COLOR)

func update_zones() -> void:
	for zone in _zones.get_children():
		zone.queue_free()
		
	for node in _network._nodes.values():
		if node.is_zone:
			var zone := Zone.instantiate()
			zone.position = node.position
			_zones.add_child(zone)


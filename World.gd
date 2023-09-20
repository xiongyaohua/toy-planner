extends Node2D

@onready var _zones := $Zones
@onready var Zone := preload("res://Zone.tscn")
@onready var _network := Network.new()

@export var NODE_COLOR: Color = Color.WHITE
@export var LINK_COLOR: Color = Color.WHITE
@export var LINK_WIDTH: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var node1 :=_network.add_node(Vector2(100, 100), true)	
	var node2 :=_network.add_node(Vector2(700, 100))	
	var node3 :=_network.add_node(Vector2(700, 600))	
	var node4 :=_network.add_node(Vector2(1000, 300), true)

	_network.add_link(node1, node2)	
	_network.add_link(node1, node3)	
	_network.add_link(node2, node4)	
	_network.add_link(node3, node4)

	update_zones()

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


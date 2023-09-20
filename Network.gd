extends AStar2D
class_name Network

var _next_node_id := 0
func _get_new_node() -> int:
	var id := _next_node_id
	_next_node_id += 1
	return id

var _nodes := {}
var _links := {}

class TNode:
	var position: Vector2
	var is_zone: bool
	func _init():
		pass

class TLink:
	var capacity: float
	func _init():
		pass

func add_node(p_position: Vector2, p_is_zone: bool = false) -> int:
	var id = _get_new_node()
	var node = TNode.new()
	node.position = p_position
	node.is_zone = p_is_zone
	
	_nodes[id] = node

	return id

func has_node(p_id: int) -> bool:
	return _nodes.has(p_id)

func add_link(p_from: int, p_to: int, p_capacity: float=3600.0) -> void:
	assert(has_node(p_from))
	assert(has_node(p_to))
	
	var id := Vector2i(p_from, p_to) # Abuse Vector2i for tuple
	var link := TLink.new()
	link.capacity = p_capacity
	_links[id] = link
	
func has_link(p_from, p_to) -> bool:
	return _links.has(Vector2i(p_from, p_to))



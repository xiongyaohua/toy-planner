extends AStar2D
class_name Network

var _nodes := {}
var _links := {}

class TNode:
	static var max_id := 0
	var id := -1
	var position: Vector2 = Vector2()
	var is_zone: bool = false
	func _init():
		id = max_id
		max_id += 1

class TLink:
	var capacity: float = 3600.0
	var id: Vector2i = Vector2i()
	func _init(p_id: Vector2i):
		id = p_id

func add_node(p_position: Vector2, p_is_zone: bool = false) -> int:
	var node = TNode.new()
	node.position = p_position
	node.is_zone = p_is_zone
	
	_nodes[node.id] = node

	return node.id

func has_node(p_id: int) -> bool:
	return _nodes.has(p_id)

func add_link(p_from: int, p_to: int, p_capacity: float=3600.0) -> void:
	assert(has_node(p_from))
	assert(has_node(p_to))
	
	var id := Vector2i(p_from, p_to) # Abuse Vector2i for tuple
	var link := TLink.new(id)
	link.capacity = p_capacity
	_links[link.id] = link
	
func has_link(p_from, p_to) -> bool:
	return _links.has(Vector2i(p_from, p_to))



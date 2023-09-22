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
	var flow: float = 0.0
	var speed: float = 10.0
	var length: float = 0.0
	var id: Vector2i = Vector2i()
	func _init(p_id: Vector2i):
		id = p_id

func add_node(p_position: Vector2, p_is_zone: bool = false) -> TNode:
	var node = TNode.new()
	node.position = p_position
	node.is_zone = p_is_zone
	
	_nodes[node.id] = node
	add_point(node.id, node.position)
	
	return node

func has_node(p_id: int) -> bool:
	return _nodes.has(p_id)

func add_link(p_from: int, p_to: int, p_capacity: float=3600.0) -> TLink:
	assert(has_node(p_from))
	assert(has_node(p_to))
	
	var p1:Vector2 = _nodes[p_from].position
	var p2:Vector2 = _nodes[p_to].position
	var length := p1.distance_to(p2)
	var id := Vector2i(p_from, p_to) # Abuse Vector2i for tuple
	var link := TLink.new(id)
	link.capacity = p_capacity
	link.length = length
	
	_links[link.id] = link
	connect_points(p_from, p_to)
	return link
	
func has_link(p_from, p_to) -> bool:
	return _links.has(Vector2i(p_from, p_to))
	
func _compute_cost(from_id: int, to_id: int) -> float:
	var id := Vector2i(from_id, to_id)
	var link: TLink = _links[id]
	
	return link.length / link.speed * bpr(link.flow, link.capacity)
	
func _estimate_cost(p_from: int, p_to: int) -> float:
	var p1:Vector2 = _nodes[p_from].position
	var p2:Vector2 = _nodes[p_to].position
	
	return p1.distance_to(p2)
	
func bpr(p_flow: float, p_capacity: float) -> float:
	var saturation := p_flow / p_capacity
	return 1 + 10.0 * saturation ** 2



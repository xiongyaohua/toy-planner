extends AStar2D
class_name Network

var _nodes := {}
var _links := {}
var _pathes := {}

class TNode:
	static var max_id := 0
	var id := -1
	var position: Vector2 = Vector2()
	var is_zone: bool = false
	var produce: float = 0.0
	var attract: float = 0.0
	func _init() -> void:
		id = max_id
		max_id += 1

class TLink:
	var capacity: float = 3600.0
	var flow: float = 0.0
	var speed: float = 10.0
	var length: float = 0.0
	var id: Vector2i = Vector2i()
	func _init(p_id: Vector2i) -> void:
		id = p_id

func add_node(p_position: Vector2, p_is_zone: bool = false, p_produce:float=0.0, p_attract:float=0.0) -> TNode:
	var node := TNode.new()
	node.position = p_position
	node.is_zone = p_is_zone
	node.attract = p_attract
	node.produce = p_produce
	
	_nodes[node.id] = node
	add_point(node.id, node.position)
	
	return node

func has_node(p_id: int) -> bool:
	return _nodes.has(p_id)

func add_link(p_from: int, p_to: int, p_capacity: float=3600.0, p_bidirection: bool=true) -> TLink:
	assert(has_node(p_from))
	assert(has_node(p_to))
	
	if not p_bidirection:
		var p1:Vector2 = _nodes[p_from].position
		var p2:Vector2 = _nodes[p_to].position
		var length := p1.distance_to(p2)
		var id := Vector2i(p_from, p_to) # Abuse Vector2i for tuple
		var link := TLink.new(id)
		link.capacity = p_capacity
		link.length = length
		
		_links[link.id] = link
		connect_points(p_from, p_to, false)
		return link
	else:
		add_link(p_to, p_from, p_capacity, false)
		return add_link(p_from, p_to, p_capacity, false)
	
func has_link(p_from: int, p_to: int) -> bool:
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
	return 1 + 1.0 * saturation ** 2
	
# Assignment related methods
func update_link_flow() -> void:
	for link: Network.TLink in _links.values():
		link.flow = 0.0
		
	for od_bundle: Dictionary in _pathes.values():
		for path: PackedInt32Array in od_bundle:
			var path_flow: float = od_bundle[path]
			
			for i in range(path.size() - 1):
				var link := Vector2i(path[i], path[i+1])
				_links[link].flow += path_flow
				
		



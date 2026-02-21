class_name LabelUpXPool
extends RefCounted

signal node_returned(id: int)

var allow_grow: bool = true
var drop_oldest_when_full: bool = true
var max_pool_size: int = 0  # 0 = unlimited when allow_grow

var _available: Array[LabelUpXNode] = []
var _active: Dictionary = {}  # id -> LabelUpXNode
var _next_id: int = 1
var _canvas_layer: CanvasLayer
var _parent: Node

func _init(p_parent: Node, p_canvas_layer: CanvasLayer) -> void:
	_parent = p_parent
	_canvas_layer = p_canvas_layer

func prewarm(amount: int) -> void:
	amount = maxi(0, amount)
	for i in amount:
		var node: LabelUpXNode = _create_node()
		if node:
			node.visible = false
			_available.append(node)

func acquire(world_pos: Vector2, text: String, style: LabelUpXStyle) -> int:
	if text.is_empty() or style == null:
		return -1
	var node: LabelUpXNode = null
	if _available.size() > 0:
		node = _available.pop_back()
	else:
		if allow_grow and (max_pool_size == 0 or get_pool_total_size() < max_pool_size):
			node = _create_node()
		elif drop_oldest_when_full and _active.size() > 0:
			var oldest_id: int = _get_oldest_active_id()
			if oldest_id >= 0:
				_drop_node(oldest_id)
			node = _available.pop_back() if _available.size() > 0 else _create_node()
		else:
			return -1
	if not node:
		return -1
	var id: int = _next_id
	_next_id += 1
	if _next_id >= 0x7FFFFFFF:
		_next_id = 1
	_active[id] = node
	if not node.finished.is_connected(_on_node_finished):
		node.finished.connect(_on_node_finished)
	node.setup(_canvas_layer, id, world_pos, text, style)
	return id

func _create_node() -> LabelUpXNode:
	var node: LabelUpXNode = LabelUpXNode.new()
	_node_setup_parent(node)
	return node

func _node_setup_parent(node: LabelUpXNode) -> void:
	if _canvas_layer:
		_canvas_layer.add_child(node)
	elif _parent:
		_parent.add_child(node)
	else:
		push_error("LabelUpXPool: No parent or canvas layer")
		return
	node.visible = false

func _on_node_finished(id: int) -> void:
	if not _active.has(id):
		return
	var node: LabelUpXNode = _active[id]
	_active.erase(id)
	if _parent is Node:
		(_parent as Node).call_deferred("_label_up_x_pool_finish_node", self, node, id)
	else:
		_finish_node_now(node, id)

func _get_oldest_active_id() -> int:
	if _active.is_empty():
		return -1
	var first_key: int = -1
	for k in _active.keys():
		first_key = k
		break
	return first_key

func _drop_node(id: int) -> void:
	if not _active.has(id):
		return
	var node: LabelUpXNode = _active[id]
	_active.erase(id)
	node.reset_for_pool()
	_available.append(node)
	node_returned.emit(id)

func release(id: int) -> bool:
	if not _active.has(id):
		return false
	var node: LabelUpXNode = _active[id]
	node.force_finish()
	return true

func get_active_ids() -> Array[int]:
	var ids: Array[int] = []
	for k in _active.keys():
		ids.append(k)
	return ids

func _finish_node_now(node: LabelUpXNode, id: int) -> void:
	node.reset_for_pool()
	_available.append(node)
	node_returned.emit(id)

func get_active_count() -> int:
	return _active.size()

func get_available_count() -> int:
	return _available.size()

func get_pool_total_size() -> int:
	return _active.size() + _available.size()

func clear_all() -> void:
	for id in _active.keys().duplicate():
		var node: LabelUpXNode = _active[id]
		_active.erase(id)
		node.reset_for_pool()
		_available.append(node)

class_name LabelUpXManager
extends Node

const DEFAULT_PREWARM: int = 200
const LAYER_NAME: StringName = &"LabelUpXLayer"

var canvas_layer: CanvasLayer
var pool: LabelUpXPool
var _stacking_offset_accum: Vector2 = Vector2.ZERO
var _last_spawn_pos: Vector2 = Vector2(-999999, -999999)
var _spawn_jitter: Vector2 = Vector2.ZERO

func _ready() -> void:
	canvas_layer = CanvasLayer.new()
	canvas_layer.name = LAYER_NAME
	canvas_layer.layer = 100
	add_child(canvas_layer)
	pool = LabelUpXPool.new(self, canvas_layer)
	pool.allow_grow = true
	pool.drop_oldest_when_full = true
	pool.node_returned.connect(_on_label_finished)
	pool.prewarm(DEFAULT_PREWARM)

func _on_label_finished(id: int) -> void:
	label_finished.emit(id)

## Called deferred by pool to avoid flicker when returning node
func _label_up_x_pool_finish_node(pool_ref: LabelUpXPool, node: LabelUpXNode, id: int) -> void:
	pool_ref._finish_node_now(node, id)

signal label_finished(id: int)

func show_label(world_pos: Vector2, text: String, style: LabelUpXStyle) -> int:
	if text.is_empty():
		push_error("LabelUpX: text cannot be empty")
		return -1
	if style == null:
		push_error("LabelUpX: style cannot be null")
		return -1
	var use_style: LabelUpXStyle = style
	var spawn_pos: Vector2 = world_pos
	if use_style.stacking_enabled and _last_spawn_pos.distance_to(world_pos) < 5.0:
		_stacking_offset_accum += use_style.stacking_offset
		spawn_pos = world_pos + _stacking_offset_accum
	else:
		_stacking_offset_accum = use_style.stacking_offset
		_last_spawn_pos = world_pos
	if use_style.spawn_jitter_x > 0 or use_style.spawn_jitter_y > 0:
		spawn_pos.x += randf_range(-use_style.spawn_jitter_x, use_style.spawn_jitter_x)
		spawn_pos.y += randf_range(-use_style.spawn_jitter_y, use_style.spawn_jitter_y)
	var id: int = pool.acquire(spawn_pos, text, use_style)
	if id >= 0:
		label_spawned.emit(id)
	return id

signal label_spawned(id: int)

func dismiss(id: int) -> bool:
	return pool.release(id)

func clear_all() -> void:
	for id in pool.get_active_ids():
		pool.release(id)
	_stacking_offset_accum = Vector2.ZERO
	_last_spawn_pos = Vector2(-999999, -999999)

func prewarm(amount: int) -> void:
	amount = clampi(amount, 0, 100000)
	pool.prewarm(amount)

func get_active_count() -> int:
	return pool.get_active_count()

func get_pool_size() -> int:
	return pool.get_pool_total_size()

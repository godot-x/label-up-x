extends Node

signal label_spawned(id: int)
signal label_finished(id: int)

var _manager: LabelUpXManager = null
var _initialized: bool = false

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	if _initialized:
		return
	_manager = LabelUpXManager.new()
	_manager.name = "LabelUpXManager"
	add_child(_manager)
	_manager.label_spawned.connect(_on_label_spawned)
	_manager.label_finished.connect(_on_label_finished)
	_initialized = true

func _on_label_spawned(id: int) -> void:
	label_spawned.emit(id)

func _on_label_finished(id: int) -> void:
	label_finished.emit(id)

func show(position: Vector2, text: String, style: LabelUpXStyle) -> int:
	if not _initialized:
		_initialize()
	if text.is_empty():
		push_error("LabelUpX: text cannot be empty")
		return -1
	if style == null:
		push_error("LabelUpX: style cannot be null")
		return -1
	return _manager.show_label(position, text, style)

func show_xy(x: float, y: float, text: String, style: LabelUpXStyle) -> int:
	return show(Vector2(x, y), text, style)

func dismiss(id: int) -> bool:
	if not _initialized:
		return false
	return _manager.dismiss(id)

func clear_all() -> void:
	if _initialized:
		_manager.clear_all()

func prewarm(amount: int) -> void:
	if not _initialized:
		_initialize()
	_manager.prewarm(amount)

func get_active_count() -> int:
	if not _initialized:
		return 0
	return _manager.get_active_count()

func get_pool_size() -> int:
	if not _initialized:
		return 0
	return _manager.get_pool_size()

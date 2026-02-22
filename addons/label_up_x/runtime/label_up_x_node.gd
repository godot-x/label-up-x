class_name LabelUpXNode
extends Node2D

signal finished(id: int)

var label_id: int = -1
var _label: Label
var _style: LabelUpXStyle
var _start_pos: Vector2
var _tweens: Array[Tween] = []
var _follow_target: Node2D
var _follow_offset: Vector2
var _lock_to_world: bool
var _base_world_pos: Vector2
var _canvas_layer: CanvasLayer
var _move_start_pos: Vector2
var _move_end_pos: Vector2
var _move_perpendicular: Vector2  # unit vector perpendicular to movement (for ARC/WIGGLE)

func _ready() -> void:
	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_label)

func setup(p_canvas_layer: CanvasLayer, id: int, world_pos: Vector2, text: String, style: LabelUpXStyle) -> void:
	_canvas_layer = p_canvas_layer
	label_id = id
	_style = style
	_start_pos = world_pos
	_follow_target = style.follow_target if style else null
	_follow_offset = style.follow_offset if style else Vector2.ZERO
	_lock_to_world = style.lock_to_world if style else false
	_base_world_pos = world_pos

	_apply_style(text)
	var layer_pos: Vector2 = _world_to_layer(world_pos)
	global_position = layer_pos
	visible = false
	_stop_all_tweens()
	# Apply pivot next frame when Label has correct size, then show and run (avoids "goes to side then up")
	call_deferred("_deferred_pivot_then_run")

func _deferred_pivot_then_run() -> void:
	# Force size to current content so get_minimum_size() reflects this style (not previous from pool)
	_label.size = _label.get_minimum_size()
	var label_size: Vector2 = _label.size
	_label.position = -label_size / 2.0
	if _style and _style.pixel_snap:
		_label.position = _label.position.round()
	visible = true
	_run_sequence()

func _world_to_layer(world_pos: Vector2) -> Vector2:
	if not _canvas_layer:
		return world_pos
	var vp: Viewport = _canvas_layer.get_viewport()
	if not vp:
		return world_pos
	# use the same transform the viewport uses to draw the canvas (camera, zoom, etc.)
	return vp.get_canvas_transform() * world_pos

func _process(_delta: float) -> void:
	if _follow_target and is_instance_valid(_follow_target):
		var pos: Vector2 = _follow_target.global_position + _follow_offset
		if _lock_to_world:
			pos = _base_world_pos
		global_position = _world_to_layer(pos)

func _apply_style(text: String) -> void:
	if not _label or not _style:
		return
	_label.text = text
	_label.add_theme_font_size_override("font_size", _style.font_size)
	if _style.font:
		_label.add_theme_font_override("font", _style.font)
	else:
		_label.remove_theme_font_override("font")
	_label.add_theme_color_override("font_color", _style.font_color)
	_label.add_theme_color_override("font_outline_color", _style.outline_color)
	_label.add_theme_constant_override("outline_size", _style.outline_size)
	_label.add_theme_color_override("font_shadow_color", _style.shadow_color if _style.shadow_enabled else Color(0, 0, 0, 0))
	_label.add_theme_constant_override("shadow_offset_x", int(_style.shadow_offset.x))
	_label.add_theme_constant_override("shadow_offset_y", int(_style.shadow_offset.y))
	modulate.a = _style.opacity
	scale = _style.initial_scale
	rotation = _style.initial_rotation
	# Pivot applied in _deferred_pivot_then_run() after layout so center is at spawn point
	if _style.canvas_item_material:
		_label.material = _style.canvas_item_material
	else:
		_label.material = null
	_label.show_behind_parent = false
	z_index = _style.z_index_offset
	set_process(_follow_target != null and is_instance_valid(_follow_target))
	# Force Label to invalidate cached min size so deferred pivot uses current style (fixes GOLD etc. offset)
	_label.notification(Control.NOTIFICATION_THEME_CHANGED)

func _stop_all_tweens() -> void:
	for t in _tweens:
		if t and t.is_valid():
			t.kill()
	_tweens.clear()

func _run_sequence() -> void:
	var total_duration: float = _style.duration / _style.speed_multiplier
	var move_dir: Vector2 = _get_movement_direction()
	_move_start_pos = global_position
	_move_end_pos = global_position + move_dir * _style.distance
	# Perpendicular to movement (right-hand side); for ARC/WIGGLE
	var perp: Vector2 = Vector2(move_dir.y, -move_dir.x)
	if perp.length_squared() > 0.001:
		_move_perpendicular = perp.normalized()
	else:
		_move_perpendicular = Vector2.RIGHT

	# Appear (runs in parallel with movement). Skip for SCALE_DOWN so we draw at scale max then shrink.
	var appear: LabelUpXEnums.AppearAnimation = _style.appear_animation if _style.motion_style != LabelUpXEnums.MotionStyle.SCALE_DOWN else LabelUpXEnums.AppearAnimation.NONE
	if appear != LabelUpXEnums.AppearAnimation.NONE:
		var tween_appear: Tween = create_tween()
		_tweens.append(tween_appear)
		tween_appear.set_ease(_style.easing)
		tween_appear.set_trans(_style.trans_type)
		if appear == LabelUpXEnums.AppearAnimation.FADE_IN:
			modulate.a = _style.appear_initial_opacity * _style.opacity
			tween_appear.tween_property(self, "modulate:a", _style.opacity, _style.appear_duration)
		elif appear == LabelUpXEnums.AppearAnimation.SCALE_IN:
			scale = _style.appear_initial_scale
			tween_appear.tween_property(self, "scale", _style.initial_scale, _style.appear_duration)
		elif appear == LabelUpXEnums.AppearAnimation.POP:
			scale = _style.appear_initial_scale
			modulate.a = _style.appear_initial_opacity * _style.opacity
			tween_appear.tween_property(self, "scale", _style.initial_scale * _style.appear_overshoot, _style.appear_duration * 0.5)
			tween_appear.tween_property(self, "scale", _style.initial_scale, _style.appear_duration * 0.5)
			tween_appear.parallel().tween_property(self, "modulate:a", _style.opacity, _style.appear_duration)
		elif appear == LabelUpXEnums.AppearAnimation.SCALE_AND_FADE:
			scale = _style.appear_initial_scale
			modulate.a = _style.appear_initial_opacity * _style.opacity
			tween_appear.tween_property(self, "scale", _style.initial_scale, _style.appear_duration)
			tween_appear.parallel().tween_property(self, "modulate:a", _style.opacity, _style.appear_duration)

	# Movement: always use tween_method so we can apply STRAIGHT/ARC/WIGGLE/SHAKE from spawn point
	var tween_move: Tween = create_tween()
	_tweens.append(tween_move)
	tween_move.set_ease(_style.easing)
	tween_move.set_trans(_style.trans_type)
	tween_move.tween_method(Callable(self, "_apply_motion"), 0.0, 1.0, total_duration)

	# Motion style: scale over time
	if _style.motion_style == LabelUpXEnums.MotionStyle.SCALE_UP:
		tween_move.parallel().tween_property(self, "scale", _style.final_scale, total_duration)
	elif _style.motion_style == LabelUpXEnums.MotionStyle.SCALE_DOWN:
		tween_move.parallel().tween_property(self, "scale", _style.final_scale, total_duration)
	elif _style.motion_style == LabelUpXEnums.MotionStyle.SCALE_UP_THEN_DOWN:
		tween_move.parallel().tween_property(self, "scale", _style.final_scale, total_duration * 0.5)
		tween_move.parallel().tween_property(self, "scale", _style.initial_scale, total_duration * 0.5).set_delay(total_duration * 0.5)

	tween_move.tween_callback(_on_movement_done)

## t from 0 to 1; sets global_position from spawn with STRAIGHT/ARC/WIGGLE/SHAKE
func _apply_motion(t: float) -> void:
	var linear_t: float = t
	if _style and _style.movement_curve:
		linear_t = _style.movement_curve.sample(t)
	var base_pos: Vector2 = _move_start_pos.lerp(_move_end_pos, linear_t)
	var offset: Vector2 = Vector2.ZERO
	if _style:
		match _style.motion_style:
			LabelUpXEnums.MotionStyle.STRAIGHT:
				pass
			LabelUpXEnums.MotionStyle.ARC:
				var arc: float = sin(t * PI) * _style.arc_height
				offset = _move_perpendicular * arc
			LabelUpXEnums.MotionStyle.WIGGLE:
				var wave: float = sin(t * TAU * _style.frequency) * _style.amplitude * _style.wiggle_intensity
				offset = _move_perpendicular * wave
			LabelUpXEnums.MotionStyle.SHAKE:
				var shake_freq: float = 5.0
				var jx: float = sin(t * shake_freq) * _style.shake_intensity * _style.amplitude
				var jy: float = cos(t * (shake_freq * 0.9)) * _style.shake_intensity * _style.amplitude
				offset = Vector2(jx, jy)
			LabelUpXEnums.MotionStyle.BOUNCE:
				pass
			_:
				pass
	global_position = base_pos + offset

func _get_movement_direction() -> Vector2:
	var dir: Vector2
	match _style.movement_direction:
		LabelUpXEnums.MovementDirection.UP:
			dir = Vector2.UP
		LabelUpXEnums.MovementDirection.DOWN:
			dir = Vector2.DOWN
		LabelUpXEnums.MovementDirection.LEFT:
			dir = Vector2.LEFT
		LabelUpXEnums.MovementDirection.RIGHT:
			dir = Vector2.RIGHT
		LabelUpXEnums.MovementDirection.UP_LEFT:
			dir = Vector2(-0.707, -0.707)
		LabelUpXEnums.MovementDirection.UP_RIGHT:
			dir = Vector2(0.707, -0.707)
		LabelUpXEnums.MovementDirection.DOWN_LEFT:
			dir = Vector2(-0.707, 0.707)
		LabelUpXEnums.MovementDirection.DOWN_RIGHT:
			dir = Vector2(0.707, 0.707)
		LabelUpXEnums.MovementDirection.UP_FAN:
			dir = _fan_direction(-PI / 2.0)
		LabelUpXEnums.MovementDirection.DOWN_FAN:
			dir = _fan_direction(PI / 2.0)
		LabelUpXEnums.MovementDirection.LEFT_FAN:
			dir = _fan_direction(PI)
		LabelUpXEnums.MovementDirection.RIGHT_FAN:
			dir = _fan_direction(0.0)
		LabelUpXEnums.MovementDirection.RANDOM:
			var angle: float = randf() * TAU
			dir = Vector2.from_angle(angle)
	return dir

func _fan_direction(base_angle_rad: float) -> Vector2:
	var spread_rad: float = deg_to_rad(_style.movement_fan_spread_degrees) * 0.5
	var angle: float = base_angle_rad + randf_range(-spread_rad, spread_rad)
	return Vector2.from_angle(angle)

func _on_movement_done() -> void:
	# Stop following so exit animation plays where movement ended, not at target feet
	_follow_target = null
	set_process(false)
	if _style.exit_animation == LabelUpXEnums.ExitAnimation.NONE:
		_return_to_pool()
		return
	var tween_exit: Tween = create_tween()
	_tweens.append(tween_exit)
	tween_exit.set_ease(_style.exit_easing)
	tween_exit.set_trans(_style.exit_trans_type)
	if _style.exit_animation == LabelUpXEnums.ExitAnimation.FADE_OUT:
		tween_exit.tween_property(self, "modulate:a", 0.0, _style.exit_duration)
	elif _style.exit_animation == LabelUpXEnums.ExitAnimation.SCALE_OUT:
		tween_exit.tween_property(self, "scale", Vector2.ZERO, _style.exit_duration)
	elif _style.exit_animation == LabelUpXEnums.ExitAnimation.SCALE_AND_FADE:
		tween_exit.tween_property(self, "modulate:a", 0.0, _style.exit_duration)
		tween_exit.parallel().tween_property(self, "scale", Vector2.ZERO, _style.exit_duration)
	tween_exit.tween_callback(_return_to_pool)

func force_finish() -> void:
	_stop_all_tweens()
	visible = false
	finished.emit(label_id)

func _return_to_pool() -> void:
	_stop_all_tweens()
	visible = false
	finished.emit(label_id)

func reset_for_pool() -> void:
	_stop_all_tweens()
	visible = false
	position = Vector2.ZERO
	global_position = Vector2.ZERO
	scale = Vector2.ONE
	modulate = Color.WHITE
	rotation = 0.0
	_label.text = ""
	_follow_target = null
	set_process(false)
	label_id = -1
	_style = null
	_canvas_layer = null

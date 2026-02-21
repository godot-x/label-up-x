class_name LabelUpXStyles
extends RefCounted

const DEFAULT := &"default"
const DAMAGE := &"damage"
const CRITICAL := &"critical"
const HEAL := &"heal"
const XP := &"xp"
const GOLD := &"gold"
const FIRE := &"fire"
const ICE := &"ice"
const POISON := &"poison"

var _styles: Dictionary = {}
var _initialized: bool = false

func _init() -> void:
	_build_styles()

func _build_styles() -> void:
	if _initialized:
		return
	_initialized = true

	var s: LabelUpXStyle

	# DEFAULT
	s = LabelUpXStyle.new()
	s.font_size = 24
	s.font_color = Color.WHITE
	s.outline_size = 1
	s.outline_color = Color.BLACK
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 60.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[DEFAULT] = s

	# DAMAGE
	s = LabelUpXStyle.new()
	s.font_size = 22
	s.font_color = Color(1.0, 0.4, 0.3)
	s.outline_size = 2
	s.outline_color = Color(0.2, 0.05, 0.05)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 70.0
	s.motion_style = LabelUpXEnums.MotionStyle.STRAIGHT
	s.appear_animation = LabelUpXEnums.AppearAnimation.SCALE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[DAMAGE] = s

	# CRITICAL
	s = LabelUpXStyle.new()
	s.font_size = 28
	s.font_color = Color(1.0, 0.2, 0.1)
	s.outline_size = 3
	s.outline_color = Color(0.3, 0.0, 0.0)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.3
	s.distance = 100.0
	s.motion_style = LabelUpXEnums.MotionStyle.SCALE_UP
	s.initial_scale = Vector2(1.0, 1.0)
	s.final_scale = Vector2(1.3, 1.3)
	s.appear_animation = LabelUpXEnums.AppearAnimation.POP
	s.appear_overshoot = 1.4
	s.exit_animation = LabelUpXEnums.ExitAnimation.SCALE_AND_FADE
	_styles[CRITICAL] = s

	# HEAL
	s = LabelUpXStyle.new()
	s.font_size = 24
	s.font_color = Color(0.2, 1.0, 0.4)
	s.outline_size = 1
	s.outline_color = Color(0.0, 0.2, 0.05)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.1
	s.distance = 65.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[HEAL] = s

	# XP
	s = LabelUpXStyle.new()
	s.font_size = 22
	s.font_color = Color(0.4, 0.7, 1.0)
	s.outline_size = 1
	s.outline_color = Color(0.05, 0.1, 0.25)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 60.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[XP] = s

	# GOLD
	s = LabelUpXStyle.new()
	s.font_size = 24
	s.font_color = Color(1.0, 0.85, 0.2)
	s.outline_size = 2
	s.outline_color = Color(0.25, 0.2, 0.0)
	s.glow_enabled = true
	s.glow_color = Color(1.0, 0.9, 0.3)
	s.glow_intensity = 0.8
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.2
	s.distance = 75.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.SCALE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[GOLD] = s

	# FIRE
	s = LabelUpXStyle.new()
	s.font_size = 24
	s.font_color = Color(1.0, 0.5, 0.1)
	s.outline_size = 1
	s.outline_color = Color(0.3, 0.1, 0.0)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 70.0
	s.motion_style = LabelUpXEnums.MotionStyle.WIGGLE
	s.wiggle_intensity = 1.2
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[FIRE] = s

	# ICE
	s = LabelUpXStyle.new()
	s.font_size = 24
	s.font_color = Color(0.5, 0.9, 1.0)
	s.outline_size = 1
	s.outline_color = Color(0.0, 0.2, 0.3)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 65.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[ICE] = s

	# POISON
	s = LabelUpXStyle.new()
	s.font_size = 22
	s.font_color = Color(0.6, 0.3, 1.0)
	s.outline_size = 1
	s.outline_color = Color(0.15, 0.0, 0.2)
	s.movement_direction = LabelUpXEnums.MovementDirection.UP
	s.duration = 1.0
	s.distance = 60.0
	s.motion_style = LabelUpXEnums.MotionStyle.SHAKE
	s.shake_intensity = 1.0
	s.appear_animation = LabelUpXEnums.AppearAnimation.FADE_IN
	s.exit_animation = LabelUpXEnums.ExitAnimation.FADE_OUT
	_styles[POISON] = s

func get_style(key: StringName) -> LabelUpXStyle:
	if _styles.has(key):
		return _styles[key]
	return _styles[DEFAULT]

func has_style(key: StringName) -> bool:
	return _styles.has(key)

func get_style_keys() -> Array[StringName]:
	var keys: Array[StringName] = []
	for k in _styles.keys():
		keys.append(k)
	return keys

static var _instance: LabelUpXStyles

static func get_instance() -> LabelUpXStyles:
	if _instance == null:
		_instance = LabelUpXStyles.new()
	return _instance

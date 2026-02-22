extends Control

@onready var stress_spawn_btn: Button = $"ScrollContainer/VBox/TabContainer/Stress Test/VBox/Grid/Spawn10k"
@onready var stress_active_label: Label = $"ScrollContainer/VBox/TabContainer/Stress Test/VBox/Stats/ActiveCount"
@onready var stress_fps_label: Label = $"ScrollContainer/VBox/TabContainer/Stress Test/VBox/Stats/FPS"
@onready var stress_pool_label: Label = $"ScrollContainer/VBox/TabContainer/Stress Test/VBox/Stats/PoolSize"
@onready var stress_clear_btn: Button = $"ScrollContainer/VBox/TabContainer/Stress Test/VBox/Grid/ClearAll"
@onready var style_buttons: GridContainer = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/StyleGrid"
@onready var random_dir_check: CheckBox = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Options/RandomDir"
@onready var duration_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/DurationSlider"
@onready var duration_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/DurationValue"
@onready var distance_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/DistanceSlider"
@onready var distance_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/DistanceValue"
@onready var font_size_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/FontSizeSlider"
@onready var font_size_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/FontSizeValue"
@onready var outline_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/OutlineSlider"
@onready var outline_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/OutlineValue"
@onready var scale_init_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/ScaleInitSlider"
@onready var scale_init_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/ScaleInitValue"
@onready var scale_final_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/ScaleFinalSlider"
@onready var scale_final_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/ScaleFinalValue"
@onready var spawn_area_rect: ColorRect = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/SpawnArea"
@onready var world_panel: Panel = $"ScrollContainer/VBox/TabContainer/World Example/VBox/WorldPanel"
@onready var world_character: ColorRect = $"ScrollContainer/VBox/TabContainer/World Example/VBox/WorldPanel/Character"
@onready var follow_toggle: CheckBox = $"ScrollContainer/VBox/TabContainer/World Example/VBox/Options/FollowToggle"
@onready var world_character_node: Node2D = $WorldCharacterNode
@onready var direction_option: OptionButton = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Options/DirectionOption"
@onready var motion_option: OptionButton = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Options/MotionOption"
@onready var exit_option: OptionButton = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Options/ExitOption"
@onready var fan_spread_slider: HSlider = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/FanSpreadSlider"
@onready var fan_spread_value: Label = $"ScrollContainer/VBox/TabContainer/Style Showcase/VBox/Sliders/FanSpreadValue"

var _styles: LabelUpXStyles
var _current_style_key: StringName = LabelUpXStyles.DEFAULT
var _world_viewport_size: Vector2

func _ready() -> void:
	_styles = LabelUpXStyles.get_instance()
	LabelUpX.prewarm(200)
	_setup_stress_test()
	_setup_style_showcase()
	_setup_world_example()
	_update_slider_labels()

func _process(_delta: float) -> void:
	stress_fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
	stress_active_label.text = "Active: %d" % LabelUpX.get_active_count()
	stress_pool_label.text = "Pool: %d" % LabelUpX.get_pool_size()
	if world_character and world_character_node:
		world_character_node.global_position = world_character.get_global_rect().get_center()

func _setup_stress_test() -> void:
	if stress_spawn_btn:
		stress_spawn_btn.pressed.connect(_on_stress_spawn_10k)
	if stress_clear_btn:
		stress_clear_btn.pressed.connect(_on_stress_clear)

func _on_stress_spawn_10k() -> void:
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	var style: LabelUpXStyle = _styles.get_style(LabelUpXStyles.DEFAULT)
	for i in 10000:
		var x: float = randf_range(100, viewport.x - 100)
		var y: float = randf_range(100, viewport.y - 100)
		LabelUpX.show(Vector2(x, y), str(i + 1), style)

func _on_stress_clear() -> void:
	LabelUpX.clear_all()

func _setup_style_showcase() -> void:
	if direction_option:
		direction_option.clear()
		direction_option.add_item("Up", LabelUpXEnums.MovementDirection.UP)
		direction_option.add_item("Down", LabelUpXEnums.MovementDirection.DOWN)
		direction_option.add_item("Left", LabelUpXEnums.MovementDirection.LEFT)
		direction_option.add_item("Right", LabelUpXEnums.MovementDirection.RIGHT)
		direction_option.add_item("Up left", LabelUpXEnums.MovementDirection.UP_LEFT)
		direction_option.add_item("Up right", LabelUpXEnums.MovementDirection.UP_RIGHT)
		direction_option.add_item("Down left", LabelUpXEnums.MovementDirection.DOWN_LEFT)
		direction_option.add_item("Down right", LabelUpXEnums.MovementDirection.DOWN_RIGHT)
		direction_option.add_item("Up fan", LabelUpXEnums.MovementDirection.UP_FAN)
		direction_option.add_item("Down fan", LabelUpXEnums.MovementDirection.DOWN_FAN)
		direction_option.add_item("Left fan", LabelUpXEnums.MovementDirection.LEFT_FAN)
		direction_option.add_item("Right fan", LabelUpXEnums.MovementDirection.RIGHT_FAN)
		direction_option.add_item("Random", LabelUpXEnums.MovementDirection.RANDOM)
	if motion_option:
		motion_option.clear()
		motion_option.add_item("Straight", LabelUpXEnums.MotionStyle.STRAIGHT)
		motion_option.add_item("Arc", LabelUpXEnums.MotionStyle.ARC)
		motion_option.add_item("Wiggle", LabelUpXEnums.MotionStyle.WIGGLE)
		motion_option.add_item("Shake", LabelUpXEnums.MotionStyle.SHAKE)
		motion_option.add_item("Scale up", LabelUpXEnums.MotionStyle.SCALE_UP)
		motion_option.add_item("Scale down", LabelUpXEnums.MotionStyle.SCALE_DOWN)
	if exit_option:
		exit_option.clear()
		exit_option.add_item("None", LabelUpXEnums.ExitAnimation.NONE)
		exit_option.add_item("Fade out", LabelUpXEnums.ExitAnimation.FADE_OUT)
		exit_option.add_item("Scale out", LabelUpXEnums.ExitAnimation.SCALE_OUT)
		exit_option.add_item("Scale and fade", LabelUpXEnums.ExitAnimation.SCALE_AND_FADE)
		exit_option.select(1)
	var keys: Array[StringName] = _styles.get_style_keys()
	for key in keys:
		var btn: Button = Button.new()
		btn.text = String(key).capitalize()
		btn.pressed.connect(_on_style_button_pressed.bind(key))
		style_buttons.add_child(btn)
	if duration_slider:
		duration_slider.value_changed.connect(_on_slider_changed)
	if distance_slider:
		distance_slider.value_changed.connect(_on_slider_changed)
	if font_size_slider:
		font_size_slider.value_changed.connect(_on_slider_changed)
	if outline_slider:
		outline_slider.value_changed.connect(_on_slider_changed)
	if scale_init_slider:
		scale_init_slider.value_changed.connect(_on_slider_changed)
	if scale_final_slider:
		scale_final_slider.value_changed.connect(_on_slider_changed)
	if fan_spread_slider:
		fan_spread_slider.value_changed.connect(_on_slider_changed)
	if spawn_area_rect:
		spawn_area_rect.gui_input.connect(_on_spawn_area_input)

func _on_style_button_pressed(key: StringName) -> void:
	_current_style_key = key
	_spawn_style_at_random()

func _on_slider_changed(_value: float) -> void:
	_update_slider_labels()

func _update_slider_labels() -> void:
	if duration_value and duration_slider:
		duration_value.text = "%.2f" % duration_slider.value
	if distance_value and distance_slider:
		distance_value.text = "%.0f" % distance_slider.value
	if font_size_value and font_size_slider:
		font_size_value.text = "%d" % int(font_size_slider.value)
	if outline_value and outline_slider:
		outline_value.text = "%d" % int(outline_slider.value)
	if scale_init_value and scale_init_slider:
		scale_init_value.text = "%.2f" % scale_init_slider.value
	if scale_final_value and scale_final_slider:
		scale_final_value.text = "%.2f" % scale_final_slider.value
	if fan_spread_value and fan_spread_slider:
		fan_spread_value.text = "%.0f" % fan_spread_slider.value

func _spawn_style_at_random() -> void:
	var style: LabelUpXStyle = _styles.get_style(_current_style_key).duplicate()
	style.duration = duration_slider.value if duration_slider else 1.0
	style.distance = distance_slider.value if distance_slider else 80.0
	style.font_size = int(font_size_slider.value) if font_size_slider else 24
	style.outline_size = int(outline_slider.value) if outline_slider else 0
	var init_s: float = scale_init_slider.value if scale_init_slider else 1.0
	var fin_s: float = scale_final_slider.value if scale_final_slider else 1.0
	var motion: LabelUpXEnums.MotionStyle = motion_option.get_selected_id() as LabelUpXEnums.MotionStyle if motion_option else LabelUpXEnums.MotionStyle.STRAIGHT
	if motion == LabelUpXEnums.MotionStyle.SCALE_DOWN:
		style.initial_scale = Vector2(maxf(init_s, fin_s), maxf(init_s, fin_s))
		style.final_scale = Vector2(minf(init_s, fin_s), minf(init_s, fin_s))
	else:
		style.initial_scale = Vector2(init_s, init_s)
		style.final_scale = Vector2(fin_s, fin_s)
	if random_dir_check and random_dir_check.button_pressed:
		style.movement_direction = LabelUpXEnums.MovementDirection.RANDOM
	elif direction_option:
		style.movement_direction = direction_option.get_selected_id() as LabelUpXEnums.MovementDirection
	style.movement_fan_spread_degrees = fan_spread_slider.value if fan_spread_slider else 90.0
	if motion_option:
		style.motion_style = motion
	if exit_option:
		style.exit_animation = exit_option.get_selected_id() as LabelUpXEnums.ExitAnimation
	var rect: Rect2 = spawn_area_rect.get_global_rect() if spawn_area_rect else get_viewport_rect()
	var pos: Vector2 = Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y))
	LabelUpX.show(pos, _sample_text_for_style(_current_style_key), style)

func _sample_text_for_style(key: StringName) -> String:
	match key:
		LabelUpXStyles.DAMAGE: return str(randi_range(10, 99))
		LabelUpXStyles.CRITICAL: return str(randi_range(100, 999)) + "!"
		LabelUpXStyles.HEAL: return "+" + str(randi_range(5, 50))
		LabelUpXStyles.XP: return "+" + str(randi_range(10, 100)) + " XP"
		LabelUpXStyles.GOLD: return "+" + str(randi_range(1, 99)) + " G"
		LabelUpXStyles.FIRE: return str(randi_range(20, 80))
		LabelUpXStyles.ICE: return str(randi_range(15, 60))
		LabelUpXStyles.POISON: return str(randi_range(5, 30))
		_: return "LabelUpX"

func _on_spawn_area_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos: Vector2 = spawn_area_rect.get_global_mouse_position() if spawn_area_rect else get_global_mouse_position()
		var style: LabelUpXStyle = _styles.get_style(_current_style_key).duplicate()
		style.duration = duration_slider.value if duration_slider else 1.0
		style.distance = distance_slider.value if distance_slider else 80.0
		style.font_size = int(font_size_slider.value) if font_size_slider else 24
		style.outline_size = int(outline_slider.value) if outline_slider else 0
		var init_s: float = scale_init_slider.value if scale_init_slider else 1.0
		var fin_s: float = scale_final_slider.value if scale_final_slider else 1.0
		var motion_click: LabelUpXEnums.MotionStyle = motion_option.get_selected_id() as LabelUpXEnums.MotionStyle if motion_option else LabelUpXEnums.MotionStyle.STRAIGHT
		if motion_click == LabelUpXEnums.MotionStyle.SCALE_DOWN:
			style.initial_scale = Vector2(maxf(init_s, fin_s), maxf(init_s, fin_s))
			style.final_scale = Vector2(minf(init_s, fin_s), minf(init_s, fin_s))
		else:
			style.initial_scale = Vector2(init_s, init_s)
			style.final_scale = Vector2(fin_s, fin_s)
		if random_dir_check and random_dir_check.button_pressed:
			style.movement_direction = LabelUpXEnums.MovementDirection.RANDOM
		elif direction_option:
			style.movement_direction = direction_option.get_selected_id() as LabelUpXEnums.MovementDirection
		style.movement_fan_spread_degrees = fan_spread_slider.value if fan_spread_slider else 90.0
		if motion_option:
			style.motion_style = motion_click
		if exit_option:
			style.exit_animation = exit_option.get_selected_id() as LabelUpXEnums.ExitAnimation
		LabelUpX.show(pos, _sample_text_for_style(_current_style_key), style)

func _setup_world_example() -> void:
	_world_viewport_size = get_viewport().get_visible_rect().size
	if world_panel:
		world_panel.gui_input.connect(_on_world_click)
	if follow_toggle:
		follow_toggle.toggled.connect(_on_follow_toggled)

func _on_world_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos: Vector2 = world_panel.get_global_mouse_position()
		var style: LabelUpXStyle = _styles.get_style(LabelUpXStyles.DAMAGE).duplicate()
		style.movement_direction = LabelUpXEnums.MovementDirection.UP
		style.motion_style = LabelUpXEnums.MotionStyle.STRAIGHT
		if exit_option:
			style.exit_animation = exit_option.get_selected_id() as LabelUpXEnums.ExitAnimation
		if follow_toggle and follow_toggle.button_pressed and world_character_node:
			style.follow_target = world_character_node
			style.follow_offset = Vector2(0, -20)
			pos = world_character_node.global_position + Vector2(0, -20)
		LabelUpX.show(pos, str(randi_range(10, 99)), style)

func _on_follow_toggled(_on: bool) -> void:
	pass

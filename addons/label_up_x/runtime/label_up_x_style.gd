@tool
class_name LabelUpXStyle
extends Resource

# ---------------------------------------------------------------------------
# Text settings
# ---------------------------------------------------------------------------
@export_group("Text")
@export var font: Font
@export var font_size: int = 24:
	set(v): font_size = clampi(v, 1, 512)
@export var font_color: Color = Color.WHITE
@export var outline_size: int = 0:
	set(v): outline_size = maxi(0, v)
@export var outline_color: Color = Color.BLACK
@export var shadow_enabled: bool = false
@export var shadow_color: Color = Color(0, 0, 0, 0.5)
@export var shadow_offset: Vector2 = Vector2(1, 1)
@export var glow_enabled: bool = false
@export var glow_color: Color = Color.WHITE
@export var glow_intensity: float = 1.0:
	set(v): glow_intensity = clampf(v, 0.0, 10.0)
@export var canvas_item_material: CanvasItemMaterial
## 0 = Mix, 1 = Add, 2 = Sub, 3 = Mul (CanvasItem blend modes)
@export var blend_mode: int = 0
@export var opacity: float = 1.0:
	set(v): opacity = clampf(v, 0.0, 1.0)
@export var initial_rotation: float = 0.0
@export var pixel_snap: bool = true

# ---------------------------------------------------------------------------
# Movement
# ---------------------------------------------------------------------------
@export_group("Movement")
@export var movement_direction: LabelUpXEnums.MovementDirection = LabelUpXEnums.MovementDirection.UP
@export var movement_fan_spread_degrees: float = 90.0:
	set(v): movement_fan_spread_degrees = clampf(v, 1.0, 180.0)
@export var distance: float = 80.0:
	set(v): distance = maxf(0.0, v)
@export var duration: float = 1.2:
	set(v): duration = maxf(0.01, v)
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans_type: Tween.TransitionType = Tween.TRANS_QUAD
@export var movement_curve: Curve
@export var speed_multiplier: float = 1.0:
	set(v): speed_multiplier = maxf(0.01, v)

# ---------------------------------------------------------------------------
# Motion style
# ---------------------------------------------------------------------------
@export_group("Motion")
@export var motion_style: LabelUpXEnums.MotionStyle = LabelUpXEnums.MotionStyle.STRAIGHT
@export var amplitude: float = 10.0
@export var frequency: float = 4.0
@export var initial_scale: Vector2 = Vector2.ONE
@export var final_scale: Vector2 = Vector2.ONE
@export var rotation_amount: float = 0.0
@export var wiggle_intensity: float = 1.0
@export var shake_intensity: float = 1.0
@export var arc_height: float = 40.0

# ---------------------------------------------------------------------------
# Appear
# ---------------------------------------------------------------------------
@export_group("Appear")
@export var appear_animation: LabelUpXEnums.AppearAnimation = LabelUpXEnums.AppearAnimation.FADE_IN
@export var appear_duration: float = 0.15
@export var appear_overshoot: float = 1.2
@export var appear_initial_scale: Vector2 = Vector2(0.5, 0.5)
@export var appear_initial_opacity: float = 0.0

# ---------------------------------------------------------------------------
# Exit
# ---------------------------------------------------------------------------
@export_group("Exit")
@export var exit_animation: LabelUpXEnums.ExitAnimation = LabelUpXEnums.ExitAnimation.FADE_OUT
@export var exit_duration: float = 0.2
@export var exit_easing: Tween.EaseType = Tween.EASE_IN
@export var exit_trans_type: Tween.TransitionType = Tween.TRANS_QUAD

# ---------------------------------------------------------------------------
# Stacking & offset
# ---------------------------------------------------------------------------
@export_group("Stacking")
@export var spawn_jitter_x: float = 0.0
@export var spawn_jitter_y: float = 0.0
@export var stacking_offset: Vector2 = Vector2.ZERO
@export var stacking_enabled: bool = false
@export var z_index_offset: int = 0

# ---------------------------------------------------------------------------
# Follow target (optional) - set in code before show(); not serialized in Resource
# ---------------------------------------------------------------------------
@export_group("Follow")
var follow_target: Node2D
@export var follow_offset: Vector2 = Vector2.ZERO
@export var lock_to_world: bool = false

func _validate_property(property: Dictionary) -> void:
	pass

class_name LabelUpXEnums
extends RefCounted

enum MovementDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT,
	RANDOM,
	RANDOM_VERTICAL
}

enum MotionStyle {
	STRAIGHT,
	SHAKE,
	ARC,
	WIGGLE,
	SCALE_DOWN,
	SCALE_UP,
	SCALE_UP_THEN_DOWN,
	BOUNCE,
	CUSTOM
}

enum AppearAnimation {
	NONE,
	FADE_IN,
	SCALE_IN,
	POP,
	SCALE_AND_FADE
}

enum ExitAnimation {
	NONE,
	FADE_OUT,
	SCALE_OUT,
	SCALE_AND_FADE
}

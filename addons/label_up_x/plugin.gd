@tool
extends EditorPlugin

const AUTOLOAD_NAME = "LabelUpX"
const AUTOLOAD_PATH = "res://addons/label_up_x/runtime/label_up_x.gd"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)

class_name Loader
extends Control


static var next:LevelData


@export var debug_neverload := false


var _t:float = 0


@onready var p1:ProgressBar = %ProgressBar
@onready var p2:ProgressBar = %ProgressBar2

@onready var d1:Label = %d1
@onready var d2:Label = %d2
@onready var d3:Label = %d3


func _ready() -> void:
	if is_instance_valid(next):
		%Title.text = tr(next.title)
		%Subtitle.text = tr(next.subtitle)
	else:
		%Title.text = tr(&"levels.titles.unkown")
		%Subtitle.text = tr(&"levels.subtitles.unkown")
		debug_neverload = true

	if (!debug_neverload) and (!OS.has_feature("web")):
		var err := ResourceLoader.load_threaded_request(next.scenepath)
		print(err)
		assert(err == OK)


func _process(_delta:float) -> void:
	_t += _delta * 5
	var out:Array[float] = []
	if debug_neverload:
		out.append(remap(sin(_t), -1, 1, 0, 1))
	elif OS.has_feature("web"):
		var res:PackedScene = load(next.scenepath)
		get_tree().change_scene_to_packed.call_deferred(res)
	else:
		var stat := ResourceLoader.load_threaded_get_status(next.scenepath, out)
		print(stat)
		assert(stat != ResourceLoader.THREAD_LOAD_FAILED)
		assert(stat != ResourceLoader.THREAD_LOAD_INVALID_RESOURCE)
		if stat == ResourceLoader.THREAD_LOAD_LOADED:
			var res:PackedScene = ResourceLoader.load_threaded_get(next.scenepath)
			get_tree().change_scene_to_packed.call_deferred(res)
	p1.value = out[0]
	p2.value = out[0]
	d3.position.y = sin(_t) * 3
	d2.position.y = sin(_t + 1.0471975512) * 3
	d1.position.y = sin(_t + 2.0943951024) * 3
	d1.self_modulate.a = remap(d1.position.y, 3, -3, 0.5, 1)
	d2.self_modulate.a = remap(d2.position.y, 3, -3, 0.5, 1)
	d3.self_modulate.a = remap(d3.position.y, 3, -3, 0.5, 1)

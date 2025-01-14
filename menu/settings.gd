extends Node

enum GIQuality {
	DISABLED = 0,
	LOW = 1,
	HIGH = 2,
}

enum AAQuality {
	DISABLED = 0,
	AA_2X = 1,
	AA_4X = 2,
	AA_8X = 3,
}

enum SSAOQuality {
	DISABLED = 0,
	LOW = 1,
	HIGH = 2,
}

enum BloomQuality {
	DISABLED = 0,
	LOW = 1,
	HIGH = 2,
}

enum Resolution {
	RES_540 = 0,
	RES_720 = 1,
	RES_1080 = 2,
	NATIVE = 3,
}

var gi_quality = GIQuality.LOW
var aa_quality = AAQuality.AA_2X
var shadow_enabled = true
var fxaa = true
var ssao_quality = SSAOQuality.DISABLED
var bloom_quality = BloomQuality.HIGH
var resolution = Resolution.NATIVE
var fullscreen = true

func _ready():
	load_settings()


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
		get_viewport().set_input_as_handled()


func load_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.READ)
	var error = FileAccess.get_open_error()
	if error:
		print("There are no settings to load.")
		return

	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var d = test_json_conv.get_data()
	if typeof(d) != TYPE_DICTIONARY:
		return

	if "gi" in d:
		gi_quality = int(d.gi) as GIQuality

	if "aa" in d:
		aa_quality = int(d.aa) as AAQuality

	if "shadow_enabled" in d:
		shadow_enabled = bool(d.shadow_enabled)

	if "fxaa" in d:
		fxaa = bool(d.fxaa)

	if "ssao" in d:
		ssao_quality = int(d.ssao) as SSAOQuality

	if "bloom" in d:
		bloom_quality = int(d.bloom) as BloomQuality

	if "resolution" in d:
		resolution = int(d.resolution) as Resolution

	if "fullscreen" in d:
		fullscreen = bool(d.fullscreen)


func save_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	assert(not error)

	var d = { "gi":gi_quality, "aa":aa_quality, "shadow_enabled":shadow_enabled, "fxaa":fxaa, "ssao":ssao_quality, "bloom":bloom_quality, "resolution":resolution, "fullscreen":fullscreen }
	file.store_line(JSON.stringify(d))

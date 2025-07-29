class_name UIHandler
extends CanvasLayer


#region Variables
const HEALTH_METER_SCALE := 64
const HEALTH_METER_VARIANCE_REDUC := 40
const HEALTH_METER_VARIANCE_MAX := 64

var health_meter_variance := 0.0

static var load_scene:String = ""

@onready var health_meter:TextureRect = $"Control/HealthMeter"
#endregion


func _process(delta: float) -> void:
	if health_meter_variance > 0.0:
		health_meter_variance -= HEALTH_METER_VARIANCE_REDUC * delta
		if health_meter_variance <= 0.0:
			health_meter_variance = 0.0
		
		health_meter.size = Vector2(
			randf_range(HEALTH_METER_SCALE, HEALTH_METER_SCALE + health_meter_variance),
			randf_range(HEALTH_METER_SCALE, HEALTH_METER_SCALE + health_meter_variance)
		)


func set_health_meter_smooth(value: int) -> void:
	var tex:AtlasTexture = health_meter.texture
	tex.region.position.x = 64 * value


func set_health_meter_noisy(value: int) -> void:
	set_health_meter_smooth(value)
	health_meter_variance = HEALTH_METER_VARIANCE_MAX

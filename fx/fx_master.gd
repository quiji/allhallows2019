extends Node2D

const BulletCasing = preload("res://fx/bullet_casing.tscn")
const BulletHitSpark = preload("res://fx/bullet_hit_spark.tscn")
const BloodExplode = preload("res://fx/blood_explode.tscn")

onready var muzzle = $muzzle


var availible_bullet_hit_sparks = []
var availible_blood_explode_sparks = []

func _ready():
	
	Game.fx_master = self

	for i in range(8):
		var spark = BulletHitSpark.instance()
		add_child(spark)
		spark.connect("spark_finished", self, "_on_bullet_hit_spark_finished")
		availible_bullet_hit_sparks.push_back(spark)
		
		spark = BloodExplode.instance()
		add_child(spark)
		spark.connect("spark_finished", self, "_on_blood_explode_sparks")
		availible_blood_explode_sparks.push_back(spark)



func muzzle_spark(pos: Vector2, facing_right: bool) -> void:
	muzzle.spark(pos, facing_right)


func bullet_casing_spark(pos: Vector2, direction: Vector2, bullet_type: int) -> void:
	
	var casing = BulletCasing.instance()
	add_child(casing)

	casing.throw(pos, direction, bullet_type)

func bullet_hit_spark(pos: Vector2, direction: Vector2) -> void:
	if availible_bullet_hit_sparks.size() > 0:
		availible_bullet_hit_sparks.pop_front().spark(pos, direction)

func bullet_bleed_hit_spark(pos: Vector2, direction: Vector2) -> void:
	if availible_bullet_hit_sparks.size() > 0:
		availible_bullet_hit_sparks.pop_front().spark_blood(pos, direction)

func bullet_armored_hit_spark(pos: Vector2, direction: Vector2) -> void:
	if availible_bullet_hit_sparks.size() > 0:
		availible_bullet_hit_sparks.pop_front().spark_armored(pos, direction)


func blood_explode_spark(pos: Vector2) -> void:
	if availible_blood_explode_sparks.size() > 0:
		availible_blood_explode_sparks.pop_front().spark(pos)


func _on_bullet_hit_spark_finished(which) -> void:
	
	availible_bullet_hit_sparks.push_back(which)
	
func _on_blood_explode_sparks(which) -> void:
	
	availible_blood_explode_sparks.push_back(which)
	

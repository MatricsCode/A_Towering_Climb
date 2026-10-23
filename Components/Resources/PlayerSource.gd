extends Resource
class_name PlayerSource

@export_category("Animation")
@export var sprite_frame : SpriteFrames

@export_category("Abilities")
@export var main_ability : Script
@export var passive_ability_1 : Script
@export var passive_ability_2 : Script
@export var secret_ability : Script

@export_category("Multiplayer")
@export var player_name : String
@export var player_ID : int
@export var steam_ID : int

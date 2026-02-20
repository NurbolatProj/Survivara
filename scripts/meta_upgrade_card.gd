extends PanelContainer
class_name MetaUpgradeCard


@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_label: Label = %ProgressLabel
@onready var quantity_label: Label = %QuantityLabel

var upgrade: MetaUpgrade

func set_meta_upgrade(new_upgrade: MetaUpgrade):
	self.upgrade = new_upgrade
	name_label.text = new_upgrade.name
	description_label.text = new_upgrade.description
	update_progress()


func update_progress():
	var quantity = 0
	quantity = MetaProgression.get_upgrade_quantity(upgrade.id)
	var is_maxed = quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.cost
	percent = min(percent, 1) 
	progress_bar.value = percent 
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "str_Max"
	progress_label.text = str(currency) + "/" + str(upgrade.cost)
	quantity_label.text = "x" + str(quantity)


func _on_purchase_button_pressed() -> void:
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.cost
	MetaProgression.save_file()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	animation_player.play("selected")

class_name PostgamePanel
extends Panel

func set_contents(player : Player, final_blow_dealer : ICardInstance) -> void:
	var winner_label : Label = self.find_child("WinnerLabel")
	winner_label.text = ("Winner : %s" % player.name).to_upper()

	var final_blow_label : Label = self.find_child("FinalBlowLabel")
	final_blow_label.text = ("Final blow : %s" % final_blow_dealer.metadata.name).to_upper()
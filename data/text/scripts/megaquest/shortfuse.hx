runscript("megaquest/repeatcall", [
	function(args, actuator) {
		var _self = args[0];
		var _target = args[1];
		if (_self.getvar("mqshortfuse_init") == 0) {
			_self.setvar("mqshortfuse_init", 1);
			_self.setvar("mqshortfuse_target", actuator.startTime + _self.getvar("mqshortfuse_max") * 60);
		}
		if (_self.getvar("mqcombatend") == 1 || _target.getvar("mqcombatend") == 1 || _self.getvar("mqshortfuse_end") == 1) {
			actuator._repeat = 0;
		} else {
			_self.setvar("mqshortfuse_now", _self.getvar("mqshortfuse_target") - actuator.startTime - _self.getvar("mqshortfuse_reduce"));
			var seconds_now = runscript("megaquest/math/floor", [_self.getvar("mqshortfuse_now")]);
			if (seconds_now < _self.getvar("mqshortfuse_seconds_last_frame")) {
				var soundevent = "countdowntick_";
				if (seconds_now >= 4)
					soundevent += "above3";
				else if (seconds_now >= 3)
					soundevent += "3";
				else if (seconds_now >= 2)
					soundevent += "2";
				else if (seconds_now >= 1)
					soundevent += "1";
				if (seconds_now >= 1) {
					args[4](soundevent);
				} else {
					args[2](999);
					args[3](_target, 999);
					_self.setvar("mqshortfuse_end", 1);
				}
			}
			_self.setvar("mqshortfuse_seconds_last_frame", seconds_now);
			if (_self.equipment.length > 0)
				for (eq in _self.equipment)
					if (eq.hastag("mqshortfuse")) {
						eq.availablethisturn = false;
						eq.unavailabletext = "Time left:";
						var m = runscript("megaquest/math/floor", [_self.getvar("mqshortfuse_now") / 60]);
						var s = runscript("megaquest/math/floor", [_self.getvar("mqshortfuse_now")]) % 60;
						eq.unavailabledetails = [
							((s % 2) == 0 ? "[red]" : "") + (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
						];
					}
		}
	},
	0,
	-1,
	args[0], // self
	args[1], // target
	args[2], // attack
	args[3], // sfxdamage
	args[4] // sfx
]);

var _self = args[0];
var _attackself = args[1];
if (_self.getstatus(SHIELD) != null && _self.getstatus(SHIELD).value > _self.getvar("mqaoiferemix")) {
    _attackself(-3);
    sfx("_heal", "", 0.2);
}
_self.setvar("mqaoiferemix", _self.getstatus(SHIELD) != null ? _self.getstatus(SHIELD).value : 0);

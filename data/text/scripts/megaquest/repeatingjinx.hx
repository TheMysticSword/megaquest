var jinxtarget = args[4];
var index = jinxtarget.getvar("mqrepeatingjinx_index");
jinxtarget.setvar("mqrepeatingjinx_index", jinxtarget.getvar("mqrepeatingjinx_index") + 1);

var extrascript = "
    {
        var _mqrepeatingjinx_index = " + index + ";
        jinx(
            target.getvar(\"mqrepeatingjinx_name_\" + _mqrepeatingjinx_index),
            target.getvar(\"mqrepeatingjinx_desc_tooltip_\" + _mqrepeatingjinx_index),
            target.getvar(\"mqrepeatingjinx_desc_card_\" + _mqrepeatingjinx_index),
            target.getvar(\"mqrepeatingjinx_script_\" + _mqrepeatingjinx_index),
            target,
            self,
            target.getvar(\"mqrepeatingjinx_turns_\" + _mqrepeatingjinx_index),
            target.getvar(\"mqrepeatingjinx_var_\" + _mqrepeatingjinx_index)
        );
    }
";

jinxtarget.setvar("mqrepeatingjinx_name_" + index, args[0]);
jinxtarget.setvar("mqrepeatingjinx_desc_tooltip_" + index, args[1]);
jinxtarget.setvar("mqrepeatingjinx_desc_card_" + index, args[2]);
jinxtarget.setvar("mqrepeatingjinx_script_" + index, args[3] + extrascript);
jinxtarget.setvar("mqrepeatingjinx_turns_" + index, args[6]);
jinxtarget.setvar("mqrepeatingjinx_var_" + index, args[7]);

jinx(args[0], args[1], args[2], args[3] + extrascript, args[4], args[5], args[6], args[7]);

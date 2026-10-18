for (var i = 0; i <= 9; i++) {
    if (keyboard_check_pressed(ord("0") + i)) {
        new EvarrEvaluation(counter_setters[i], counter_context).evaluate();
    }
}

var _grammar = new EvarrGrammar()
    .with_reference_operator()
    .with_arithmetic_operators();

// evaluating a constant expression

var _expression = new EvarrBuilder(_grammar)
    .inval(2).inop("+")                                         // 2 +
    .open_group().inval(9).inop("/").inval(3).close_group()     // (9 / 3)
    .inop("*")                                                  // *
    .open_group().inval(4).inop("-").inval(5).close_group()     // (4 - 5)
    .complete();

var _evaluation = new EvarrEvaluation(_expression);
result = _evaluation.evaluate();

// evaluating a parameterised formula

var _distance_formula = new EvarrBuilder(_grammar)
    .inref("t").inop("*")                                   // t *
    .open_group()                                           // (
    .inref("v0").inop("+")                                  // v0 +
    .inref("acc").inop("*").inref("t").inop("/").inval(2)   // acc * t / 2
    .close_group()                                          // )
    .complete();

var _ctx1 = new EvarrContext({ t: 10, acc: 1, v0: 0 });
distance_1 = new EvarrEvaluation(_distance_formula, _ctx1).evaluate();

var _ctx2 = new EvarrContext({ t: 5, acc: 3, v0: 5 });
distance_2 = new EvarrEvaluation(_distance_formula, _ctx2).evaluate();

var _grammar = new EvarrGrammar().with_arithmetic_operators();

var _expression = new EvarrBuilder(_grammar)
    .inval(2).inop("+")                                         // 2 +
    .open_group().inval(9).inop("/").inval(3).close_group()     // (9 / 3)
    .inop("*")                                                  // *
    .open_group().inval(4).inop("-").inval(5).close_group()     // (4 - 5)
    .complete();

var _evaluation = new EvarrEvaluation(_expression);

result = _evaluation.evaluate();

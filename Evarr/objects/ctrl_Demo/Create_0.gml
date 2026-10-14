// 2 + 3 * 4 + 5 =>
// 2 3 4 * + 5 +
var _plus = new EvarrBinaryOperator("+", function(_left, _right) { return _left + _right; });
var _times = new EvarrBinaryOperator("*", function(_left, _right) { return _left * _right; });
var _expression = [2, 3, 4, _times, _plus, 5, _plus];
var _evaluation = new EvarrEvaluation(_expression);
result = _evaluation.evaluate();

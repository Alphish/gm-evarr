/// @desc An operator assigning or otherwise applying the right hand side value to the left hand side reference.
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Function} [operation]     The function producing a result from the left hand side and right hand side values.
function EvarrAssignmentOperator(_symbol, _operation = undefined) : EvarrOperator(_symbol, 2, 1) constructor {
    /// @ignore
    operation = _operation;
    
    /// @desc Applies the right hand side value to the left hand side value reference.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        var _right = _evaluation.pop_value();
        var _left = _evaluation.pop_reference();
        var _result = !is_undefined(operation) ? operation(_left.get_value(), _right) : _right;
        _left.set_value(_result);
        _evaluation.push_value(_result);
    }
}

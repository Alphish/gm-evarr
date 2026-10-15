/// @desc An operator taking two operands, like arithmetics or relations.
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Function} operation       The function producing a result from the input operands.
function EvarrBinaryOperator(_symbol, _operation) : EvarrOperator(_symbol, 2, 1) constructor {
    /// @ignore
    operation = _operation;
    
    /// @desc Takes two evaluation values and produces another value.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        // an error may occur if there are no operands remaining in the stack
        var _right = _evaluation.pop_value();
        var _left = _evaluation.pop_value();
        
        if (!is_undefined(_evaluation.error))
            return; // prevent further processing when not enough operands were found
        
        var _result = operation(_left, _right);
        _evaluation.push_value(_result);
    }
}

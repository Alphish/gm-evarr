/// @desc An operator applying a transformation on a single operand.
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Function} operation       The function producing a result from the input operands.
function EvarrUnaryOperator(_symbol, _operation) : EvarrOperator(_symbol, 1, 1) constructor {
    /// @ignore
    operation = _operation;
    
    /// @desc Takes an evaluation values and transforms it into another value.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        // an error may occur if there are no operands remaining in the stack
        var _operand = _evaluation.pop_value();
        if (!is_undefined(_evaluation.error))
            return; // prevent further processing when not enough operands were found
        
        var _result = operation(_operand, _evaluation.context);
        _evaluation.push_value(_result);
    }
}

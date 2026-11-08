/// @desc An operator taking a prior operand; if the operand is considered sufficient, the operator keeps it and skips the subsequent operands.
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Function} check           The check indicating whether the operand is sufficient.
function EvarrShortCircuitOperator(_symbol, _check) : EvarrOperator(_symbol,  1, 0) constructor {
    /// @ignore
    check = _check;
    
    /// @desc Takes an evaluation value and passes it if it's considered sufficient.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        var _operand = _evaluation.pop_value();
        var _skip_count = _evaluation.take_item();
        if (!is_undefined(_evaluation.error))
            return; // prevent further processing when not enough operands were found
        
        if (!check(_operand, _evaluation.context))
            return; // the operand is not sufficient, the evaluator will attempt to get the next value
        
        _evaluation.push_value(_operand);
        _evaluation.jump_by(_skip_count);
    }
}

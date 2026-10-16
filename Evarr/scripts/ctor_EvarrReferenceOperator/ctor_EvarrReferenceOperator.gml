/// @desc An operator delivering a value from the evaluation context.
/// @arg {String} symbol            The symbol identifying the operator.
function EvarrReferenceOperator(_symbol) : EvarrOperator(_symbol, 0, 1) constructor {
    
    /// @desc Resolves a value/variable with a given name.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to resolve the reference of.
    static apply = function(_evaluation) {
        var _key = _evaluation.take_item();
        var _result = _evaluation.context.get_value(_key);
        _evaluation.push_value(_result);
    }
}

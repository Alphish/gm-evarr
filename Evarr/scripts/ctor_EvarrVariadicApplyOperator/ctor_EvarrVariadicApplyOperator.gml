/// @desc An operator applying the given operation with an arbitrary number of arguments to the near-top source.
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Function} operation       The function producing a result given the source term, evaluation and number of applied terms..
function EvarrVariadicApplyOperator(_symbol, _operation) : EvarrOperator(_symbol, 1, 1) constructor {
    /// @ignore
    operation = _operation;
    
    /// @desc Applies the operation to the source with the given number of arguments.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        var _arity = _evaluation.take_item(); // the number of argument operands
        _evaluation.apply_args(operation, _arity);
    }
}

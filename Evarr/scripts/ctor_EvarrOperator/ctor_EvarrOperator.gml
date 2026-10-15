/// @desc A base operator to apply during the evaluation..
/// @arg {String} symbol            The symbol identifying the operator.
/// @arg {Real} arity               How many values the operator takes.
/// @arg {Real} coarity             How many values the operator pushes.
function EvarrOperator(_symbol, _arity, _coarity) constructor {
    /// @desc The symbol identifying the operator.
    /// @returns {String}
    symbol = _symbol;
    
    /// @desc The number of values taken by the operator.
    /// @returns {Real}
    arity = _arity;
    
    /// @desc The number of values pushed by the operator.
    /// @returns {Real}
    coarity = _coarity;
    
    /// @desc Performs the relevant operation within the given evaluation.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        throw EvarrException.not_implemented(self, nameof(apply));
    }
}

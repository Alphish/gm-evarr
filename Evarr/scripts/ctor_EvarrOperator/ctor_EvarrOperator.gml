/// @desc A base operator to apply during the evaluation..
/// @arg {String} symbol            The symbol identifying the operator.
function EvarrOperator(_symbol) constructor {
    /// @desc The symbol identifying the operator.
    /// @returns {String}
    symbol = _symbol;
    
    /// @desc Performs the relevant operation within the given evaluation.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to apply the operation to.
    static apply = function(_evaluation) {
        throw EvarrException.not_implemented(self, nameof(apply));
    }
}

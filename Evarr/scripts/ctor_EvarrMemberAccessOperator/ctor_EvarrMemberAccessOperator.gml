/// @desc An operator delivering a member of the nearby entity.
/// @arg {String} symbol            The symbol identifying the operator.
function EvarrMemberAccessOperator(_symbol) : EvarrOperator(_symbol, 1, 1) constructor {
    
    /// @desc Resolves a member with the given name.
    /// @arg {Struct.EvarrEvaluation} evaluation    The evaluation to resolve the member in.
    static apply = function(_evaluation) {
        var _owner = _evaluation.pop_value();
        var _member = _evaluation.take_item();
        var _reference = new EvarrMemberReference(_owner, _member);
        _evaluation.push_value(_reference);
    }
}

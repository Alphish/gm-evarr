/// @desc Wraps a short-circuiting operator to provide some grammar-specific context and expression building logic.
/// @arg {Struct.EvarrGrammar} grammar          The grammar the operator is defined for.
/// @arg {Struct.EvarrOperator} exoperator      The underlying expression operator.
/// @arg {String} type                          The type of the operator
/// @arg {Real} precedence                      The precedence of the operator.
function EvarrGrammarShortCircuitOperator(_grammar, _exoperator, _type, _precedence) : EvarrGrammarOperator(_grammar, _exoperator, _type, _precedence, /* right-associative */ true) constructor {
    /// @desc Performs immediate operator preparations to keep track of the operator skip argument position.
    /// @arg {Struct.EvarrBuilderGroup} buildgroup      The Evarr builder group the operator will be resolved for.
    static prepare = function(_buildgroup) {
        _buildgroup.push_expression_operator(expression_operator);
        var _skip_arg_index = _buildgroup.get_head_index();
        _buildgroup.push_operator_argument(undefined);
        
        _buildgroup.prepare_operator_metadata(_skip_arg_index);
    }
    
    /// @desc Adds the expression operator to the built expression. Other operations may be additionally performed.
    /// @arg {Struct.EvarrBuilderGroup} buildgroup      The Evarr builder group the operator will be resolved for.
    static resolve = function(_buildgroup) {
        var _skip_arg_index = _buildgroup.take_operator_metadata();
        
        // when the operator skip argument is at [N]
        // the skip will be performed when evaluator cursor is at [N+1]
        // because it will have advanced past the operator itself, and then taken the skip argument
        var _skip_from_index = _skip_arg_index + 1;
        
        var _skip_count = _buildgroup.get_head_index() - _skip_from_index;
        _buildgroup.replace_item_at(_skip_arg_index, _skip_count);
    }
}

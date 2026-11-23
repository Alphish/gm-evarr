/// @desc Wraps a primary operator to provide some grammar-specific context and expression building logic.
/// @arg {Struct.EvarrGrammar} grammar          The grammar the operator is defined for.
/// @arg {Struct.EvarrOperator} exoperator      The underlying expression operator.
/// @arg {String} type                          The type of the operator
function EvarrGrammarPrimaryOperator(_grammar, _exoperator, _type) : EvarrGrammarOperator(_grammar, _exoperator, _type, infinity, /* right-associative */ false) constructor {
    /// @desc Performs immediate operator preparations to keep track of the operator skip argument position.
    /// @arg {Struct.EvarrBuilderGroup} buildgroup      The Evarr builder group the operator will be resolved for.
    static prepare = function(_buildgroup) {
        _buildgroup.push_expression_operator(expression_operator);
        return true;
    }
    
    /// @desc Adds the expression operator to the built expression. Other operations may be additionally performed.
    /// @arg {Struct.EvarrBuilderGroup} buildgroup      The Evarr builder group the operator will be resolved for.
    static resolve = function(_buildgroup) {
        // no resolution is needed, as primary operators don't go into the stack
    }
}

/// @desc Wraps a sequence-based operator to provide some grammar-specific context and expression building logic.
/// @arg {Struct.EvarrGrammar} grammar          The grammar the operator is defined for.
/// @arg {Struct.EvarrOperator} exoperator      The underlying expression operator.
/// @arg {String} type                          The type of the operator
function EvarrGrammarSequenceOperator(_grammar, _exoperator, _type) : EvarrGrammarOperator(_grammar, _exoperator, _type, /* precedence */ infinity, /* right-associative */ false) constructor {
    
    /// @desc Adds the sequence-based operator to the built expression, along with the number of terms in the sequence.
    /// @arg {Struct.EvarrBuilderSequence} buildgroup       The Evarr builder group the operator will be resolved for.
    static resolve = function(_buildgroup) {
        _buildgroup.parent.push_expression_operator(expression_operator); // adding the operator to the parent, because that's the scope the operator is applied in
        _buildgroup.push_operator_argument(_buildgroup.terms_count); // adding the number of applied terms
    }
}

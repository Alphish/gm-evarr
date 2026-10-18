/// @arg {Struct.EvarrGrammar} grammar          The grammar the operator is defined for.
/// @arg {Struct.EvarrOperator} exoperator      The underlying expression operator.
/// @arg {String} type                          The type of the operator
/// @arg {Real} precedence                      The precedence of the operator.
/// @arg {Bool} [associativity]                 Whether the operator should be left-associative (false) or right-associative (true).
function EvarrGrammarOperator(_grammar, _exoperator, _type, _precedence, _associativity = false) constructor {
    /// @desc The grammar the operator belongs to.
    /// @returns {Struct.EvarrGrammar}
    grammar = _grammar;
    
    /// @desc The underlying expression oeprator.
    /// @returns {Struct.EvarrOperator}
    expression_operator = _exoperator;
    
    /// @desc The grammar operator type.
    /// @returns {String}
    type = _type;
    
    /// @desc The grammar operator precedence.
    /// @returns {Real}
    precedence = _precedence;
    
    /// @desc Indicates whether the operator should be left-associative (evaluating same precedence operations from left to right) or right-associative (from right to left).
    /// @returns {Bool}
    right_associative = _associativity;
    
    /// @desc Adds the expression operator to the built expression. Other operations may be additionally performed.
    /// @arg {Struct.EvarrBuilderGroup} buildgroup      The Evarr builder group the operator will be resolved for.
    static resolve = function(_buildgroup) {
        _buildgroup.push_expression_operator(expression_operator);
    }
}

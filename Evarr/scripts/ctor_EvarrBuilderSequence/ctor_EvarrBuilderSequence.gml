/// @desc An expression builder group gathering a sequence of terms to use with the given operator.
/// @arg {Struct.EvarrBuilderGroup} parent              The parent builder group. Set to undefined in the top-level group.
/// @arg {Struct.EvarrGrammarOperator} operator         The operator using the given terms sequence.
function EvarrBuilderSequence(_parent, _operator) : EvarrBuilderGroup(_parent.expression) constructor {
    /// @desc The parent expression builder group.
    /// @returns {Struct.EvarrBuilderGroup}
    parent = _parent;
    
    /// @desc The operator the expression builder collects terms for.
    /// @returns {Struct.EvarrGrammarOperator}
    operator = _operator;
    
    /// @desc The number of collected sequence terms.
    /// @returns {Real}
    terms_count = 0;
    
    /// @ignore
    last_separated_index = array_length(expression);
    
    // prepare the operator
    operator.prepare(self);
    
    /// @desc Adds the current subexpression as the sequence term and begins a new one. The separated subexpression must resolve to exactly one term.
    static separate = function() {
        resolve_remaining_operators();
        if (stack_balance != 1)
            throw EvarrException.builder_balance_invalid_close(self, "exactly one term", stack_balance);
        
        stack_balance -= 1;
        terms_count += 1;
        last_separated_index = array_length(expression);
    }
    
    /// @desc Resolves the operator the term sequence has been built for. Ensures the empty sequence case and the final sequence term are properly taken into account.
    static complete_close = function() {
        // separate any outstanding subexpression
        if (array_length(expression) > last_separated_index)
            separate();
        
        operator.resolve(self);
    }
}

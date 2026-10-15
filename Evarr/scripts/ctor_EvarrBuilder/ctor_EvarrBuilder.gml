/// @desc The builder for putting together expressions in a more convenient fashion than Reverse Polish Notation.
/// @arg {Struct.EvarrGrammar} grammar      The grammar the expression is defined in.
function EvarrBuilder(_grammar) constructor {
    /// @ignore
    grammar = _grammar;
    
    /// @ignore
    expression = [];
    
    /// @ignore
    current_group = new EvarrBuilderGroup(undefined, expression);
    
    /// @desc Inputs a value to be added to the stack.
    /// @arg {Any} value        The value to add.
    /// @returns {Struct.EvarrBuilder}
    static input_value = function(_value) {
        return inval(_value);
    }
    
    /// @desc Inputs a value to be added to the stack.
    /// @arg {Any} value        The value to add.
    /// @returns {Struct.EvarrBuilder}
    static inval = function(_value) {
        current_group.push_operand(_value);
        return self;
    }
    
    /// @desc Inputs a gramamr operator with the given symbol. The operator will be applied to the expression later, depending on the grammar rules.
    /// @arg {Any} symbol       The symbol of the operator to enter.
    /// @returns {Struct.EvarrBuilder}
    static input_operator = function(_symbol) {
        return inop(_symbol);
    }
    
    /// @desc Inputs a gramamr operator with the given symbol. The operator will be applied to the expression later, depending on the grammar rules.
    /// @arg {Any} symbol       The symbol of the operator to enter.
    /// @returns {Struct.EvarrBuilder}
    static inop = function(_symbol) {
        var _operator = grammar.get_operator(_symbol);
        current_group.handle_grammar_operator(_operator);
        return self;
    }
    
    /// @desc Begins a nested expression group, creating a new context for resolving operators. It's conceptually similar to parentheses in arithmetic/programming expressions.
    /// @returns {Struct.EvarrBuilder}
    static open_group = function() {
        current_group = current_group.open_nested();
        return self;
    }
    
    /// @desc Closes the nested expression group, going back to its outer group.
    /// @returns {Struct.EvarrBuilder}
    static close_group = function() {
        if (is_undefined(current_group.parent))
            throw EvarrException.builder_unmatched_group_close();
        
        current_group = current_group.close();
        return self;
    }
    
    /// @desc Finished building the expression and returns it.
    /// @returns {Array}
    static complete = function() {
        if (!is_undefined(current_group)) {
            if (!is_undefined(current_group.parent))
                throw EvarrException.builder_unclosed_group();
            
            current_group = current_group.close();
        }
        return expression;
    }
}

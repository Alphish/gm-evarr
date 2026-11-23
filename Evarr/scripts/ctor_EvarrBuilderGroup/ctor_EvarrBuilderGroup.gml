/// @desc An individual builder group, serving as a context for accumulating values and resolving grammar operators.
/// @arg {Array} expression                             The expression being built.
function EvarrBuilderGroup(_expression) constructor {
    /// @desc The parent expression builder group, if any.
    /// @returns {Struct.EvarrBuilderGroup}
    parent = undefined;
    
    /// @ignore
    expression = _expression;
    
    /// @ignore
    stack_balance = 0;
    
    /// @ignore
    pending_operators = [];
    
    /// @ignore
    pending_operator_metadata = [];
    
    /// @desc Retrieves the index of the upcoming item of the built expression.
    /// @returns {Real}
    static get_head_index = function() {
        return array_length(expression);
    }
    
    /// @desc Puts the given item at the given built expression index.
    /// @arg {Real} index           The index of the expression item.
    /// @arg {Any} item             The item to put in the built expression.
    static replace_item_at = function(_index, _item) {
        expression[_index] = _item;
    }
    
    /// @desc Adds the given operand at the end of the built expression.
    /// @arg {Any} operand
    static push_operand = function(_operand) {
        array_push(expression, _operand);
        stack_balance += 1;
    }
    
    /// @desc Adds the given expression operator at the end of the built expression.
    /// @arg {Struct.EvarrOperator} operator
    static push_expression_operator = function(_operator) {
        array_push(expression, _operator);
        stack_balance -= _operator.arity;
        if (stack_balance < 0)
            throw EvarrException.builder_balance_insufficient_values(_operator.arity, stack_balance + _operator.arity);
        
        stack_balance += _operator.coarity;
    }
    
    /// @desc Adds the given operator argument to the expression.
    /// @arg {Any} arg
    static push_operator_argument = function(_arg) {
        array_push(expression, _arg);
    }
    
    /// @desc Handles the given grammar operator, potentially resolving some pending operators before it and storing it for later.
    /// @arg {Struct.EvarrGrammarOperator} operator
    static handle_grammar_operator = function(_operator) {
        var _pending = array_last(pending_operators);
        while (!is_undefined(_pending) && _pending.grammar.should_resolve_pending_operator(_operator, _pending)) {
            array_pop(pending_operators);
            _pending.resolve(self);
            _pending = array_last(pending_operators);
        }
        
        var _resolved = _operator.prepare(self);
        if (!_resolved)
            array_push(pending_operators, _operator);
    }
    
    /// @desc Prepares additional metadata to resolve the upcoming operator.
    /// @arg {Any} metadata         The metadata entity to keep track of.
    static prepare_operator_metadata = function(_metadata) {
        array_push(pending_operator_metadata, _metadata);
    }
    
    /// @desc Takes the latest additional metadata for operator resolution.
    /// @returns {Any}
    static take_operator_metadata = function() {
        return array_pop(pending_operator_metadata);
    }
    
    /// @desc Creates a nested subexpression builder.
    /// @returns {Struct.EvarrBuilderSubexpression}
    static open_subexpression = function() {
        return new EvarrBuilderSubexpression(self);
    }
    
    /// @desc Creates a nested apply sequence builder.
    /// @returns {Struct.EvarrBuilderSequence}
    static open_apply = function(_operator) {
        return new EvarrBuilderSequence(self, _operator);
    }
    
    /// @desc Separates the current subexpression from a subsequent one. Only supported in sequence-based expression builder groups.
    static separate = function() {
        throw EvarrException.not_supported(self, nameof(separate));
    }
    
    /// @desc Closes the group and goes back to the parent.
    /// @returns {Struct.EvarrBuilderGroup}
    static close = function() {
        resolve_remaining_operators();
        complete_close();
        pending_operators = undefined;
        return parent; // return the parent to build the expression with from now on
    }
    
    /// @ignore
    static resolve_remaining_operators = function() {
        for (var i = array_length(pending_operators) - 1; i >= 0; i--) {
            pending_operators[i].resolve(self);
        }
    }
    
    /// @desc Performs final wrap-up tasks before closing the expression builder group.
    static complete_close = function() {
        throw EvarrException.not_implemented(self, nameof(complete));
    }
}

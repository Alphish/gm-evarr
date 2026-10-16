/// @desc An individual builder group, serving as a context for accumulating values and resolving grammar operators.
/// @arg {Struct.EvarrBuilderGroup} parent          The parent builder group. Set to undefined in the top-level group.
/// @arg {Array} expression                         The expression being built.
function EvarrBuilderGroup(_parent, _expression) constructor {
    /// @ignore
    parent = _parent;
    
    /// @ignore
    expression = _expression;
    
    /// @ignore
    stack_balance = 0;
    
    /// @ignore
    pending_operators = [];
    
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
        
        array_push(pending_operators, _operator);
    }
    
    /// @desc Creates a nested builder group.
    /// @returns {Struct.EvarrBuilderGroup}
    static open_nested = function() {
        return new EvarrBuilderGroup(self, expression);
    }
    
    /// @desc Closes the group and resolves any remaining operators.
    /// @returns {Struct.EvarrBuilderGroup}
    static close = function() {
        // resolve the remaining operators; no sane operator should be applied outside its expression group
        for (var i = array_length(pending_operators) - 1; i >= 0; i--) {
            pending_operators[i].resolve(self);
        }
        pending_operators = undefined;
        
        // ensure there are no problems with the stack balance
        var _has_parent = !is_undefined(parent);
        if (!_has_parent && stack_balance > 1)
            throw EvarrException.builder_balance_closing_expression(stack_balance);
        else if (_has_parent && stack_balance != 1)
            throw EvarrException.builder_balance_closing_group(stack_balance);
        
        if (_has_parent)
            parent.stack_balance += 1;
        
        return parent; // return the parent to build the expression with from now on
    }
}

// Verry tempted to call it EvarrGrammarr, but I will rresist

/// @desc Represents a grammar with operators of specific precedence and resolution rules.
function EvarrGrammar() constructor {
    /// @ignore
    precedence_layers = [];
    
    /// @ignore
    precedences_by_layer = {};
    
    /// @ignore
    operators_by_symbol = {};
    
    /// @desc Resolves a precedence. A number will be passed as-is; a layer name string will be resolved to that layer's precedence.
    /// @arg {Any} precedence           The precedence to resolve.
    /// @returns {Real}
    static get_precedence_value = function(_precedence) {
        if (!is_string(_precedence))
            return _precedence;
        
        var _value = precedences_by_layer[$ _precedence];
        if (is_undefined(_value))
            throw EvarrException.grammar_unknown_precedence(_precedence);
        
        return _value;
    }
    
    /// @desc Adds one or more precedence layers, with the earlier layers taking precedence over later ones.
    /// @arg {String} layer             The first layer to declare.
    /// @arg {String} [...rest]         The remaining layers, if any.
    /// @returns {Struct.EvarrGrammar}
    static with_precedence_layers = function(_layer) {
        if (!struct_exists(precedences_by_layer, _layer)) {
            precedences_by_layer[$ _layer] = -array_length(precedence_layers);
            array_push(precedence_layers, _layer);
        }
        
        for (var i = 1; i < argument_count; i++) {
            if (struct_exists(precedences_by_layer, argument[i]))
                continue;
            
            precedences_by_layer[$ argument[i]] = -array_length(precedence_layers);
            array_push(precedence_layers, argument[i]);
        }
        return self;
    }
    
    /// @desc Retrieves the grammar operator associated with the given symbol.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @returns {Struct.EvarrGrammarOperator}
    static get_operator = function(_symbol) {
        var _operator = operators_by_symbol[$ _symbol];
        if (is_undefined(_operator))
            throw EvarrException.grammar_unknown_operator(_symbol);
        
        return _operator;
    }
    
    /// @desc Retrieves the grammar operator associated with the given symbol, if any.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @returns {Struct.EvarrGrammarOperator}
    static try_get_operator = function(_symbol) {
        return operators_by_symbol[$ _symbol];
    }
    
    // -----------------
    // Generic operators
    // -----------------
    
    /// @desc Defines a primary grammar operator with a given type.
    /// @arg {Struct.EvarrOperator} operator        The underlying expression operator to use in the grammar.
    /// @arg {String} type                          The type of the grammar operator.
    /// @returns {Struct.EvarrGrammar}
    static with_primary_operator = function(_operator, _type = "primary") {
        // primary operators are resolved immediately
        // as such, they are not subject to operator precedence
        var _grammar_operator = new EvarrGrammarPrimaryOperator(self, _operator, _type);
        operators_by_symbol[$ _operator.symbol] = _grammar_operator;
        return self;
    }
    
    /// @desc Defines a sequence grammar operator with a given type, i.e. an operator that processes a nested sequence of terms.
    /// @arg {Struct.EvarrOperator} operator        The underlying expression operator to use in the grammar.
    /// @arg {String} type                          The type of the grammar operator.
    /// @returns {Struct.EvarrGrammar}
    static with_sequence_operator = function(_operator, _type = "primary") {
        // sequence operators are resolved at the end of expression builder group rather than within it
        // as such, they are not subject to operator precedence
        var _grammar_operator = new EvarrGrammarSequenceOperator(self, _operator, _type);
        operators_by_symbol[$ _operator.symbol] = _grammar_operator;
        return self;
    }
    
    /// @desc Defines a grammar operator with a given type. Optionally, the precedence may be specified.
    /// @arg {Struct.EvarrOperator} operator        The underlying expression operator to use in the grammar.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @arg {Bool} [associativity]                 Whether the operator should be left-associative (false) or right-associative (true).
    /// @returns {Struct.EvarrGrammar}
    static with_operator = function(_operator, _type, _precedence = undefined, _associativity = false) {
        _precedence = get_precedence_value(_precedence ?? _type);
        var _grammar_operator = new EvarrGrammarOperator(self, _operator, _type, _precedence, _associativity);
        operators_by_symbol[$ _operator.symbol] = _grammar_operator;
        return self;
    }
    
    /// @desc Defines a grammar unary operator with a given type. Optionally, the precedence may be specified.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @arg {Function} operation                   The operation to perform on the operand.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_unary_operator = function(_symbol, _operation, _type, _precedence = undefined) {
        var _operator = new EvarrUnaryOperator(_symbol, _operation);
        
        // since unary operator are placed before the operands and applied starting from the rightmost one,
        // they are treated as right-associative
        // e.g. given something like "opA opB opC operand" it will be evaluated as "opA (opB (opC operand)))"
        return with_operator(_operator, _type, _precedence, /* right-associative */ true);
    }
    
    /// @desc Defines a grammar binary operator with a given type. Optionally, the precedence may be specified.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @arg {Function} operation                   The operation to perform on the operands.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_binary_operator = function(_symbol, _operation, _type, _precedence = undefined) {
        var _operator = new EvarrBinaryOperator(_symbol, _operation);
        return with_operator(_operator, _type, _precedence, /* right-associative */ false);
    }
    
    /// @desc Defines a short-circuiting operator within the grammar.
    /// @arg {String} [symbol]                      The symbol to associate the reference operator with.
    /// @arg {Function} check                       The check determining if the current operand is sufficient.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_short_circuit_operator = function(_symbol, _check, _type, _precedence = undefined) {
        var _operator = new EvarrShortCircuitOperator(_symbol, _check);
        
        // short-circuit operators are always treated as right-associative
        // so all the pending operators are resolved when the builder reaches the final index of the short-circuiting subexpression
        _precedence = get_precedence_value(_precedence ?? _type);
        var _grammar_operator = new EvarrGrammarShortCircuitOperator(self, _operator, _type, _precedence);
        operators_by_symbol[$ _operator.symbol] = _grammar_operator;
        return self;
    }
    
    // -------
    // Presets
    // -------
    
    /// @desc Defines a direct value reference operator within the grammar.
    /// @arg {String} [symbol]                      The symbol to associate the direct reference operator with.
    /// @returns {Struct.EvarrGrammar}
    static with_direct_reference_operator = function(_symbol = "@") {
        var _operator = new EvarrDirectReferenceOperator(_symbol);
        return with_primary_operator(_operator);
    }
    
    /// @desc Defines a member access operator within the grammar.
    /// @arg {String} [symbol]                      The symbol to associate the member access operator with.
    /// @returns {Struct.EvarrGrammar}
    static with_member_access_operator = function(_symbol = ".") {
        var _operator = new EvarrMemberAccessOperator(_symbol);
        return with_primary_operator(_operator);
    }
    
    /// @desc Defines a method call operator within the grammar.
    /// @arg {String} [symbol]                      The symbol to associate the method call operator with.
    /// @returns {Struct.EvarrGrammar}
    static with_call_operator = function(_symbol = "(...)") {
        var _operator = new EvarrVariadicApplyOperator(_symbol, function(_source, _evaluation, _arity) {
            var _mtd = _source.get_method();
            var _operands = _evaluation.operand_stack;
            var _operands_from = _evaluation.operand_stack_count - _arity;
            return _arity > 0 ? method_call(_mtd, _operands, _operands_from, _arity) : _mtd();
        });
        return with_sequence_operator(_operator, /* allow empty */ true);
    }

    /// @desc Defines the minus sign operator within the grammar. If needed, the corresponding layer is declared.
    /// @arg {String} [type]                        The type/precedence layer of the operator; "unary" by default.
    /// @returns {Struct.EvarrGrammar}
    static with_minus_sign = function(_type = "unary") {
        with_precedence_layers(_type);
        return with_unary_operator("-x", function(_operand) { return -_operand; }, _type)
    }
    
    /// @desc Defines the logical NOT operator within the grammar. If needed, the corresponding layer is declared.
    /// @arg {String} [type]                        The type/precedence layer of the operator; "unary" by default.
    /// @returns {Struct.EvarrGrammar}
    static with_logical_not = function(_type = "unary") {
        with_precedence_layers(_type);
        return with_unary_operator("!x", function(_operand, _context) { return !_context.is_truthy(_operand); }, _type)
    }
    
    /// @desc Defines addition, subtraction, multiplication and division operators within the grammar. If needed, layers for addition and multiplication are declared.
    /// @arg {String} [multtype]                    The type/precedence layer of the multiplication and division operators; "multiplication" by default.
    /// @arg {String} [addtype]                     The type/precedence layer of the addition and subtraction operators; "addition" by default.
    /// @returns {Struct.EvarrGrammar}
    static with_arithmetic_operators = function(_multtype = "multiplication", _addtype = "addition") {
        with_precedence_layers(_multtype, _addtype);
        
        return with_binary_operator("+", function(_left, _right) { return _left + _right; }, _addtype)
            .with_binary_operator("-", function(_left, _right) { return _left - _right; }, _addtype)
            .with_binary_operator("*", function(_left, _right) { return _left * _right; }, _multtype)
            .with_binary_operator("/", function(_left, _right) { return _left / _right; }, _multtype);
    }
    
    /// @desc Defines conditional AND and conditional OR operators within the grammar. If needed, corresponding layers are declared.
    /// @arg {String} [andtype]                     The type/precedence layer of the conditional AND operator; "conditional_and" by default.
    /// @arg {String} [ortype]                      The type/precedence layer of the conditional OR operator; "conditional_or" by default.
    /// @returns {Struct.EvarrGrammar}
    static with_conditional_logical_operators = function(_andtype = "conditional_and", _ortype = "conditional_or") {
        with_precedence_layers(_andtype, _ortype);
        
        return with_short_circuit_operator("&&", function(_operand, _context) { return !_context.is_truthy(_operand); }, _andtype)
            .with_short_circuit_operator("||", function(_operand, _context) { return _context.is_truthy(_operand); }, _ortype);
    }
    
    /// @desc Defines a grammar assignment operator with the given type and optional precedence. If no operation is specified, a direct assignment will be defined.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @arg {Function} [operation]                 The optional operation to produce the assigned value based on both left and right hand sides.
    /// @arg {String} [type]                        The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_assignment_operator = function(_symbol, _operation = undefined, _type = "assignment", _precedence = undefined) {
        with_precedence_layers(_type);
        
        var _operator = new EvarrAssignmentOperator(_symbol, _operation);
        return with_operator(_operator, _type, _precedence, /* right-assicative */ true);
    }
    
    /// @desc Determines whether the incoming operator should cause the resolution of the topmost pending operator. By default, it relies on precedence and associativity. Can be overriden.
    /// @arg {Struct.EvarrGrammarOperator} incoming
    /// @arg {Struct.EvarrGrammarOperator} pending
    /// @returns {Bool}
    static should_resolve_pending_operator = function(_incoming, _pending) {
        return _pending.right_associative
            ? _pending.precedence > _incoming.precedence
            : _pending.precedence >= _incoming.precedence;
    }
}

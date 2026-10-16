// Verry tempted to call it EvarrGrammarr, but I will resist

/// @desc Represents a grammar with operators of specific precedence and resolution rules.
function EvarrGrammar() constructor {
    /// @ignore
    precedence_layers = [];
    
    /// @ignore
    precedences_by_layer = {};
    
    /// @ignore
    operators_by_symbol = {};
    
    /// @desc The operator used for referencing values.
    /// @arg {Struct.EvarrReferenceOperator}
    reference_operator = undefined;
    
    /// @desc Adds one or more precedence layers, with the earlier layers taking precedence over later ones.
    /// @arg {String} layer             The first layer to declare.
    /// @arg {String} [...rest]         The remaining layers, if any.
    /// @returns {Struct.EvarrGrammar}
    static with_precedence_layers = function(_layer) {
        precedences_by_layer[$ _layer] = -array_length(precedence_layers);
        array_push(precedence_layers, _layer);
        for (var i = 1; i < argument_count; i++) {
            precedences_by_layer[$ argument[i]] = -array_length(precedence_layers);
            array_push(precedence_layers, argument[i]);
        }
        return self;
    }
    
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
    
    /// @desc Defines a grammar operator with a given type. Optionally, the precedence may be specified.
    /// @arg {Struct.EvarrOperator} operator        The underlying expression operator to use in the grammar.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_operator = function(_operator, _type, _precedence = undefined) {
        _precedence = get_precedence_value(_precedence ?? _type);
        var _grammar_operator = new EvarrGrammarOperator(self, _operator, _type, _precedence);
        operators_by_symbol[$ _operator.symbol] = _grammar_operator;
        return self;
    }
    
    /// @desc Defines a basic value reference operator within the grammar.
    /// @arg {String} [symbol]                      The symbol to associate the reference operator with.
    /// @returns {Struct.EvarrGrammar}
    static with_reference_operator = function(_symbol = "@") {
        var _reference_operator = new EvarrReferenceOperator(_symbol);
        var _precedence = undefined; // the reference operator has no precedence, as it skips the store-and-resolve-later process altogether
        var _grammar_operator = new EvarrGrammarOperator(self, _reference_operator, "reference", _precedence);
        reference_operator = _grammar_operator;
        operators_by_symbol[$ _symbol] = _grammar_operator;
        return self;
    }
    
    /// @desc Defines a grammar binary operator with a given type. Optionally, the precedence may be specified.
    /// @arg {String} symbol                        The symbol of the operator.
    /// @arg {Function} operation                   The operation to perform on the operands.
    /// @arg {String} type                          The type of the grammar operator.
    /// @arg {Any} [precedence]                     The operator precedence; if not specified, the type will be used.
    /// @returns {Struct.EvarrGrammar}
    static with_binary_operator = function(_symbol, _operation, _type, _precedence = undefined) {
        var _operator = new EvarrBinaryOperator(_symbol, _operation);
        return with_operator(_operator, _type, _precedence);
    }
    
    /// @desc Defines addition, subtraction, multiplication and division operators within the grammar. If needed, layers for addition and multiplication are declared.
    /// @arg {String} [addtype]                     The type/layer of the addition and subtraction operators; "addition" by default.
    /// @arg {String} [multtype]                    The type/layer of the multiplication and division operators; "multiplication" by default.
    /// @returns {Struct.EvarrGrammar}
    static with_arithmetic_operators = function(_addtype = "addition", _multtype = "multiplication") {
        if (!struct_exists(precedences_by_layer, _multtype))
            with_precedence_layers(_multtype);
        
        if (!struct_exists(precedences_by_layer, _addtype))
            with_precedence_layers(_addtype);
        
        return with_binary_operator("+", function(_left, _right) { return _left + _right; }, _addtype)
            .with_binary_operator("-", function(_left, _right) { return _left - _right; }, _addtype)
            .with_binary_operator("*", function(_left, _right) { return _left * _right; }, _multtype)
            .with_binary_operator("/", function(_left, _right) { return _left / _right; }, _multtype);
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
    
    /// @desc Determines whether the incoming operator should cause the resolution of the topmost pending operator. By default, it largely relies on precedence. Can be overriden.
    /// @arg {Struct.EvarrGrammarOperator} incoming
    /// @arg {Struct.EvarrGrammarOperator} pending
    /// @returns {Bool}
    static should_resolve_pending_operator = function(_incoming, _pending) {
        return _pending.precedence >= _incoming.precedence;
    }
}

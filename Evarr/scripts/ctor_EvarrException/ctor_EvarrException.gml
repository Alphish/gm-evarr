/// @desc An exception to be thrown due to invalid Evarr usage.
/// @arg {String} code              The code of the exception to differentiate between different exception causes.
/// @arg {String} description       A detailed description explaining the exception.
function EvarrException(_code, _description) constructor {
    /// @desc The code of the exception to differentiate between different exception causes.
    /// @type {String}
    code = _code;
    
    /// @desc A detailed description explaining the exception.
    /// @type {String}
    description = _description;
    
    toString = function() {
        return $"Evarr.{code}: {description}";
    }
}

/// @desc Creates an Evarr method not implemented exception, thrown from base methods to be implemented in derived type.
/// @arg {Struct} context               The instance whose method was not implemented.
/// @arg {String} method                The name of method that requires implementation in the derived type.
/// @returns {Struct.EvarrException}
EvarrException.not_implemented = function(_context, _method) {
    return new EvarrException(
        nameof(not_implemented),
        $"{instanceof(_context)}.{_method} was not implemented."
        );
}

/// @desc Creates an Evarr operand stack empty exception, thrown when an operator requests an operand when no more are available.
/// @returns {Struct.EvarrException}
EvarrException.operand_stack_empty = function() {
    return new EvarrException(
        nameof(operand_stack_empty),
        $"An operand from the evaluation stack was requested, but no more operands are available."
        );
}

/// @desc Creates an Evarr operand not assignable exception, thrown when an operator requests an assignable reference, but receives a fixed or computed value instead.
/// @returns {Struct.EvarrException}
EvarrException.operand_not_assignable = function() {
    return new EvarrException(
        nameof(operand_not_assignable),
        $"An assignable reference was expected, but the evaluation stack had a fixed or computed value instead."
        );
}

/// @desc Creates an Evarr unknown value exception, thrown when attempting to access a value not available in the evaluation context.
/// @arg {String} key                   The key of the referenced value.
/// @returns {Struct.EvarrException}
EvarrException.unknown_value = function(_key) {
    return new EvarrException(
        nameof(unknown_value),
        $"Could not resolve a value reference to '{_key}'."
        );
}

/// @desc Creates an Evarr grammar unknown precedence exception, thrown when the given precedence could not be resolved.
/// @arg {Any} precedence               The precedence given to resolve.
/// @returns {Struct.EvarrException}
EvarrException.grammar_unknown_precedence = function(_precedence) {
    return new EvarrException(
        nameof(grammar_unknown_precedence),
        $"Could not resolve a precedence of {_precedence}."
        );
}

/// @desc Creates an Evarr grammar unknown operator exception, thrown when the grammar has no operator with the given symbol.
/// @arg {Any} symbol                   The operator symbol.
/// @returns {Struct.EvarrException}
EvarrException.grammar_unknown_operator = function(_symbol) {
    return new EvarrException(
        nameof(grammar_unknown_operator),
        $"Could not find a grammar operator with the symbol of {_symbol}."
        );
}

/// @desc Creates an Evarr builder unclosed group exception, thrown when completing an exception before closing all of nested groups.
/// @returns {Struct.EvarrException}
EvarrException.builder_unclosed_group = function() {
    return new EvarrException(
        nameof(builder_unclosed_group),
        $"Cannot complete an expression before closing all of its nested groups."
        );
}

/// @desc Creates an Evarr builder unmatched group close exception, thrown when attemting to close a nested expression group at the top level.
/// @returns {Struct.EvarrException}
EvarrException.builder_unmatched_group_close = function() {
    return new EvarrException(
        nameof(builder_unmatched_group_close),
        $"Cannot close a nested expression group when none is open."
        );
}

/// @desc Creates an Evarr builder balance insufficient values exception, thrown when the operator would require more inputs than the stack would contain.
/// @arg {Real} arity                   The arity (number of input values) of the operator.
/// @arg {Real} balance                 The number of values expected in the stack.
/// @returns {Struct.EvarrException}
EvarrException.builder_balance_insufficient_values = function(_arity, _balance) {
    return new EvarrException(
        nameof(builder_balance_insufficient_values),
        $"Attempting to add an operator taking {_arity} operands, when the expected number of available operands would be {_balance}."
        );
}

/// @desc Creates an Evarr builder expression closing balance exception, thrown when the values stack size at the end of the expression is more than 1.
/// @arg {Real} balance                 The expected stack size at the end of expression.
/// @returns {Struct.EvarrException}
EvarrException.builder_balance_closing_expression = function(_balance) {
    return new EvarrException(
        nameof(builder_balance_closing_expression),
        $"The expected stack size at the end of the top-level expression group is {_balance}, when it should be no more than one."
        );
}

/// @desc Creates an Evarr builder group closing balance exception, thrown when the values stack size at the end of a nested expression group is other than 1.
/// @arg {Real} balance                 The expected stack size at the end of expression.
/// @returns {Struct.EvarrException}
EvarrException.builder_balance_closing_group = function(_balance) {
    return new EvarrException(
        nameof(builder_balance_closing_group),
        $"The expected stack size at the end of a nested expression group is {_balance}, when it should be exactly one."
        );
}

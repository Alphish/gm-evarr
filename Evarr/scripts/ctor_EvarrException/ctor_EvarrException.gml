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

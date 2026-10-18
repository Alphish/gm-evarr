/// @desc A reference to a value in the evaluation context.
/// @arg {Struct.EvarrContext} context      The context the value is in.
/// @arg {String} key                       The key of the context value/variable.
function EvarrContextReference(_context, _key) : EvarrReference() constructor {
    /// @ignore
    context = _context;
    
    /// @ignore
    key = _key;
    
    /// @desc Gets the context value.
    static get_value = function() {
        return context.get_value(key);
    }
    
    /// @desc Assigns the given value to the context variable.
    /// @arg {Any} value            The new value to assign.
    static set_value = function(_value) {
        return context.set_variable(key, _value);
    }
}

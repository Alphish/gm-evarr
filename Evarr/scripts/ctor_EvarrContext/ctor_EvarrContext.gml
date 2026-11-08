/// @d3esc The context used for resolving and changing values.
function EvarrContext(_values) constructor {
    /// @ignore
    values = _values;
    
    /// @desc Retrieves a value with the given key, or returns undefined if no such value is present.
    /// @arg {String} key           The key of the value to retrieve.
    /// @returns {Any}
    static try_get_value = function(_key) {
        return values[$ _key];
    }
    
    /// @desc Retrieves a value with the given key. If no such value is present, an exception is thrown.
    /// @arg {String} key           The key of the value to retrieve.
    /// @returns {Any}
    static get_value = function(_key) {
        var _result = values[$ _key];
        if (is_undefined(_result) && !struct_exists(values, _key))
            throw EvarrException.unknown_value(_key);
        
        return _result;
    }
    
    /// @desc Sets a variable with the given key to the given value. If no such variable is present, an exception is thrown.
    /// @arg {String} key           The key of the variable set.
    /// @arg {Any} value            The new value to set.
    /// @returns {Any}
    static set_variable = function(_key, _value) {
        if (!struct_exists(values, _key))
            throw EvarrException.unknown_value(_key);
        
        values[$ _key] = _value;
    }
    
    /// @desc Determines whether the given value should be treated as true or false when used as a boolean.
    /// @arg {Any} value            The value to determine the truthiness of.
    /// @returns {Bool}
    static is_truthy = function(_value) {
        if (is_bool(_value))
            return _value; // bools are self-explanatory
        else if (is_undefined(_value ?? undefined) || is_nan(_value))
            return false; // obviously bad values
        else if (is_string(_value))
            return _value != ""; // following JS convention, empty string is considered falsy
        else if (is_handle(_value))
            return _value >= 0; // zero handles can represent proper objects, too
        else if (is_numeric(_value))
            return !!_value; // following GM idea of numerics truthiness
        else
            return true; // all other types, like arrays and structs, are expected to be always truthy even if empty
    }
}

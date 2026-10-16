function EvarrContext(_values) constructor {
    values = _values;
    
    static get_value = function(_key) {
        var _result = values[$ _key];
        if (is_undefined(_result))
            throw EvarrException.unknown_value(_key);
        
        return _result;
    }
    
    static try_get_value = function(_key) {
        return values[$ _key];
    }
}

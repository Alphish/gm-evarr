/// @desc A base for assignable references.
function EvarrReference() constructor {
    /// @desc Retrieves the referenced value.
    /// @returns {Any}
    static get_value = function() {
        throw EvarrException.not_implemented(self, nameof(get_value));
    }
    
    /// @desc Assigns a new value to the referenced variable.
    /// @arg {Any} value            The new value to assign.
    static set_value = function(_value) {
        throw EvarrException.not_implemented(self, nameof(set_value));
    }
}

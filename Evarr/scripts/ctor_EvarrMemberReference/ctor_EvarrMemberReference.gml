/// @desc A reference to a member of a complex entity.
/// @arg {Struct} owner                     The entity the member belongs to.
/// @arg {String} member                    The key specifying the member.
function EvarrMemberReference(_owner, _member) : EvarrReference() constructor {
    /// @ignore
    owner = _owner;
    
    /// @ignore
    member = _member;
    
    // reporting a missing reference early on
    if (!struct_exists(owner, member))
        throw EvarrException.unknown_value(member);
    
    /// @desc Gets the member value.
    /// @returns {Any}
    static get_value = function() {
        return owner[$ member];
    }
    
    /// @desc Assigns a new member value.
    /// @arg {Any} value            The new value to assign.
    static set_value = function(_value) {
        owner[$ member] = _value;
    }
}

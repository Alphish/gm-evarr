/// @desc An expression builder group corresponding to a simple nested subexpression.
/// @arg {Struct.EvarrBuilderGroup} parent      The parent expression builder group.
function EvarrBuilderSubexpression(_parent) : EvarrBuilderGroup(_parent.expression) constructor {
    /// @desc The parent expression builder group.
    /// @returns {Struct.EvarrBuilderGroup}
    parent = _parent;
    
    /// @desc Ensures the produced subexpression yields exactly one term when evaluated.
    static complete_close = function() {
        if (stack_balance != 1)
            throw EvarrException.builder_balance_invalid_close(self, "exactly one term", stack_balance);
        
        parent.stack_balance += 1;
    }
}

/// @desc The top-level expression builder group, covering the entire built expression.
/// @arg {Array} expression         The expression being built.
function EvarrBuilderRoot(_expression) : EvarrBuilderGroup(_expression) constructor {
    
    /// @desc Ensures the produced expression yields no more than one term when evaluated.
    static complete_close = function() {
        if (stack_balance > 1)
            throw EvarrException.builder_balance_invalid_close(self, "zero or one term", stack_balance);
    }
}

/// @desc The expression evaluation process.
/// @arg {Array} expression                 The expression being evaluated.
/// @arg {Struct.EvarrContext} context      The evaluation context.
function EvarrEvaluation(_expression, _context = undefined) constructor {
    /// @desc The expression being evaluated.
    /// @returns {Array}
    expression = _expression;
    
    /// @desc The evaluation context.
    /// @returns {Struct.EvarrContext}
    context = _context;
    
    /// @desc Indicates the evaluation status; 0 when in progress, positive when completed, negative when failed.
    /// @returns {Real}
    status = 0;
    
    /// @desc The evaluation result.
    /// @returns {Any}
    result = undefined;
    
    /// @desc The evaluation error description.
    /// @returns {String}
    error = undefined;
    
    /// @ignore
    index = 0;
    
    /// @ignore
    count = array_length(expression);
    
    /// @ignore
    stack = undefined;
    
    /// @ignore
    stack_count = 0;
    
    /// @desc Prepares the values stack for evaluation.
    static init = function() {
        stack = [];
    }
    
    /// @desc Processes the next expression item.
    /// @returns {Bool}
    static process_step = function() {
        if (status != 0)
            return true;
        else if (index >= count)
            return complete();
        
        var _item = expression[index++];
        if (is_instanceof(_item, EvarrOperator))
            _item.apply(self); // process the operator
        else
            stack[stack_count++] = _item; // push the non-operator value onto a stack
        
        return false;
    }
    
    /// @desc Takes the next expression item and advances. Can be used for parameterised operators.
    /// @returns {Any}
    static take_item = function() {
        return expression[index++];
    }
    
    /// @desc Stores an intermediate value for later processing.
    static push_value = function(_value) {
        stack[stack_count++] = _value;
    }
    
    /// @desc Removes and returns the topmost intermediate value.
    /// @returns {Any}
    static pop_value = function() {
        if (stack_count == 0) {
            status = -1;
            error = "The operation requires more operands than available.";
            return undefined;
        }
        
        var _value = stack[stack_count - 1];
        stack[--stack_count] = undefined;
        return _value;
    }
    
    /// @ignore
    static complete = function() {
        if (stack_count > 1) {
            status = -1;
            error = "Incomplete evaluation: more than one value remains in the stack.";
        } else {
            status = 1;
            result = stack_count == 1 ? stack[0] : undefined;
        }
        return true;
    }
    
    /// @desc Immediately evaluates the remained of the expression and returns the result, if any.
    /// @returns {Any}
    static evaluate = function() {
        if (status != 0)
            return result;
        
        if (is_undefined(stack))
            init();
        
        while (!process_step()) {}
        return result;
    }
    
    /// @desc Gets the current estimated evaluation progress.
    /// @returns {Real}
    static get_progress_value = function() {
        return index;
    }
    
    /// @desc Gets the total progress to compare the current progress to.
    /// @returns {Real}
    static get_progress_total = function() {
        return count;
    }
    
    /// @desc Indicates whether the evaluation has finished or not.
    /// @returns {Bool}
    static is_finished = function() {
        return status != 0;
    }
    
    /// @desc Cleans up the processing stack.
    static cleanup = function() {
        if (is_undefined(stack))
            return;
        
        array_resize(stack, 0); // eagerly releasing the stack array memory
        stack = undefined; // dereferencing the stack array
    }
}

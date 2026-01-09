# GitHub Copilot Instructions for AcreetionOS Kernel Development

This file provides guidelines for GitHub Copilot when assisting with code generation and modification in the AcreetionOS Linux kernel project.

## Copyright and Licensing

**ALWAYS** include the following header in every new file created:

```c
/* SPDX-License-Identifier: GPL-2.0 */
/*
 * [Brief file description]
 * Copyright (c) ArttulOS Project
 *
 * [Additional file description if needed]
 */
```

For C source files (.c):
```c
// SPDX-License-Identifier: GPL-2.0
/*
 * [Brief file description]
 * Copyright (c) ArttulOS Project
 *
 * [Additional file description if needed]
 */
```

## Coding Standards

### Language and Style
- **Strict C11/C89 compliance**: Use kernel-style C (GNU89)
- **No C++ features**: This is pure C code
- **No floating-point operations** in kernel space
- Follow Linux kernel coding style (as documented in the kernel's Documentation/process/coding-style.rst)

### Memory Safety - HIGHEST PRIORITY
1. **Always check return values** from memory allocation functions
2. **Use bounds checking** for all array accesses
3. **Initialize all variables** before use
4. **Validate all pointers** before dereferencing
5. **Check buffer sizes** before copying data
6. **Use safe string functions**: Prefer `strscpy()` over `strcpy()`, `snprintf()` over `sprintf()`

### Defensive Programming Patterns

#### Memory Allocation
```c
/* GOOD - Always check allocation results */
ptr = kmalloc(size, GFP_KERNEL);
if (!ptr) {
    pr_err("Failed to allocate memory\n");
    return -ENOMEM;
}

/* Initialize allocated memory */
memset(ptr, 0, size);
```

#### Pointer Validation
```c
/* GOOD - Always validate pointers */
if (!ptr) {
    pr_err("Invalid pointer\n");
    return -EINVAL;
}
```

#### Array Bounds
```c
/* GOOD - Check bounds before access */
if (index >= array_size) {
    pr_err("Index out of bounds\n");
    return -EINVAL;
}
value = array[index];
```

#### String Operations
```c
/* GOOD - Use safe string functions */
strscpy(dest, src, sizeof(dest));

/* GOOD - Always null-terminate */
dest[sizeof(dest) - 1] = '\0';
```

#### Resource Cleanup
```c
/* GOOD - Always clean up resources */
ptr = kmalloc(size, GFP_KERNEL);
if (!ptr)
    return -ENOMEM;

/* ... use ptr ... */

/* Cleanup */
kfree(ptr);
ptr = NULL;  /* Prevent use-after-free */
```

### Error Handling
- **Return appropriate error codes**: Use standard Linux error codes (e.g., -ENOMEM, -EINVAL, -EIO)
- **Log errors appropriately**: Use pr_err(), pr_warn(), pr_info(), pr_debug()
- **Clean up on error paths**: Free allocated resources before returning errors
- **Use goto for cleanup**: Centralize cleanup code in error handling

```c
/* GOOD - Centralized cleanup */
int function(void)
{
    struct resource *res = NULL;
    int ret = 0;

    res = allocate_resource();
    if (!res) {
        ret = -ENOMEM;
        goto err_alloc;
    }

    ret = perform_operation(res);
    if (ret)
        goto err_operation;

    return 0;

err_operation:
    free_resource(res);
err_alloc:
    return ret;
}
```

### Integer Operations
- **Check for overflow**: Use `check_add_overflow()`, `check_mul_overflow()`, etc.
- **Use appropriate types**: Match variable types to their usage
- **Be careful with signed/unsigned**: Avoid mixing signed and unsigned in comparisons

### Concurrency and Locking
- **Document locking requirements**: Comment which locks protect which data
- **Hold locks for minimal time**: Don't perform blocking operations while holding spinlocks
- **Use appropriate lock types**: Spinlocks for short critical sections, mutexes for longer ones
- **Prevent deadlocks**: Acquire locks in consistent order

### Comments and Documentation
- **Document complex algorithms**: Explain *why*, not just *what*
- **Use kernel-doc format** for function documentation
- **Keep comments up-to-date**: Update comments when changing code
- **Document assumptions**: State preconditions and postconditions

```c
/**
 * function_name - Brief description
 * @param1: Description of parameter 1
 * @param2: Description of parameter 2
 *
 * Detailed description of what the function does.
 *
 * Return: Description of return value
 */
```

### Project-Specific Guidelines

#### High Availability Focus
- **Fail gracefully**: Handle errors without crashing
- **Validate all inputs**: Never trust user-space or hardware data
- **Use defensive assertions**: Check invariants with BUG_ON/WARN_ON appropriately
- **Implement proper error recovery**: Try to recover from errors when possible

#### Accessibility Considerations
- **Clear error messages**: Make diagnostic output understandable
- **Avoid obscure abbreviations**: Use clear, descriptive names
- **Consistent interfaces**: Follow established patterns in the codebase

#### Hardware Enablement (HWE)
- **Support modern hardware**: Prioritize current hardware standards
- **Maintain backward compatibility**: Don't break support for older hardware unnecessarily
- **Document hardware quirks**: Note any hardware-specific workarounds

## Prohibited Practices

1. **Never use floating-point** operations (including SSE/AVX instructions in kernel space)
2. **Never ignore return values** from functions that can fail
3. **Never use unsafe functions**: strcpy, strcat, sprintf, gets
4. **Never assume memory is zero-initialized** unless explicitly cleared
5. **Never dereference NULL pointers**
6. **Never introduce race conditions**: Always protect shared data
7. **Never leak resources**: Always free allocated memory/handles
8. **Never use magic numbers**: Define constants with meaningful names

## Build and Test Requirements

- **Code must compile without warnings** with `-Wall -Werror`
- **Static analysis must pass**: No sparse warnings
- **Code must pass checkpatch.pl**: Follow kernel style guidelines
- **All changes must include appropriate tests** when applicable

## Security

- **Input validation is mandatory**: Validate all data from user space or hardware
- **No buffer overflows**: Check all buffer operations
- **No integer overflows**: Validate arithmetic operations
- **Proper privilege checking**: Verify permissions before operations
- **Sanitize output**: Prevent information leaks

## Priority Order for Code Quality

1. **Security**: No vulnerabilities
2. **Memory safety**: No memory corruption
3. **Correctness**: Code does what it should
4. **Stability**: Handles errors gracefully
5. **Performance**: Efficient implementation
6. **Readability**: Clear and maintainable

---

*These guidelines ensure the AcreetionOS kernel maintains the highest standards for stability, security, and accessibility.*

**Copyright (c) ArttulOS Project**

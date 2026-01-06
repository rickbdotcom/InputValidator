# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

InputValidator is a Swift Package for building composable, real-time input validation in SwiftUI applications. It provides a declarative, protocol-based validation system integrated with SwiftUI's property wrapper and binding mechanisms.

## Build & Test Commands

### Building
```bash
swift build
```

### Running Tests
```bash
swift test
```

### Running a Single Test
```bash
swift test --filter <test-name>
```

### Opening in Xcode
```bash
open Package.swift
```

The example app can be opened separately:
```bash
open Examples/InputValidation/InputValidation.xcodeproj
```

## Architecture

### Core Protocol: InputRule

The entire validation system is built around the `InputRule` protocol (Sources/InputValidator/InputRule.swift:10):

```swift
public protocol InputRule<Value> {
    associatedtype Value: Equatable
    func callAsFunction(_ value: inout Value) throws
}
```

**Key Design Principles:**
- Rules are **callable** - they implement `callAsFunction` for ergonomic syntax
- Rules operate on **inout** parameters - allowing both validation and transformation
- Rules communicate errors via **thrown exceptions**
- Rules are **composable** - can be combined with logical operators

### Type-Erased Wrapper: AnyInputRule

`AnyInputRule<Value>` wraps any `InputRule` conforming type, enabling storage and composition of heterogeneous rules. All concrete rule implementations return `AnyInputRule`.

### SwiftUI Integration: @Validate Property Wrapper

The `@Validate` property wrapper (Sources/InputValidator/Validate.swift:12) bridges validation rules with SwiftUI:

- Wraps a `StateObject` containing the value, rule, and error state
- Provides a `Binding` via `projectedValue` for use with SwiftUI controls
- Exposes `error`, `displayError`, `isValid`, and `validate()` for UI feedback
- Implements `DynamicProperty` to participate in SwiftUI's update cycle

**Key Behavior:**
- Validation is **lazy** - rules are only executed when `validate()` is called
- The rule can **mutate** the value (e.g., formatting, filtering) and also throw errors
- Error state is managed separately from error display (for UX control)

### Rule Categories

Rules are organized by the types they operate on:

1. **StringInputRules.swift** - String-specific validation and transformation
   - Length constraints (`minimumLength`, `maximumLength`)
   - String matching and filtering
   - Text normalization (`removeSmartPunctuation`, `removeDiacritics`)

2. **ComparableInputRules.swift** - Type-agnostic comparison rules
   - Numeric/comparable constraints (`greaterThan`, `lessThan`, `range`)
   - Equality checks with optional String comparison options

3. **RegexInputRules.swift** - Pattern matching
   - Validation via `wholeMatch`
   - Character filtering via regex

4. **LogicalInputRules.swift** - Rule composition
   - `and` - all rules must pass
   - `or` - at least one rule must pass
   - `not` - inverts rule result

5. **MonthYearRules.swift** - Specialized date input
   - `monthYear()` - formats input as MM/YY
   - `monthYear(validate:)` - validates formatted dates

### Validation Patterns

**Two-Phase Validation:**
Rules can both transform (via mutation) and validate (via throwing):

```swift
// First filters, then validates minimum length
.and([
    .filter { $0.isNumber },
    .minimumLength(4, error: ValidationError.tooShort)
])
```

**Conditional Validation:**
Rules can autocorrect or throw errors based on an `error` parameter:

```swift
// Without error: clamps value to range
.range(1...100, error: nil)

// With error: throws if out of range
.range(1...100, error: ValidationError.outOfRange)
```

**Dynamic Rules:**
The rule property on `@Validate` is mutable, enabling password confirmation patterns where the comparison target changes dynamically (see Examples/InputValidation/InputValidation/FieldValidation.swift:57-75).

## Platform Support

- iOS 16+
- macOS 14+
- tvOS 16+
- watchOS 9+

Uses Swift 6.1 language features.

## Common Patterns

### Creating Custom Rules

Extend `InputRule` with static factory methods returning `AnyInputRule<Value>`:

```swift
extension InputRule where Value == String {
    static func myRule() -> AnyInputRule<Value> {
        .init { value in
            // Transform value
            value = value.trimmingCharacters(in: .whitespaces)

            // Validate
            guard value.count > 0 else {
                throw MyError.empty
            }
        }
    }
}
```

### Composing Rules

Use `.and()` to combine multiple rules:

```swift
@Validate(.and([
    .minimumLength(8, error: ValidationError.tooShort),
    .wholeMatch(/[A-Za-z0-9]+/, error: ValidationError.invalidChars)
])) var username = ""
```

### Disabling Buttons

Use the variadic `disabled(_:)` View extension to disable submission when any validation fails:

```swift
Button("Submit") { }
    .disabled(_field1, _field2, _field3)
```

Note: Use the underscore prefix to pass the `Validate` property wrapper itself, not its value.

## Testing

Tests use Swift Testing framework (not XCTest). The test file (Tests/InputValidatorTests/InputValidatorTests.swift) currently contains only a placeholder test.

When adding tests:
- Import `@testable import InputValidator`
- Use `@Test` attribute on test functions
- Use `#expect(...)` for assertions

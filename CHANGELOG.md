## 1.1.1

### Documentation
- **Enterprise README Overhaul**: Completely redesigned the layout and typography of the package documentation for enhanced readability.
- **Enhanced Showcases**: Added comprehensive, side-by-side comparisons demonstrating declarative control flows, responsive spacing, scoped configurations, and declarative layout structures.
- **Modern Dart Styles**: Updated code examples to use modern Dart shorthands (`.all()` for padding and `.topLeft` alignments) and improved null-safe expression chaining.
- **Configuration Guides**: Added guidance on globally customizing breakpoints, scale factors, and spacing design tokens at app startup.

## 1.1.0

### Added
- **Responsive Layout Engine (`Fit<T>`)**: Viewport-aware layout token container matching portrait (`port`), landscape (`land`), and wide (`wide`) screen bounds.
- **Auto-Calculated Spacing Tokens (`Space`)**: Semantic layout tokens (`tiny`, `mini`, `small`, `base`, `medium`, `large`, `huge`) that scale up dynamically based on global multipliers.
- **Adaptive Spacing Override (`Fit.adaptive`)**: Back-calculates baseline dimensions at runtime to prevent double-scaling layout parameters.
- **Scale Configurations (`Breakpoints`)**: Mutable global breakpoint scaling factors (`Breakpoints.land`, `Breakpoints.wide`) that can be customized dynamically at app startup.

### Changed
- Re-architected and polished the example app in `example/lib/main.dart` into a clean modular layout (`App`, `Home`, `Banner`, `Profile`) demonstrating the integration of all scope functions, conditional selectors, and spacing tokens.

## 1.0.1

### Added
- Interactive showcase Flutter app in `example/main.dart` demonstrating all package utilities.

### Fixed
- Missing documentation comments for `MagicBooleanExtension`.

## 1.0.0

### Added
- Initial release of `lumu_evolve` containing core productivity extension engines.
- **MagicObject**: Scope functions and null-safety helpers on nullable objects:
  - `let`: Execute a block on the object if not null and return the result.
  - `also`: Execute a side-effect block on the object if not null and return the object itself.
  - `or`: Fluent fallback values for nullable types.
- **MagicBoolean**: Fluent conditional selectors on nullable booleans:
  - `when`: Map boolean states to values.
  - `pick`: Select between two lazy values based on boolean evaluation.

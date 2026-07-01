# lumu_evolve

Evolve your Dart and Flutter development with fluent scope functions, conditional selectors, compile-time responsive tokens, and null-safety helpers. Designed for clean, linear, and self-documenting codeflows, `lumu_evolve` eliminates nested ternaries, boilerplate viewports, and repetitive layout logic.

---

## ⚡ The Developer Experience (DX) Difference

### 1. Cleaner Booleans & Functional Flow

#### Without `lumu_evolve` (Verbose & Nested)
```dart
Widget buildHeader(User? user, bool isCompact) {
  // Nested ternary checks
  final name = user != null ? user.name : "Guest";
  
  // Verbose widget branch evaluation
  return Container(
    color: isCompact ? Colors.blue : Colors.grey,
    child: isCompact 
      ? const Icon(Icons.phone_iphone) 
      : buildLargeHeaderWidget(name),
  );
}
```

#### With `lumu_evolve` (Fluent & Linear)
```dart
Widget buildHeader(User? user, bool isCompact) {
  // Safe extraction with .or
  final name = user?.name.or("Guest");
  
  // Inline mapping and lazy evaluation with .when and .pick
  return Container(
    color: isCompact.when(then: Colors.blue, pass: Colors.grey),
    child: isCompact.pick(
      match: () => const Icon(Icons.phone_iphone),
      otherwise: () => buildLargeHeaderWidget(name),
    ),
  );
}
```

---

### 2. Screen-Aware Responsive Spacing

#### Without `lumu_evolve` (Boilerplate & Rebuild-Heavy)
```dart
@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  
  // Manual viewport logic per padding parameter
  final double paddingVal;
  if (width >= 840.0) {
    paddingVal = 32.0;
  } else if (width >= 600.0) {
    paddingVal = 24.0;
  } else {
    paddingVal = 16.0;
  }

  return Padding(
    padding: EdgeInsets.all(paddingVal),
    child: const Text('Responsive Card'),
  );
}
```

#### With `lumu_evolve` (Declarative & Context-Aware)
```dart
@override
Widget build(BuildContext context) {
  return Padding(
    // Evaluates Space.base dynamically (e.g. 16.0 port / 24.0 land / 32.0 wide)
    padding: EdgeInsets.all(Space.base.fit(context)),
    child: const Text('Responsive Card'),
  );
}
```

---

## 📦 Installation

Add `lumu_evolve` to your project:

```bash
flutter pub add lumu_evolve
```

Then, import the package:

```dart
import 'package:lumu_evolve/lumu_evolve.dart';
```

---

## 🛠 Features Reference

### 1. Scope & Helper Functions

#### `.let`
Executes a block of code with the receiver as its argument if the receiver is not null, returning the block's result.
* **Signature**: `R? let<R>(R Function(T self) block)`
* **Example**:
  ```dart
  final priceTag = rawPrice.let((price) => "\$${price.toStringAsFixed(2)}") ?? "$0.00";
  ```

#### `.also`
Executes a block of code with the receiver as its argument, returning the receiver itself. Ideal for side effects like logging or debugging.
* **Signature**: `T? also(void Function(T self) block)`
* **Example**:
  ```dart
  final user = User(id: '1', name: 'Bob').also((u) => print("Initialized: ${u.name}"));
  ```

#### `.or`
Returns the receiver if it is not null, otherwise returns the fallback value.
* **Signature**: `T or(T fallback)`
* **Example**:
  ```dart
  final avatar = user.avatarUrl.or("assets/default.png");
  ```

---

### 2. Fluent Booleans

#### `.when`
Maps a boolean state to one of two pre-evaluated values.
* **Signature**: `T when<T>({required T then, required T pass})`
* **Example**:
  ```dart
  final color = isSelected.when(then: Colors.blue, pass: Colors.grey);
  ```

#### `.pick`
Evaluates lazy closure functions depending on the boolean condition. Prevents double-evaluation of widget builders.
* **Signature**: `T pick<T>({required T Function() match, required T Function() otherwise})`
* **Example**:
  ```dart
  final widget = isLoggedIn.pick(
    match: () => const UserDashboard(),
    otherwise: () => const LoginScreen(),
  );
  ```

---

### 3. Responsive Tokens & Viewport Scales

The responsive engine uses viewport-neutral size classes:
*   `port` (Portrait viewports, like phones in portrait)
*   `land` (Landscape/Medium viewports, like tablets or split-screens)
*   `wide` (Wide viewports, like desktops, laptops, or large displays)

#### Custom Viewport Overrides (`Fit<T>`)
Create a custom value container that maps to active viewports:
```dart
final headerColumns = const Fit<int>(1, land: 2, wide: 4);

// Evaluate dynamically using the BuildContext
final currentColumns = headerColumns.fit(context);
```

#### Global Breakpoint Scales (`Breakpoints`)
Breakpoints and their multiplier factors are mutable and can be configured globally at startup in your `main()` method:
```dart
void main() {
  Breakpoints.land.value = 650.0;     // Change tablet threshold
  Breakpoints.wide.scale(1.8);        // Adjust desktop scale factor
  
  runApp(const MyApp());
}
```

#### Semantic Spacing Tokens (`Space`)
Contains predefined design tokens: `tiny` (4dp), `mini` (8dp), `small` (12dp), `base` (16dp), `medium` (20dp), `large` (24dp), and `huge` (32dp) which auto-scale dynamically. Overriding them is easy:
```dart
void main() {
  // Override Space.base globally using back-calculation
  Space.base = Fit.adaptive(20.0); 

  // Or set custom explicit bounds for Space.tiny globally
  Space.tiny = const Fit(6.0, land: 8.0, wide: 10.0);

  runApp(const MyApp());
}
```

---

## 📄 License

This project is licensed under the 3-Clause BSD License - see the [LICENSE](LICENSE) file for details.

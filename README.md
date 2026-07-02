# Lumu Evolve

An elegant and fluent utility kit for Dart and Flutter, designed to streamline control flows, simplify responsive layouts, and enhance null safety.

By introducing readable, chainable, and functional scope functions, it empowers developers to write cleaner, more expressive code without nested ternaries or boilerplate layout logic.

<br>

### Installation

Add the dependency to your project:

```bash
flutter pub add lumu_evolve
```


Import the package:

```dart
import 'package:lumu_evolve/lumu_evolve.dart';
```

<br>

### Configuration

You can customize breakpoints, scale factors, and design tokens globally at startup:

```dart
void main() {
  // Customize tablet breakpoint
  Breakpoints.land.value = 650.0;

  // Customize desktop scale factor
  Breakpoints.wide.scale(1.8);

  // Customize design tokens
  Space.base = const Fit(20.0); // Scales automatically

  runApp(const MyApp());
}
```

<br>

### Cleaner Control Flows

**Before**: Traditional Flutter code often relies on nested ternaries and verbose null checks for conditional styling and rendering:

```dart
Widget header(User? user, bool isCompact) {
  final name = user != null ? user.name : "Guest";
  
  return Container(
    color: isCompact ? Colors.blue : Colors.grey,
    child: isCompact 
      ? const Icon(Icons.phone_iphone) 
      : avatar(name),
  );
}
```

**After**: Using declarative extension methods, you can write linear, self documenting code that is easier to maintain:

```dart
Widget header(User? user, bool isCompact) {
  final name = user?.name.or("Guest");
  
  return Container(
    color: isCompact.when(then: Colors.blue, pass: Colors.grey),
    child: isCompact.pick(
      match: () => const Icon(Icons.phone_iphone),
      otherwise: () => avatar(name),
    ),
  );
}
```

<br>

### Responsive Spacing

**Before**: Calculating responsive spacing dynamically across different screen sizes usually requires querying `MediaQuery` and writing verbose viewport branching:

```dart
@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final double padding;

  if (width >= 840.0) {
    padding = 32.0;
  } else if (width >= 600.0) {
    padding = 24.0;
  } else {
    padding = 16.0;
  }

  return Padding(
    padding: .all(padding),
    child: const Content(),
  );
}
```

**After**: Using context aware design tokens, layout values scale automatically across viewports with zero boilerplate:

```dart
@override
Widget build(BuildContext context) {
  return Padding(
    padding: .all(Space.base(context)),
    child: const Content(),
  );
}
```

<br>

### Scoped Styling & Configuration

**Before**: Managing conditional styles and fallback values for nullable models often leads to boilerplate heavy nested branches:

```dart
Widget userProfileCard(User? user, BuildContext context) {
  final name = user != null ? user.name : 'Anonymous';
  final avatar = user != null && user.avatarUrl != null 
    ? user.avatarUrl! 
    : 'assets/default.png';
  
  Color color;
  if (user != null) {
    color = user.membership == Membership.vip 
      ? ColorScheme.of(context).primaryContainer 
      : ColorScheme.of(context).surfaceVariant;
  } else {
    color = ColorScheme.of(context).surface;
  }

  return Card(
    color: color,
    child: ListTile(
      leading: Image.asset(avatar),
      title: Text(name),
    ),
  );
}
```


**After**: Combining scope functions (`.let`, `.or`) with fluent booleans keeps the layout expression driven, declarative, and completely null safe:

```dart
Widget userProfileCard(User? user, BuildContext context) {
  final name = (user?.name).or('Anonymous');
  final avatar = (user?.avatarUrl).or('assets/default.png');
  final colors = ColorScheme.of(context);

  return Card(
    color: user?.let((u) => (u.membership == Membership.vip).when(
      then: colors.primaryContainer,
      pass: colors.surfaceVariant,
    )).or(colors.surface),
    child: ListTile(
      leading: Image.asset(avatar),
      title: Text(name),
    ),
  );
}
```


<br>

### Declarative Layouts

**Before**: Combining loading states with orientation checks often forces nested ternaries deep inside the layout tree:

```dart
Widget dashboard(bool isLoading, bool isLandscape, Widget data) {
  return Scaffold(
    body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : Row(
          children: [
            if (isLandscape) const NavigationDrawer(),
            Expanded(
              child: Align(
                alignment: isLandscape ? .topLeft : .center,
                child: Padding(
                  padding: .all(isLandscape ? 24.0 : 16.0),
                  child: data,
                ),
              ),
            ),
          ],
        ),
  );
}
```


**After**: Using fluent boolean mappings, layout conditions remain flat, linear, and easy to read:

```dart
Widget dashboard(bool isLoading, bool isLandscape, Widget data) {
  return Scaffold(
    body: isLoading.pick(
      match: () => const Center(child: CircularProgressIndicator()),
      otherwise: () => Row(
        children: [
          if (isLandscape) const NavigationDrawer(),
          Expanded(
            child: Align(
              alignment: isLandscape.when(then: .topLeft, pass: .center),
              child: Padding(
                padding: .all(isLandscape.when(then: 24.0, pass: 16.0)),
                child: data,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```


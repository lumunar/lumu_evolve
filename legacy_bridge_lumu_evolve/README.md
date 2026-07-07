# Deprecated: lumu_evolve

This package has been renamed to **[evolve](https://pub.dev/packages/evolve)**.

Please update your `pubspec.yaml` and import statements.

### Migration Guide

1. In your `pubspec.yaml`, replace `lumu_evolve` with `evolve`:
   ```yaml
   dependencies:
     evolve: ^1.2.1
   ```

2. In your Dart files, change the import:
   ```dart
   // Before
   import 'package:lumu_evolve/lumu_evolve.dart';

   // After
   import 'package:evolve/evolve.dart';
   ```

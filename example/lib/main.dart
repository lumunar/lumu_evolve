import 'package:flutter/material.dart';
import 'package:lumu_evolve/lumu_evolve.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
      ),
      home: const Root(),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = .of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < Breakpoints.tablet.value;
    final isDesktop = width >= Breakpoints.desktop.value;

    // Showcase 1: MagicObjectExtension.let
    // Dynamically resolves a descriptive text for the screen configuration.
    final deviceDescription = width.let((w) {
      if (w >= Breakpoints.desktop.value) return 'Expanded Workspace';
      if (w >= Breakpoints.tablet.value) return 'Medium Tablet View';
      return 'Compact Mobile Layout';
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text('Lumu Evolve')),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Polished Card with Gradient background & responsive layouts
                Card(
                  clipBehavior: .antiAlias,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primaryContainer, colors.surfaceContainerHighest.withValues(alpha: 0.4)],
                        begin: .topLeft,
                        end: .bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            // Showcase 2: MagicBooleanExtension.pick
                            // Lazy-evaluates and picks the correct icon based on screen size.
                            isCompact.pick(
                              match: () => const Icon(Icons.phone_iphone, size: 28),
                              otherwise: () => isDesktop.pick(
                                match: () => const Icon(Icons.desktop_windows, size: 28),
                                otherwise: () => const Icon(Icons.tablet_mac, size: 28),
                              ),
                            ),
                            // Showcase 3: MagicBooleanExtension.when
                            // Instantly maps the boolean state to layout attributes.
                            Container(
                              decoration: BoxDecoration(
                                color: isCompact.when(then: colors.secondaryContainer, pass: colors.primaryContainer),
                                borderRadius: .circular(12),
                              ),
                              child: Text(
                                isCompact.when(then: 'MOBILE', pass: 'RESPONSIVE'),
                              ).horizontal(Space.small).vertical(Space.tiny),
                            ),
                          ],
                        ),
                        SizedBox(height: Space.medium(context)),
                        // Showcase 4: MagicObjectExtension.or
                        // Resolves value with a safe fallback.
                        Text(
                          deviceDescription.or('Unrecognized Screen Size'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Experience premium, compile-time responsive padding tokens that automatically adapt to your window dimension.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
                        ),
                      ],
                    ).pad(Space.large, context: context),
                  ),
                ).pad(Space.base, context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

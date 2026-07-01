import 'package:flutter/material.dart';
import 'package:lumu_evolve/lumu_evolve.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Root());
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isPort = width < Breakpoints.land.value;
    final isWide = width >= Breakpoints.wide.value;

    // Showcase 1: MagicObjectExtension.let
    // Dynamically resolves a descriptive text for the screen configuration.
    final deviceDescription = width.let((w) {
      if (w >= Breakpoints.wide.value) return 'Expanded Wide View';
      if (w >= Breakpoints.land.value) return 'Medium Landscape View';
      return 'Compact Portrait Layout';
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(title: Text('Lumu Evolve')),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Polished Card with Gradient background & responsive layouts
                Padding(
                  padding: EdgeInsets.all(Space.base.fit(context)),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors.primaryContainer, colors.surfaceContainerHighest.withValues(alpha: 0.4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Space.large.fit(context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Showcase 2: MagicBooleanExtension.pick
                                // Lazy-evaluates and picks the correct icon based on screen size.
                                isPort.pick(
                                  match: () => const Icon(Icons.phone_iphone, size: 28),
                                  otherwise: () => isWide.pick(
                                    match: () => const Icon(Icons.desktop_windows, size: 28),
                                    otherwise: () => const Icon(Icons.tablet_mac, size: 28),
                                  ),
                                ),
                                // Showcase 3: MagicBooleanExtension.when
                                // Instantly maps the boolean state to layout attributes.
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Space.small.fit(context),
                                    vertical: Space.tiny.fit(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPort.when(then: colors.secondaryContainer, pass: colors.primaryContainer),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(isPort.when(then: 'PORTRAIT', pass: 'RESPONSIVE')),
                                ),
                              ],
                            ),
                            SizedBox(height: Space.medium(context)),
                            // Showcase 4: MagicObjectExtension.or
                            // Resolves value with a safe fallback.
                            Text(
                              deviceDescription.or('Unrecognized Screen Size'),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: Space.small.fit(context)),
                            const Text(
                              'Experience premium, compile-time responsive padding tokens that automatically adapt to your window dimension.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

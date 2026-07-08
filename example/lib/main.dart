import 'package:flutter/material.dart';
import 'package:evolve/evolve.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: .dark,
      darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(title: Text('Evolve')),
          SliverPadding(
            padding: .symmetric(horizontal: Space.base.fit(context)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Banner(),
                SizedBox(height: Space.large.fit(context)),
                const Profile(),
                SizedBox(height: Space.huge.fit(context)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = .of(context);
    final TextTheme texts = .of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final bool isPort = width < Breakpoints.land.value;
    final bool isWide = width >= Breakpoints.wide.value;

    // Showcase 1: Scope function .let to evaluate screen width descriptions
    final status = width.let((w) {
      if (w >= Breakpoints.wide.value) return 'Ultra Wide Workspace';
      if (w >= Breakpoints.land.value) return 'Adaptive Landscape View';
      return 'Compact Portrait Layout';
    });

    return Card(
      clipBehavior: .antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primaryContainer,
              colors.surfaceContainerHighest.withValues(alpha: 0.6),
            ],
            begin: .topLeft,
            end: .bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(Space.large.fit(context)),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  // Showcase 2: Lazy selection using .pick for screen-specific icons
                  isPort.pick(
                    match: () => Icon(
                      Icons.phone_iphone,
                      size: 32,
                      color: colors.primary,
                    ),
                    otherwise: () => isWide.pick(
                      match: () => Icon(
                        Icons.desktop_windows,
                        size: 32,
                        color: colors.primary,
                      ),
                      otherwise: () => Icon(
                        Icons.tablet_mac,
                        size: 32,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  // Showcase 3: Boolean status mapping with .when
                  Container(
                    padding: .symmetric(
                      horizontal: Space.small.fit(context),
                      vertical: Space.tiny.fit(context),
                    ),
                    decoration: BoxDecoration(
                      color: isPort.when(
                        then: colors.secondaryContainer,
                        pass: colors.tertiaryContainer,
                      ),
                      borderRadius: .circular(16),
                    ),
                    child: Text(
                      isPort.when(then: 'PORTRAIT', pass: 'RESPONSIVE'),
                      style: texts.labelMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Space.medium.fit(context)),
              // Showcase 4: Safe fallback with .or on string values
              Text(
                status.or('Default Workspace'),
                style: texts.headlineSmall?.copyWith(fontWeight: .bold),
              ),
              SizedBox(height: Space.tiny.fit(context)),
              Text(
                'Screen width: ${width.toStringAsFixed(1)} dp',
                style: .new(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isVip = false;
  String? _name;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = .of(context);
    final TextTheme texts = .of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Profile Management',
              style: texts.titleMedium?.copyWith(fontWeight: .bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () {
                setState(() {
                  _name = _name.equals(null).select('Sarah Jenkins', null);
                });
              },
            ),
          ],
        ),
        SizedBox(height: Space.small.fit(context)),
        Card(
          color: (!_name.equals(null)).select(
            _isVip.select(
              colors.primaryContainer,
              colors.surfaceContainerHighest,
            ),
            colors.surfaceContainerHigh,
          ),
          child: Padding(
            padding: .all(Space.medium.fit(context)),
            child: Column(
              children: [
                ListTile(
                  contentPadding: .zero,
                  leading: CircleAvatar(
                    backgroundColor: colors.primary,
                    child: Icon(
                      // Showcase 5: VIP icon conditional with .select (positional)
                      _isVip.select(Icons.star, Icons.person),
                      color: colors.onPrimary,
                    ),
                  ),
                  // Showcase 6: Safe nullable variable evaluation with .or
                  title: Text(_name.or('Guest User')),
                  subtitle: Text(
                    // Showcase 7: Positional select replacement for ternary operator
                    _isVip.select('Premium VIP Member', 'Standard Account'),
                    style: .new(
                      color: _isVip.select(
                        Colors.amber,
                        colors.onSurfaceVariant,
                      ),
                      fontWeight: _isVip.select(.bold, .normal),
                    ),
                  ),
                  trailing: Switch(
                    value: _isVip,
                    onChanged: (val) {
                      setState(() => _isVip = val);
                    },
                  ),
                ),
                Divider(height: Space.large.fit(context)),
                // Showcase 8: Custom layout configuration using .pick
                _isVip.pick(
                  match: () => Container(
                    padding: .all(Space.small.fit(context)),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: .circular(8),
                      border: .all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      spacing: 8.0,
                      children: [
                        Icon(Icons.workspace_premium, color: Colors.amber),
                        Expanded(
                          child: Text(
                            'Unlocked all premium responsive grids and adaptive layout overrides.',
                          ),
                        ),
                      ],
                    ),
                  ),
                  otherwise: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

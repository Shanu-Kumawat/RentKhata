/// Placeholder screens for features not yet implemented.
library;

import 'package:flutter/material.dart';

/// Generic placeholder screen.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.icon = Icons.construction,
    this.message = 'This feature is coming soon!',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Properties list screen placeholder.
class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Properties',
      icon: Icons.home_work_outlined,
      message: 'Property management coming soon!',
    );
  }
}

/// Tenants list screen placeholder.
class TenantsScreen extends StatelessWidget {
  const TenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Tenants',
      icon: Icons.people_outline,
      message: 'Tenant management coming soon!',
    );
  }
}

/// Settings screen placeholder.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Settings',
      icon: Icons.settings_outlined,
      message: 'Settings coming soon!',
    );
  }
}

/// Reports screen placeholder.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Reports',
      icon: Icons.assessment_outlined,
      message: 'Reports coming soon!',
    );
  }
}

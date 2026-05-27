/// Main shell with bottom navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Shell widget with persistent bottom navigation bar.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar:
          NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) {
                  HapticFeedback.selectionClick();
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.dashboard_outlined)
                        .animate(delay: 200.ms)
                        .scale(curve: Curves.elasticOut, duration: 600.ms),
                    selectedIcon: const Icon(Icons.dashboard).animate().scale(
                      curve: Curves.elasticOut,
                      duration: 500.ms,
                    ),
                    label: 'Dashboard',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.home_work_outlined)
                        .animate(delay: 300.ms)
                        .scale(curve: Curves.elasticOut, duration: 600.ms),
                    selectedIcon: const Icon(Icons.home_work).animate().scale(
                      curve: Curves.elasticOut,
                      duration: 500.ms,
                    ),
                    label: 'Properties',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.people_outline)
                        .animate(delay: 400.ms)
                        .scale(curve: Curves.elasticOut, duration: 600.ms),
                    selectedIcon: const Icon(Icons.people).animate().scale(
                      curve: Curves.elasticOut,
                      duration: 500.ms,
                    ),
                    label: 'Tenants',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.assessment_outlined)
                        .animate(delay: 500.ms)
                        .scale(curve: Curves.elasticOut, duration: 600.ms),
                    selectedIcon: const Icon(Icons.assessment).animate().scale(
                      curve: Curves.elasticOut,
                      duration: 500.ms,
                    ),
                    label: 'Reports',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined)
                        .animate(delay: 600.ms)
                        .scale(curve: Curves.elasticOut, duration: 600.ms),
                    selectedIcon: const Icon(Icons.settings).animate().scale(
                      curve: Curves.elasticOut,
                      duration: 500.ms,
                    ),
                    label: 'Settings',
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideY(
                begin: 1.0,
                end: 0.0,
                curve: Curves.easeOutBack,
                duration: 800.ms,
              ),
    );
  }
}

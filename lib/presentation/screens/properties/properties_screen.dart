/// Properties list screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/animated_property_graphic.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/property_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/property.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Screen displaying all properties.
class PropertiesScreen extends ConsumerWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesStreamProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.properties)),
      body: propertiesAsync.when(
        data: (properties) => properties.isEmpty
            ? _buildEmptyState(context)
            : _buildPropertyList(context, properties),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.error(error.toString())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(propertiesStreamProvider),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (propertiesAsync.valueOrNull?.isNotEmpty == true)
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/properties/add'),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addProperty),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedPropertyGraphic(),
            const SizedBox(height: 24),
            Text(
                  AppLocalizations.of(context)!.noPropertiesYet,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                )
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 8),
            Text(
                  AppLocalizations.of(context)!.addYourFirstProperty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 300.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/properties/add'),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addProperty),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList(BuildContext context, List<Property> properties) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _PropertyCard(property: property)
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 400.ms)
            .slideX(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOutCubic,
              duration: 400.ms,
            );
      },
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final Property property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final occupancyPercent = property.roomCount > 0
        ? (property.occupiedRoomCount / property.roomCount * 100).round()
        : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/properties/${property.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Property icon/image
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.apartment_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Property info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (property.address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        property.address!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.meeting_room_outlined,
                          label: AppLocalizations.of(
                            context,
                          )!.roomsCount(property.roomCount),
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.people_outline,
                          label: AppLocalizations.of(
                            context,
                          )!.occupiedPercent(occupancyPercent),
                          color: occupancyPercent >= 80
                              ? AppColors.success
                              : occupancyPercent >= 50
                              ? AppColors.warning
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _StatChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: chipColor),
        ),
      ],
    );
  }
}

/// Property detail screen with room list.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/animated_room_graphic.dart';
import 'package:go_router/go_router.dart';
import '../../../application/providers/property_providers.dart';
import '../../../application/providers/repository_providers.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/property.dart';
import '../../../domain/entities/room.dart';
import '../rooms/add_room_screen.dart';
import 'add_property_screen.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Property detail screen showing rooms.
class PropertyDetailScreen extends ConsumerWidget {
  final int propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyProvider(propertyId));
    final roomsAsync = ref.watch(roomsForPropertyStreamProvider(propertyId));

    return propertyAsync.when(
      data: (property) {
        if (property == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.properties),
            ),
            body: Center(
              child: Text(AppLocalizations.of(context)!.propertyNotFound),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(property.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditProperty(context, property),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDelete(context, ref, property);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.deleteProperty),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Property header
              _PropertyHeader(property: property),
              const Divider(height: 1),
              // Rooms section
              Expanded(
                child: roomsAsync.when(
                  data: (rooms) => rooms.isEmpty
                      ? _buildEmptyRooms(context, property)
                      : _buildRoomsList(context, rooms),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('${AppLocalizations.of(context)!.errorPrefix}$e')),
                ),
              ),
            ],
          ),
          floatingActionButton: (roomsAsync.valueOrNull?.isNotEmpty == true)
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddRoom(context, property),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.addRoom),
                )
              : null,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.error(e.toString())),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context)!.error(e.toString())),
        ),
      ),
    );
  }

  Widget _buildEmptyRooms(BuildContext context, Property property) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedRoomGraphic(),
              const SizedBox(height: 24),
              Text(
                    AppLocalizations.of(context)!.noRoomsYet,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 8),
              Text(
                    AppLocalizations.of(context)!.addRoomsToStartManaging,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 24),
              FilledButton.icon(
                    onPressed: () => _showAddRoom(context, property),
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.addRoom),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsList(BuildContext context, List<Room> rooms) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _RoomCard(room: room);
      },
    );
  }

  void _showEditProperty(BuildContext context, Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyScreen(property: property),
      ),
    );
  }

  void _showAddRoom(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddRoomSheet(propertyId: property.id),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Property property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        title: Text(AppLocalizations.of(context)!.deletePropertyTitle),
        content: Text(
          AppLocalizations.of(context)!.confirmDeleteProperty(property.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(propertyRepositoryProvider)
                  .deleteProperty(property.id);
              if (context.mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.propertyDeleted,
                    ),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}

class _PropertyHeader extends StatelessWidget {
  final Property property;

  const _PropertyHeader({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.apartment_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (property.address != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.meeting_room_outlined,
                      label: AppLocalizations.of(
                        context,
                      )!.roomsCount(property.roomCount),
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.people_outline,
                      label: AppLocalizations.of(
                        context,
                      )!.occupancyCount(property.occupiedRoomCount),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/rooms/${room.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Room status indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: room.isOccupied
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  room.isOccupied
                      ? Icons.person_rounded
                      : Icons.meeting_room_outlined,
                  color: room.isOccupied
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              // Room info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.roomNumber(room.roomNumber),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (room.isOccupied && room.currentTenantName != null)
                      Text(
                        room.currentTenantName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    else
                      Text(
                        AppLocalizations.of(context)!.vacant,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              // Rent amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(room.baseRent),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.perMonth,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

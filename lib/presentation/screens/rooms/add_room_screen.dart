/// Add/Edit room bottom sheet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/room.dart';
import 'package:rent_khata/l10n/app_localizations.dart';

/// Bottom sheet to add or edit a room.
class AddRoomSheet extends ConsumerStatefulWidget {
  final int propertyId;
  final Room? existingRoom; // null for add, non-null for edit

  const AddRoomSheet({super.key, required this.propertyId, this.existingRoom});

  @override
  ConsumerState<AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends ConsumerState<AddRoomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _rentController = TextEditingController();
  bool _hasElectricityMeter = true; // Default to true
  bool _isLoading = false;

  bool get isEditing => widget.existingRoom != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingRoom != null) {
      final room = widget.existingRoom!;
      _roomNumberController.text = room.roomNumber;
      _rentController.text = room.baseRent.toString();
      _hasElectricityMeter = room.hasElectricityMeter;
    }
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(propertyRepositoryProvider);

      if (isEditing) {
        await repo.updateRoom(
          widget.existingRoom!.copyWith(
            roomNumber: _roomNumberController.text.trim(),
            baseRent: double.tryParse(_rentController.text) ?? 0,
            hasElectricityMeter: _hasElectricityMeter,
            // Keep existing rate, don't modify it here
          ),
        );
      } else {
        await repo.createRoom(
          propertyId: widget.propertyId,
          roomNumber: _roomNumberController.text.trim(),
          baseRent: double.tryParse(_rentController.text) ?? 0,
          hasElectricityMeter: _hasElectricityMeter,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? AppLocalizations.of(context)!.roomUpdatedSuccess : AppLocalizations.of(context)!.roomAddedSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? AppLocalizations.of(context)!.editRoomTitle : AppLocalizations.of(context)!.addRoomTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Room number
              TextFormField(
                controller: _roomNumberController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.roomNumberLabel,
                  hintText: AppLocalizations.of(context)!.roomNumberHint,
                  prefixIcon: const Icon(Icons.meeting_room_outlined),
                ),
                validator: (v) => validateRequired(v, 'Room number'),
              ),
              const SizedBox(height: 16),

              // Base rent
              TextFormField(
                controller: _rentController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.monthlyRentLabel,
                  hintText: AppLocalizations.of(context)!.monthlyRentHint,
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => validatePositiveNumber(v, 'Rent'),
              ),
              const SizedBox(height: 16),

              InputDecorator(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  secondary: const Icon(Icons.electric_meter_outlined),
                  title: Text(
                    AppLocalizations.of(context)!.electricityMeterToggleTitle,
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.electricityMeterToggleSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                  value: _hasElectricityMeter,
                  onChanged: (v) => setState(() => _hasElectricityMeter = v),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveRoom,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? AppLocalizations.of(context)!.saveChangesBtn : AppLocalizations.of(context)!.addRoomTitle),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

/// Add/Edit room bottom sheet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/providers/repository_providers.dart';
import '../../../application/providers/billing_providers.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/room.dart';

/// Bottom sheet to add or edit a room.
class AddRoomSheet extends ConsumerStatefulWidget {
  final int propertyId;
  final Room? existingRoom; // null for add, non-null for edit

  const AddRoomSheet({
    super.key,
    required this.propertyId,
    this.existingRoom,
  });

  @override
  ConsumerState<AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends ConsumerState<AddRoomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _rentController = TextEditingController();
  final _electricityRateController = TextEditingController();
  bool _hasElectricityMeter = false;
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
      _electricityRateController.text = room.currentElectricityRate.toString();
    } else {
      _loadDefaultRate();
    }
  }

  Future<void> _loadDefaultRate() async {
    final rate = await ref.read(currentElectricityRateProvider.future);
    _electricityRateController.text = rate.toString();
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _rentController.dispose();
    _electricityRateController.dispose();
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
            currentElectricityRate:
                double.tryParse(_electricityRateController.text) ?? 7.0,
          ),
        );
      } else {
        await repo.createRoom(
          propertyId: widget.propertyId,
          roomNumber: _roomNumberController.text.trim(),
          baseRent: double.tryParse(_rentController.text) ?? 0,
          hasElectricityMeter: _hasElectricityMeter,
          currentElectricityRate:
              double.tryParse(_electricityRateController.text) ?? 7.0,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? 'Room updated' : 'Room added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
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
                    isEditing ? 'Edit Room' : 'Add Room',
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
                decoration: const InputDecoration(
                  labelText: 'Room Number/Name *',
                  hintText: 'e.g., 101, Ground Floor Left',
                  prefixIcon: Icon(Icons.meeting_room_outlined),
                ),
                validator: (v) => validateRequired(v, 'Room number'),
              ),
              const SizedBox(height: 16),

              // Base rent
              TextFormField(
                controller: _rentController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rent (₹) *',
                  hintText: 'e.g., 5000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => validatePositiveNumber(v, 'Rent'),
              ),
              const SizedBox(height: 16),

              // Electricity meter toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Has Electricity Meter'),
                subtitle: const Text('Track electricity readings separately'),
                value: _hasElectricityMeter,
                onChanged: (v) => setState(() => _hasElectricityMeter = v),
              ),

              // Electricity rate (shown if meter enabled)
              if (_hasElectricityMeter) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _electricityRateController,
                  decoration: const InputDecoration(
                    labelText: 'Electricity Rate (₹/unit)',
                    hintText: 'e.g., 7',
                    prefixIcon: Icon(Icons.bolt_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
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
                      : Text(isEditing ? 'Save Changes' : 'Add Room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Landlord repository interface.
library;

import '../entities/landlord.dart';

/// Abstract repository for landlord profile operations.
abstract class LandlordRepository {
  /// Get the landlord profile
  Future<Landlord?> getLandlord();
  
  /// Watch the landlord profile
  Stream<Landlord?> watchLandlord();
  
  /// Check if a landlord profile exists
  Future<bool> hasLandlordProfile();
  
  /// Create or update the landlord profile
  Future<int> upsertLandlord({
    required String name,
    String? upiId,
    String? phone,
    String? photoPath,
  });
  
  /// Update the landlord profile
  Future<bool> updateLandlord(Landlord landlord);
}

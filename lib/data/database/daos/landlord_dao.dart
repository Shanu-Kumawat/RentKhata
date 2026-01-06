/// Landlord Data Access Object.
library;

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/landlord_table.dart';

part 'landlord_dao.g.dart';

/// DAO for landlord profile operations.
@DriftAccessor(tables: [Landlords])
class LandlordDao extends DatabaseAccessor<AppDatabase>
    with _$LandlordDaoMixin {
  LandlordDao(super.db);

  /// Get the landlord profile (there should only be one)
  Future<LandlordEntity?> getLandlord() =>
      (select(landlords)..limit(1)).getSingleOrNull();

  /// Watch the landlord profile
  Stream<LandlordEntity?> watchLandlord() =>
      (select(landlords)..limit(1)).watchSingleOrNull();

  /// Insert or update the landlord profile
  Future<int> upsertLandlord(LandlordsCompanion landlord) =>
      into(landlords).insertOnConflictUpdate(landlord);

  /// Update the landlord profile
  Future<bool> updateLandlord(LandlordEntity landlord) =>
      update(landlords).replace(landlord);

  /// Check if landlord profile exists
  Future<bool> hasLandlordProfile() async {
    final landlord = await getLandlord();
    return landlord != null;
  }
}

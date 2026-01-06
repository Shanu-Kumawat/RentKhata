/// Landlord repository implementation.
library;

import '../../domain/entities/landlord.dart';
import '../../domain/repositories/landlord_repository.dart';
import '../database/app_database.dart';
import '../database/daos/landlord_dao.dart';
import 'package:drift/drift.dart';

/// Implementation of [LandlordRepository] using Drift database.
class LandlordRepositoryImpl implements LandlordRepository {
  final LandlordDao _landlordDao;

  LandlordRepositoryImpl(this._landlordDao);

  /// Convert database entity to domain model
  Landlord _toDomain(LandlordEntity entity) {
    return Landlord(
      id: entity.id,
      name: entity.name,
      upiId: entity.upiId,
      phone: entity.phone,
      photoPath: entity.photoPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Future<Landlord?> getLandlord() async {
    final entity = await _landlordDao.getLandlord();
    return entity != null ? _toDomain(entity) : null;
  }

  @override
  Stream<Landlord?> watchLandlord() {
    return _landlordDao.watchLandlord().map(
          (entity) => entity != null ? _toDomain(entity) : null,
        );
  }

  @override
  Future<bool> hasLandlordProfile() async {
    return _landlordDao.hasLandlordProfile();
  }

  @override
  Future<int> upsertLandlord({
    required String name,
    String? upiId,
    String? phone,
    String? photoPath,
  }) async {
    final landlord = LandlordsCompanion(
      name: Value(name),
      upiId: Value(upiId),
      phone: Value(phone),
      photoPath: Value(photoPath),
      updatedAt: Value(DateTime.now()),
    );
    return _landlordDao.upsertLandlord(landlord);
  }

  @override
  Future<bool> updateLandlord(Landlord landlord) async {
    final entity = LandlordEntity(
      id: landlord.id,
      name: landlord.name,
      upiId: landlord.upiId,
      phone: landlord.phone,
      photoPath: landlord.photoPath,
      createdAt: landlord.createdAt,
      updatedAt: DateTime.now(),
    );
    return _landlordDao.updateLandlord(entity);
  }
}

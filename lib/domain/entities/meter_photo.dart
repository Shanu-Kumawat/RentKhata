/// Meter photo domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meter_photo.freezed.dart';
part 'meter_photo.g.dart';

/// Represents a meter reading photo attached to a bill.
@freezed
class MeterPhoto with _$MeterPhoto {
  const factory MeterPhoto({
    required int id,
    required int billId,
    required String photoPath,
    @Default(1) int photoOrder,
    required DateTime createdAt,
  }) = _MeterPhoto;

  factory MeterPhoto.fromJson(Map<String, dynamic> json) =>
      _$MeterPhotoFromJson(json);
}

/// Bill settings domain entity.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_settings.freezed.dart';
part 'bill_settings.g.dart';

/// Represents global bill settings.
@freezed
class BillSettingsData with _$BillSettingsData {
  const factory BillSettingsData({
    required int id,
    @Default('INV') String billNumberPrefix,
    @Default(10) int dueDateOffsetDays,
    @Default(true) bool autoReminders,
    required DateTime updatedAt,
  }) = _BillSettingsData;

  factory BillSettingsData.fromJson(Map<String, dynamic> json) =>
      _$BillSettingsDataFromJson(json);
}

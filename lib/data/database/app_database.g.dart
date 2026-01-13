// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LandlordsTable extends Landlords
    with TableInfo<$LandlordsTable, LandlordEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LandlordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
    'upi_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    upiId,
    phone,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'landlords';
  @override
  VerificationContext validateIntegrity(
    Insertable<LandlordEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('upi_id')) {
      context.handle(
        _upiIdMeta,
        upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LandlordEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LandlordEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      upiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_id'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LandlordsTable createAlias(String alias) {
    return $LandlordsTable(attachedDatabase, alias);
  }
}

class LandlordEntity extends DataClass implements Insertable<LandlordEntity> {
  /// Primary key
  final int id;

  /// Landlord's name
  final String name;

  /// UPI ID for receiving payments
  final String? upiId;

  /// Phone number
  final String? phone;

  /// Profile photo path
  final String? photoPath;

  /// Created timestamp
  final DateTime createdAt;

  /// Updated timestamp
  final DateTime updatedAt;
  const LandlordEntity({
    required this.id,
    required this.name,
    this.upiId,
    this.phone,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LandlordsCompanion toCompanion(bool nullToAbsent) {
    return LandlordsCompanion(
      id: Value(id),
      name: Value(name),
      upiId: upiId == null && nullToAbsent
          ? const Value.absent()
          : Value(upiId),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LandlordEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LandlordEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      phone: serializer.fromJson<String?>(json['phone']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'upiId': serializer.toJson<String?>(upiId),
      'phone': serializer.toJson<String?>(phone),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LandlordEntity copyWith({
    int? id,
    String? name,
    Value<String?> upiId = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LandlordEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    upiId: upiId.present ? upiId.value : this.upiId,
    phone: phone.present ? phone.value : this.phone,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LandlordEntity copyWithCompanion(LandlordsCompanion data) {
    return LandlordEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      phone: data.phone.present ? data.phone.value : this.phone,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LandlordEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('upiId: $upiId, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, upiId, phone, photoPath, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LandlordEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.upiId == this.upiId &&
          other.phone == this.phone &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LandlordsCompanion extends UpdateCompanion<LandlordEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> upiId;
  final Value<String?> phone;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const LandlordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.upiId = const Value.absent(),
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LandlordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.upiId = const Value.absent(),
    this.phone = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<LandlordEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? upiId,
    Expression<String>? phone,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (upiId != null) 'upi_id': upiId,
      if (phone != null) 'phone': phone,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LandlordsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? upiId,
    Value<String?>? phone,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return LandlordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      upiId: upiId ?? this.upiId,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LandlordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('upiId: $upiId, ')
          ..write('phone: $phone, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PropertiesTable extends Properties
    with TableInfo<$PropertiesTable, PropertyEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    photoPath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'properties';
  @override
  VerificationContext validateIntegrity(
    Insertable<PropertyEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PropertyEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PropertyEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PropertiesTable createAlias(String alias) {
    return $PropertiesTable(attachedDatabase, alias);
  }
}

class PropertyEntity extends DataClass implements Insertable<PropertyEntity> {
  /// Primary key
  final int id;

  /// Property name (e.g., "Sunrise Apartments")
  final String name;

  /// Full address
  final String? address;

  /// Photo path for property image
  final String? photoPath;

  /// Created timestamp
  final DateTime createdAt;
  const PropertyEntity({
    required this.id,
    required this.name,
    this.address,
    this.photoPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PropertiesCompanion toCompanion(bool nullToAbsent) {
    return PropertiesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
    );
  }

  factory PropertyEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PropertyEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PropertyEntity copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
  }) => PropertyEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
  );
  PropertyEntity copyWithCompanion(PropertiesCompanion data) {
    return PropertyEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PropertyEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, photoPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PropertyEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt);
}

class PropertiesCompanion extends UpdateCompanion<PropertyEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  const PropertiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PropertiesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PropertyEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PropertiesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
  }) {
    return PropertiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PropertiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, RoomEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _propertyIdMeta = const VerificationMeta(
    'propertyId',
  );
  @override
  late final GeneratedColumn<int> propertyId = GeneratedColumn<int>(
    'property_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES properties (id)',
    ),
  );
  static const VerificationMeta _roomNumberMeta = const VerificationMeta(
    'roomNumber',
  );
  @override
  late final GeneratedColumn<String> roomNumber = GeneratedColumn<String>(
    'room_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseRentMeta = const VerificationMeta(
    'baseRent',
  );
  @override
  late final GeneratedColumn<double> baseRent = GeneratedColumn<double>(
    'base_rent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _hasElectricityMeterMeta =
      const VerificationMeta('hasElectricityMeter');
  @override
  late final GeneratedColumn<bool> hasElectricityMeter = GeneratedColumn<bool>(
    'has_electricity_meter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_electricity_meter" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentElectricityRateMeta =
      const VerificationMeta('currentElectricityRate');
  @override
  late final GeneratedColumn<double> currentElectricityRate =
      GeneratedColumn<double>(
        'current_electricity_rate',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(7.0),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    propertyId,
    roomNumber,
    baseRent,
    hasElectricityMeter,
    currentElectricityRate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('property_id')) {
      context.handle(
        _propertyIdMeta,
        propertyId.isAcceptableOrUnknown(data['property_id']!, _propertyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_propertyIdMeta);
    }
    if (data.containsKey('room_number')) {
      context.handle(
        _roomNumberMeta,
        roomNumber.isAcceptableOrUnknown(data['room_number']!, _roomNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_roomNumberMeta);
    }
    if (data.containsKey('base_rent')) {
      context.handle(
        _baseRentMeta,
        baseRent.isAcceptableOrUnknown(data['base_rent']!, _baseRentMeta),
      );
    }
    if (data.containsKey('has_electricity_meter')) {
      context.handle(
        _hasElectricityMeterMeta,
        hasElectricityMeter.isAcceptableOrUnknown(
          data['has_electricity_meter']!,
          _hasElectricityMeterMeta,
        ),
      );
    }
    if (data.containsKey('current_electricity_rate')) {
      context.handle(
        _currentElectricityRateMeta,
        currentElectricityRate.isAcceptableOrUnknown(
          data['current_electricity_rate']!,
          _currentElectricityRateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      propertyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}property_id'],
      )!,
      roomNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_number'],
      )!,
      baseRent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_rent'],
      )!,
      hasElectricityMeter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_electricity_meter'],
      )!,
      currentElectricityRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_electricity_rate'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class RoomEntity extends DataClass implements Insertable<RoomEntity> {
  /// Primary key
  final int id;

  /// Foreign key to property
  final int propertyId;

  /// Room number/name (e.g., "101", "Ground Floor Left")
  final String roomNumber;

  /// Base rent amount
  final double baseRent;

  /// Whether the room has an electricity meter
  final bool hasElectricityMeter;

  /// Current electricity rate for this room
  final double currentElectricityRate;

  /// Created timestamp
  final DateTime createdAt;
  const RoomEntity({
    required this.id,
    required this.propertyId,
    required this.roomNumber,
    required this.baseRent,
    required this.hasElectricityMeter,
    required this.currentElectricityRate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['property_id'] = Variable<int>(propertyId);
    map['room_number'] = Variable<String>(roomNumber);
    map['base_rent'] = Variable<double>(baseRent);
    map['has_electricity_meter'] = Variable<bool>(hasElectricityMeter);
    map['current_electricity_rate'] = Variable<double>(currentElectricityRate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      propertyId: Value(propertyId),
      roomNumber: Value(roomNumber),
      baseRent: Value(baseRent),
      hasElectricityMeter: Value(hasElectricityMeter),
      currentElectricityRate: Value(currentElectricityRate),
      createdAt: Value(createdAt),
    );
  }

  factory RoomEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomEntity(
      id: serializer.fromJson<int>(json['id']),
      propertyId: serializer.fromJson<int>(json['propertyId']),
      roomNumber: serializer.fromJson<String>(json['roomNumber']),
      baseRent: serializer.fromJson<double>(json['baseRent']),
      hasElectricityMeter: serializer.fromJson<bool>(
        json['hasElectricityMeter'],
      ),
      currentElectricityRate: serializer.fromJson<double>(
        json['currentElectricityRate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'propertyId': serializer.toJson<int>(propertyId),
      'roomNumber': serializer.toJson<String>(roomNumber),
      'baseRent': serializer.toJson<double>(baseRent),
      'hasElectricityMeter': serializer.toJson<bool>(hasElectricityMeter),
      'currentElectricityRate': serializer.toJson<double>(
        currentElectricityRate,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RoomEntity copyWith({
    int? id,
    int? propertyId,
    String? roomNumber,
    double? baseRent,
    bool? hasElectricityMeter,
    double? currentElectricityRate,
    DateTime? createdAt,
  }) => RoomEntity(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    roomNumber: roomNumber ?? this.roomNumber,
    baseRent: baseRent ?? this.baseRent,
    hasElectricityMeter: hasElectricityMeter ?? this.hasElectricityMeter,
    currentElectricityRate:
        currentElectricityRate ?? this.currentElectricityRate,
    createdAt: createdAt ?? this.createdAt,
  );
  RoomEntity copyWithCompanion(RoomsCompanion data) {
    return RoomEntity(
      id: data.id.present ? data.id.value : this.id,
      propertyId: data.propertyId.present
          ? data.propertyId.value
          : this.propertyId,
      roomNumber: data.roomNumber.present
          ? data.roomNumber.value
          : this.roomNumber,
      baseRent: data.baseRent.present ? data.baseRent.value : this.baseRent,
      hasElectricityMeter: data.hasElectricityMeter.present
          ? data.hasElectricityMeter.value
          : this.hasElectricityMeter,
      currentElectricityRate: data.currentElectricityRate.present
          ? data.currentElectricityRate.value
          : this.currentElectricityRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomEntity(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('roomNumber: $roomNumber, ')
          ..write('baseRent: $baseRent, ')
          ..write('hasElectricityMeter: $hasElectricityMeter, ')
          ..write('currentElectricityRate: $currentElectricityRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    propertyId,
    roomNumber,
    baseRent,
    hasElectricityMeter,
    currentElectricityRate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomEntity &&
          other.id == this.id &&
          other.propertyId == this.propertyId &&
          other.roomNumber == this.roomNumber &&
          other.baseRent == this.baseRent &&
          other.hasElectricityMeter == this.hasElectricityMeter &&
          other.currentElectricityRate == this.currentElectricityRate &&
          other.createdAt == this.createdAt);
}

class RoomsCompanion extends UpdateCompanion<RoomEntity> {
  final Value<int> id;
  final Value<int> propertyId;
  final Value<String> roomNumber;
  final Value<double> baseRent;
  final Value<bool> hasElectricityMeter;
  final Value<double> currentElectricityRate;
  final Value<DateTime> createdAt;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.propertyId = const Value.absent(),
    this.roomNumber = const Value.absent(),
    this.baseRent = const Value.absent(),
    this.hasElectricityMeter = const Value.absent(),
    this.currentElectricityRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoomsCompanion.insert({
    this.id = const Value.absent(),
    required int propertyId,
    required String roomNumber,
    this.baseRent = const Value.absent(),
    this.hasElectricityMeter = const Value.absent(),
    this.currentElectricityRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : propertyId = Value(propertyId),
       roomNumber = Value(roomNumber);
  static Insertable<RoomEntity> custom({
    Expression<int>? id,
    Expression<int>? propertyId,
    Expression<String>? roomNumber,
    Expression<double>? baseRent,
    Expression<bool>? hasElectricityMeter,
    Expression<double>? currentElectricityRate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (propertyId != null) 'property_id': propertyId,
      if (roomNumber != null) 'room_number': roomNumber,
      if (baseRent != null) 'base_rent': baseRent,
      if (hasElectricityMeter != null)
        'has_electricity_meter': hasElectricityMeter,
      if (currentElectricityRate != null)
        'current_electricity_rate': currentElectricityRate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoomsCompanion copyWith({
    Value<int>? id,
    Value<int>? propertyId,
    Value<String>? roomNumber,
    Value<double>? baseRent,
    Value<bool>? hasElectricityMeter,
    Value<double>? currentElectricityRate,
    Value<DateTime>? createdAt,
  }) {
    return RoomsCompanion(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      roomNumber: roomNumber ?? this.roomNumber,
      baseRent: baseRent ?? this.baseRent,
      hasElectricityMeter: hasElectricityMeter ?? this.hasElectricityMeter,
      currentElectricityRate:
          currentElectricityRate ?? this.currentElectricityRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (propertyId.present) {
      map['property_id'] = Variable<int>(propertyId.value);
    }
    if (roomNumber.present) {
      map['room_number'] = Variable<String>(roomNumber.value);
    }
    if (baseRent.present) {
      map['base_rent'] = Variable<double>(baseRent.value);
    }
    if (hasElectricityMeter.present) {
      map['has_electricity_meter'] = Variable<bool>(hasElectricityMeter.value);
    }
    if (currentElectricityRate.present) {
      map['current_electricity_rate'] = Variable<double>(
        currentElectricityRate.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('propertyId: $propertyId, ')
          ..write('roomNumber: $roomNumber, ')
          ..write('baseRent: $baseRent, ')
          ..write('hasElectricityMeter: $hasElectricityMeter, ')
          ..write('currentElectricityRate: $currentElectricityRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TenantsTable extends Tenants
    with TableInfo<$TenantsTable, TenantEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aadharNumberMeta = const VerificationMeta(
    'aadharNumber',
  );
  @override
  late final GeneratedColumn<String> aadharNumber = GeneratedColumn<String>(
    'aadhar_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPoliceVerifiedMeta = const VerificationMeta(
    'isPoliceVerified',
  );
  @override
  late final GeneratedColumn<bool> isPoliceVerified = GeneratedColumn<bool>(
    'is_police_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_police_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _policeVerificationDocPathMeta =
      const VerificationMeta('policeVerificationDocPath');
  @override
  late final GeneratedColumn<String> policeVerificationDocPath =
      GeneratedColumn<String>(
        'police_verification_doc_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    aadharNumber,
    photoPath,
    isPoliceVerified,
    policeVerificationDocPath,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenants';
  @override
  VerificationContext validateIntegrity(
    Insertable<TenantEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('aadhar_number')) {
      context.handle(
        _aadharNumberMeta,
        aadharNumber.isAcceptableOrUnknown(
          data['aadhar_number']!,
          _aadharNumberMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('is_police_verified')) {
      context.handle(
        _isPoliceVerifiedMeta,
        isPoliceVerified.isAcceptableOrUnknown(
          data['is_police_verified']!,
          _isPoliceVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('police_verification_doc_path')) {
      context.handle(
        _policeVerificationDocPathMeta,
        policeVerificationDocPath.isAcceptableOrUnknown(
          data['police_verification_doc_path']!,
          _policeVerificationDocPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TenantEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      aadharNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aadhar_number'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      isPoliceVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_police_verified'],
      )!,
      policeVerificationDocPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}police_verification_doc_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TenantsTable createAlias(String alias) {
    return $TenantsTable(attachedDatabase, alias);
  }
}

class TenantEntity extends DataClass implements Insertable<TenantEntity> {
  /// Primary key
  final int id;

  /// Tenant's full name
  final String name;

  /// Phone number
  final String? phone;

  /// Aadhar number (12 digits)
  final String? aadharNumber;

  /// Profile photo path
  final String? photoPath;

  /// Whether police verification is complete
  final bool isPoliceVerified;

  /// Path to police verification document
  final String? policeVerificationDocPath;

  /// Created timestamp
  final DateTime createdAt;
  const TenantEntity({
    required this.id,
    required this.name,
    this.phone,
    this.aadharNumber,
    this.photoPath,
    required this.isPoliceVerified,
    this.policeVerificationDocPath,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || aadharNumber != null) {
      map['aadhar_number'] = Variable<String>(aadharNumber);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['is_police_verified'] = Variable<bool>(isPoliceVerified);
    if (!nullToAbsent || policeVerificationDocPath != null) {
      map['police_verification_doc_path'] = Variable<String>(
        policeVerificationDocPath,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TenantsCompanion toCompanion(bool nullToAbsent) {
    return TenantsCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      aadharNumber: aadharNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aadharNumber),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      isPoliceVerified: Value(isPoliceVerified),
      policeVerificationDocPath:
          policeVerificationDocPath == null && nullToAbsent
          ? const Value.absent()
          : Value(policeVerificationDocPath),
      createdAt: Value(createdAt),
    );
  }

  factory TenantEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      aadharNumber: serializer.fromJson<String?>(json['aadharNumber']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      isPoliceVerified: serializer.fromJson<bool>(json['isPoliceVerified']),
      policeVerificationDocPath: serializer.fromJson<String?>(
        json['policeVerificationDocPath'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'aadharNumber': serializer.toJson<String?>(aadharNumber),
      'photoPath': serializer.toJson<String?>(photoPath),
      'isPoliceVerified': serializer.toJson<bool>(isPoliceVerified),
      'policeVerificationDocPath': serializer.toJson<String?>(
        policeVerificationDocPath,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TenantEntity copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> aadharNumber = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    bool? isPoliceVerified,
    Value<String?> policeVerificationDocPath = const Value.absent(),
    DateTime? createdAt,
  }) => TenantEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    aadharNumber: aadharNumber.present ? aadharNumber.value : this.aadharNumber,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    isPoliceVerified: isPoliceVerified ?? this.isPoliceVerified,
    policeVerificationDocPath: policeVerificationDocPath.present
        ? policeVerificationDocPath.value
        : this.policeVerificationDocPath,
    createdAt: createdAt ?? this.createdAt,
  );
  TenantEntity copyWithCompanion(TenantsCompanion data) {
    return TenantEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      aadharNumber: data.aadharNumber.present
          ? data.aadharNumber.value
          : this.aadharNumber,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      isPoliceVerified: data.isPoliceVerified.present
          ? data.isPoliceVerified.value
          : this.isPoliceVerified,
      policeVerificationDocPath: data.policeVerificationDocPath.present
          ? data.policeVerificationDocPath.value
          : this.policeVerificationDocPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('aadharNumber: $aadharNumber, ')
          ..write('photoPath: $photoPath, ')
          ..write('isPoliceVerified: $isPoliceVerified, ')
          ..write('policeVerificationDocPath: $policeVerificationDocPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    aadharNumber,
    photoPath,
    isPoliceVerified,
    policeVerificationDocPath,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.aadharNumber == this.aadharNumber &&
          other.photoPath == this.photoPath &&
          other.isPoliceVerified == this.isPoliceVerified &&
          other.policeVerificationDocPath == this.policeVerificationDocPath &&
          other.createdAt == this.createdAt);
}

class TenantsCompanion extends UpdateCompanion<TenantEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> aadharNumber;
  final Value<String?> photoPath;
  final Value<bool> isPoliceVerified;
  final Value<String?> policeVerificationDocPath;
  final Value<DateTime> createdAt;
  const TenantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.aadharNumber = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isPoliceVerified = const Value.absent(),
    this.policeVerificationDocPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TenantsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.aadharNumber = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.isPoliceVerified = const Value.absent(),
    this.policeVerificationDocPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TenantEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? aadharNumber,
    Expression<String>? photoPath,
    Expression<bool>? isPoliceVerified,
    Expression<String>? policeVerificationDocPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (aadharNumber != null) 'aadhar_number': aadharNumber,
      if (photoPath != null) 'photo_path': photoPath,
      if (isPoliceVerified != null) 'is_police_verified': isPoliceVerified,
      if (policeVerificationDocPath != null)
        'police_verification_doc_path': policeVerificationDocPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TenantsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? aadharNumber,
    Value<String?>? photoPath,
    Value<bool>? isPoliceVerified,
    Value<String?>? policeVerificationDocPath,
    Value<DateTime>? createdAt,
  }) {
    return TenantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      photoPath: photoPath ?? this.photoPath,
      isPoliceVerified: isPoliceVerified ?? this.isPoliceVerified,
      policeVerificationDocPath:
          policeVerificationDocPath ?? this.policeVerificationDocPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (aadharNumber.present) {
      map['aadhar_number'] = Variable<String>(aadharNumber.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (isPoliceVerified.present) {
      map['is_police_verified'] = Variable<bool>(isPoliceVerified.value);
    }
    if (policeVerificationDocPath.present) {
      map['police_verification_doc_path'] = Variable<String>(
        policeVerificationDocPath.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('aadharNumber: $aadharNumber, ')
          ..write('photoPath: $photoPath, ')
          ..write('isPoliceVerified: $isPoliceVerified, ')
          ..write('policeVerificationDocPath: $policeVerificationDocPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldsTable extends CustomFields
    with TableInfo<$CustomFieldsTable, CustomFieldEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id)',
    ),
  );
  static const VerificationMeta _fieldNameMeta = const VerificationMeta(
    'fieldName',
  );
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
    'field_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldValueMeta = const VerificationMeta(
    'fieldValue',
  );
  @override
  late final GeneratedColumn<String> fieldValue = GeneratedColumn<String>(
    'field_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tenantId, fieldName, fieldValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFieldEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(
        _fieldNameMeta,
        fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('field_value')) {
      context.handle(
        _fieldValueMeta,
        fieldValue.isAcceptableOrUnknown(data['field_value']!, _fieldValueMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFieldEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFieldEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenant_id'],
      )!,
      fieldName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_name'],
      )!,
      fieldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_value'],
      )!,
    );
  }

  @override
  $CustomFieldsTable createAlias(String alias) {
    return $CustomFieldsTable(attachedDatabase, alias);
  }
}

class CustomFieldEntity extends DataClass
    implements Insertable<CustomFieldEntity> {
  /// Primary key
  final int id;

  /// Foreign key to tenant
  final int tenantId;

  /// Field name (e.g., "Bike Number", "WiFi Password")
  final String fieldName;

  /// Field value
  final String fieldValue;
  const CustomFieldEntity({
    required this.id,
    required this.tenantId,
    required this.fieldName,
    required this.fieldValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['field_name'] = Variable<String>(fieldName);
    map['field_value'] = Variable<String>(fieldValue);
    return map;
  }

  CustomFieldsCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      fieldName: Value(fieldName),
      fieldValue: Value(fieldValue),
    );
  }

  factory CustomFieldEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFieldEntity(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      fieldValue: serializer.fromJson<String>(json['fieldValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'fieldName': serializer.toJson<String>(fieldName),
      'fieldValue': serializer.toJson<String>(fieldValue),
    };
  }

  CustomFieldEntity copyWith({
    int? id,
    int? tenantId,
    String? fieldName,
    String? fieldValue,
  }) => CustomFieldEntity(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    fieldName: fieldName ?? this.fieldName,
    fieldValue: fieldValue ?? this.fieldValue,
  );
  CustomFieldEntity copyWithCompanion(CustomFieldsCompanion data) {
    return CustomFieldEntity(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      fieldName: data.fieldName.present ? data.fieldName.value : this.fieldName,
      fieldValue: data.fieldValue.present
          ? data.fieldValue.value
          : this.fieldValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldEntity(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, fieldName, fieldValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFieldEntity &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.fieldName == this.fieldName &&
          other.fieldValue == this.fieldValue);
}

class CustomFieldsCompanion extends UpdateCompanion<CustomFieldEntity> {
  final Value<int> id;
  final Value<int> tenantId;
  final Value<String> fieldName;
  final Value<String> fieldValue;
  const CustomFieldsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.fieldValue = const Value.absent(),
  });
  CustomFieldsCompanion.insert({
    this.id = const Value.absent(),
    required int tenantId,
    required String fieldName,
    required String fieldValue,
  }) : tenantId = Value(tenantId),
       fieldName = Value(fieldName),
       fieldValue = Value(fieldValue);
  static Insertable<CustomFieldEntity> custom({
    Expression<int>? id,
    Expression<int>? tenantId,
    Expression<String>? fieldName,
    Expression<String>? fieldValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (fieldName != null) 'field_name': fieldName,
      if (fieldValue != null) 'field_value': fieldValue,
    });
  }

  CustomFieldsCompanion copyWith({
    Value<int>? id,
    Value<int>? tenantId,
    Value<String>? fieldName,
    Value<String>? fieldValue,
  }) {
    return CustomFieldsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      fieldName: fieldName ?? this.fieldName,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (fieldValue.present) {
      map['field_value'] = Variable<String>(fieldValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }
}

class $OccupanciesTable extends Occupancies
    with TableInfo<$OccupanciesTable, OccupancyEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OccupanciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id)',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id)',
    ),
  );
  static const VerificationMeta _moveInDateMeta = const VerificationMeta(
    'moveInDate',
  );
  @override
  late final GeneratedColumn<DateTime> moveInDate = GeneratedColumn<DateTime>(
    'move_in_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moveOutDateMeta = const VerificationMeta(
    'moveOutDate',
  );
  @override
  late final GeneratedColumn<DateTime> moveOutDate = GeneratedColumn<DateTime>(
    'move_out_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _agreedRentMeta = const VerificationMeta(
    'agreedRent',
  );
  @override
  late final GeneratedColumn<double> agreedRent = GeneratedColumn<double>(
    'agreed_rent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _securityDepositMeta = const VerificationMeta(
    'securityDeposit',
  );
  @override
  late final GeneratedColumn<double> securityDeposit = GeneratedColumn<double>(
    'security_deposit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DepositStatus, String>
  depositStatus = GeneratedColumn<String>(
    'deposit_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(DepositStatus.pending.name),
  ).withConverter<DepositStatus>($OccupanciesTable.$converterdepositStatus);
  static const VerificationMeta _depositReceivedDateMeta =
      const VerificationMeta('depositReceivedDate');
  @override
  late final GeneratedColumn<DateTime> depositReceivedDate =
      GeneratedColumn<DateTime>(
        'deposit_received_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _depositReturnedDateMeta =
      const VerificationMeta('depositReturnedDate');
  @override
  late final GeneratedColumn<DateTime> depositReturnedDate =
      GeneratedColumn<DateTime>(
        'deposit_returned_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _depositReturnedAmountMeta =
      const VerificationMeta('depositReturnedAmount');
  @override
  late final GeneratedColumn<double> depositReturnedAmount =
      GeneratedColumn<double>(
        'deposit_returned_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    tenantId,
    moveInDate,
    moveOutDate,
    agreedRent,
    securityDeposit,
    isActive,
    depositStatus,
    depositReceivedDate,
    depositReturnedDate,
    depositReturnedAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occupancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<OccupancyEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('move_in_date')) {
      context.handle(
        _moveInDateMeta,
        moveInDate.isAcceptableOrUnknown(
          data['move_in_date']!,
          _moveInDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_moveInDateMeta);
    }
    if (data.containsKey('move_out_date')) {
      context.handle(
        _moveOutDateMeta,
        moveOutDate.isAcceptableOrUnknown(
          data['move_out_date']!,
          _moveOutDateMeta,
        ),
      );
    }
    if (data.containsKey('agreed_rent')) {
      context.handle(
        _agreedRentMeta,
        agreedRent.isAcceptableOrUnknown(data['agreed_rent']!, _agreedRentMeta),
      );
    } else if (isInserting) {
      context.missing(_agreedRentMeta);
    }
    if (data.containsKey('security_deposit')) {
      context.handle(
        _securityDepositMeta,
        securityDeposit.isAcceptableOrUnknown(
          data['security_deposit']!,
          _securityDepositMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('deposit_received_date')) {
      context.handle(
        _depositReceivedDateMeta,
        depositReceivedDate.isAcceptableOrUnknown(
          data['deposit_received_date']!,
          _depositReceivedDateMeta,
        ),
      );
    }
    if (data.containsKey('deposit_returned_date')) {
      context.handle(
        _depositReturnedDateMeta,
        depositReturnedDate.isAcceptableOrUnknown(
          data['deposit_returned_date']!,
          _depositReturnedDateMeta,
        ),
      );
    }
    if (data.containsKey('deposit_returned_amount')) {
      context.handle(
        _depositReturnedAmountMeta,
        depositReturnedAmount.isAcceptableOrUnknown(
          data['deposit_returned_amount']!,
          _depositReturnedAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OccupancyEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OccupancyEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenant_id'],
      )!,
      moveInDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}move_in_date'],
      )!,
      moveOutDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}move_out_date'],
      ),
      agreedRent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}agreed_rent'],
      )!,
      securityDeposit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}security_deposit'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      depositStatus: $OccupanciesTable.$converterdepositStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}deposit_status'],
        )!,
      ),
      depositReceivedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deposit_received_date'],
      ),
      depositReturnedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deposit_returned_date'],
      ),
      depositReturnedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}deposit_returned_amount'],
      ),
    );
  }

  @override
  $OccupanciesTable createAlias(String alias) {
    return $OccupanciesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DepositStatus, String, String>
  $converterdepositStatus = const EnumNameConverter<DepositStatus>(
    DepositStatus.values,
  );
}

class OccupancyEntity extends DataClass implements Insertable<OccupancyEntity> {
  /// Primary key
  final int id;

  /// Foreign key to room
  final int roomId;

  /// Foreign key to tenant
  final int tenantId;

  /// Move-in date
  final DateTime moveInDate;

  /// Move-out date (null if still active)
  final DateTime? moveOutDate;

  /// Agreed monthly rent for this occupancy
  final double agreedRent;

  /// Security deposit amount
  final double securityDeposit;

  /// Whether this is the current active occupancy
  final bool isActive;

  /// Deposit status
  final DepositStatus depositStatus;

  /// Date deposit was received
  final DateTime? depositReceivedDate;

  /// Date deposit was returned
  final DateTime? depositReturnedDate;

  /// Amount returned (may differ from original if deductions)
  final double? depositReturnedAmount;
  const OccupancyEntity({
    required this.id,
    required this.roomId,
    required this.tenantId,
    required this.moveInDate,
    this.moveOutDate,
    required this.agreedRent,
    required this.securityDeposit,
    required this.isActive,
    required this.depositStatus,
    this.depositReceivedDate,
    this.depositReturnedDate,
    this.depositReturnedAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['room_id'] = Variable<int>(roomId);
    map['tenant_id'] = Variable<int>(tenantId);
    map['move_in_date'] = Variable<DateTime>(moveInDate);
    if (!nullToAbsent || moveOutDate != null) {
      map['move_out_date'] = Variable<DateTime>(moveOutDate);
    }
    map['agreed_rent'] = Variable<double>(agreedRent);
    map['security_deposit'] = Variable<double>(securityDeposit);
    map['is_active'] = Variable<bool>(isActive);
    {
      map['deposit_status'] = Variable<String>(
        $OccupanciesTable.$converterdepositStatus.toSql(depositStatus),
      );
    }
    if (!nullToAbsent || depositReceivedDate != null) {
      map['deposit_received_date'] = Variable<DateTime>(depositReceivedDate);
    }
    if (!nullToAbsent || depositReturnedDate != null) {
      map['deposit_returned_date'] = Variable<DateTime>(depositReturnedDate);
    }
    if (!nullToAbsent || depositReturnedAmount != null) {
      map['deposit_returned_amount'] = Variable<double>(depositReturnedAmount);
    }
    return map;
  }

  OccupanciesCompanion toCompanion(bool nullToAbsent) {
    return OccupanciesCompanion(
      id: Value(id),
      roomId: Value(roomId),
      tenantId: Value(tenantId),
      moveInDate: Value(moveInDate),
      moveOutDate: moveOutDate == null && nullToAbsent
          ? const Value.absent()
          : Value(moveOutDate),
      agreedRent: Value(agreedRent),
      securityDeposit: Value(securityDeposit),
      isActive: Value(isActive),
      depositStatus: Value(depositStatus),
      depositReceivedDate: depositReceivedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(depositReceivedDate),
      depositReturnedDate: depositReturnedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(depositReturnedDate),
      depositReturnedAmount: depositReturnedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(depositReturnedAmount),
    );
  }

  factory OccupancyEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OccupancyEntity(
      id: serializer.fromJson<int>(json['id']),
      roomId: serializer.fromJson<int>(json['roomId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      moveInDate: serializer.fromJson<DateTime>(json['moveInDate']),
      moveOutDate: serializer.fromJson<DateTime?>(json['moveOutDate']),
      agreedRent: serializer.fromJson<double>(json['agreedRent']),
      securityDeposit: serializer.fromJson<double>(json['securityDeposit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      depositStatus: $OccupanciesTable.$converterdepositStatus.fromJson(
        serializer.fromJson<String>(json['depositStatus']),
      ),
      depositReceivedDate: serializer.fromJson<DateTime?>(
        json['depositReceivedDate'],
      ),
      depositReturnedDate: serializer.fromJson<DateTime?>(
        json['depositReturnedDate'],
      ),
      depositReturnedAmount: serializer.fromJson<double?>(
        json['depositReturnedAmount'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roomId': serializer.toJson<int>(roomId),
      'tenantId': serializer.toJson<int>(tenantId),
      'moveInDate': serializer.toJson<DateTime>(moveInDate),
      'moveOutDate': serializer.toJson<DateTime?>(moveOutDate),
      'agreedRent': serializer.toJson<double>(agreedRent),
      'securityDeposit': serializer.toJson<double>(securityDeposit),
      'isActive': serializer.toJson<bool>(isActive),
      'depositStatus': serializer.toJson<String>(
        $OccupanciesTable.$converterdepositStatus.toJson(depositStatus),
      ),
      'depositReceivedDate': serializer.toJson<DateTime?>(depositReceivedDate),
      'depositReturnedDate': serializer.toJson<DateTime?>(depositReturnedDate),
      'depositReturnedAmount': serializer.toJson<double?>(
        depositReturnedAmount,
      ),
    };
  }

  OccupancyEntity copyWith({
    int? id,
    int? roomId,
    int? tenantId,
    DateTime? moveInDate,
    Value<DateTime?> moveOutDate = const Value.absent(),
    double? agreedRent,
    double? securityDeposit,
    bool? isActive,
    DepositStatus? depositStatus,
    Value<DateTime?> depositReceivedDate = const Value.absent(),
    Value<DateTime?> depositReturnedDate = const Value.absent(),
    Value<double?> depositReturnedAmount = const Value.absent(),
  }) => OccupancyEntity(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    tenantId: tenantId ?? this.tenantId,
    moveInDate: moveInDate ?? this.moveInDate,
    moveOutDate: moveOutDate.present ? moveOutDate.value : this.moveOutDate,
    agreedRent: agreedRent ?? this.agreedRent,
    securityDeposit: securityDeposit ?? this.securityDeposit,
    isActive: isActive ?? this.isActive,
    depositStatus: depositStatus ?? this.depositStatus,
    depositReceivedDate: depositReceivedDate.present
        ? depositReceivedDate.value
        : this.depositReceivedDate,
    depositReturnedDate: depositReturnedDate.present
        ? depositReturnedDate.value
        : this.depositReturnedDate,
    depositReturnedAmount: depositReturnedAmount.present
        ? depositReturnedAmount.value
        : this.depositReturnedAmount,
  );
  OccupancyEntity copyWithCompanion(OccupanciesCompanion data) {
    return OccupancyEntity(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      moveInDate: data.moveInDate.present
          ? data.moveInDate.value
          : this.moveInDate,
      moveOutDate: data.moveOutDate.present
          ? data.moveOutDate.value
          : this.moveOutDate,
      agreedRent: data.agreedRent.present
          ? data.agreedRent.value
          : this.agreedRent,
      securityDeposit: data.securityDeposit.present
          ? data.securityDeposit.value
          : this.securityDeposit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      depositStatus: data.depositStatus.present
          ? data.depositStatus.value
          : this.depositStatus,
      depositReceivedDate: data.depositReceivedDate.present
          ? data.depositReceivedDate.value
          : this.depositReceivedDate,
      depositReturnedDate: data.depositReturnedDate.present
          ? data.depositReturnedDate.value
          : this.depositReturnedDate,
      depositReturnedAmount: data.depositReturnedAmount.present
          ? data.depositReturnedAmount.value
          : this.depositReturnedAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OccupancyEntity(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('tenantId: $tenantId, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('moveOutDate: $moveOutDate, ')
          ..write('agreedRent: $agreedRent, ')
          ..write('securityDeposit: $securityDeposit, ')
          ..write('isActive: $isActive, ')
          ..write('depositStatus: $depositStatus, ')
          ..write('depositReceivedDate: $depositReceivedDate, ')
          ..write('depositReturnedDate: $depositReturnedDate, ')
          ..write('depositReturnedAmount: $depositReturnedAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomId,
    tenantId,
    moveInDate,
    moveOutDate,
    agreedRent,
    securityDeposit,
    isActive,
    depositStatus,
    depositReceivedDate,
    depositReturnedDate,
    depositReturnedAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OccupancyEntity &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.tenantId == this.tenantId &&
          other.moveInDate == this.moveInDate &&
          other.moveOutDate == this.moveOutDate &&
          other.agreedRent == this.agreedRent &&
          other.securityDeposit == this.securityDeposit &&
          other.isActive == this.isActive &&
          other.depositStatus == this.depositStatus &&
          other.depositReceivedDate == this.depositReceivedDate &&
          other.depositReturnedDate == this.depositReturnedDate &&
          other.depositReturnedAmount == this.depositReturnedAmount);
}

class OccupanciesCompanion extends UpdateCompanion<OccupancyEntity> {
  final Value<int> id;
  final Value<int> roomId;
  final Value<int> tenantId;
  final Value<DateTime> moveInDate;
  final Value<DateTime?> moveOutDate;
  final Value<double> agreedRent;
  final Value<double> securityDeposit;
  final Value<bool> isActive;
  final Value<DepositStatus> depositStatus;
  final Value<DateTime?> depositReceivedDate;
  final Value<DateTime?> depositReturnedDate;
  final Value<double?> depositReturnedAmount;
  const OccupanciesCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.moveInDate = const Value.absent(),
    this.moveOutDate = const Value.absent(),
    this.agreedRent = const Value.absent(),
    this.securityDeposit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.depositStatus = const Value.absent(),
    this.depositReceivedDate = const Value.absent(),
    this.depositReturnedDate = const Value.absent(),
    this.depositReturnedAmount = const Value.absent(),
  });
  OccupanciesCompanion.insert({
    this.id = const Value.absent(),
    required int roomId,
    required int tenantId,
    required DateTime moveInDate,
    this.moveOutDate = const Value.absent(),
    required double agreedRent,
    this.securityDeposit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.depositStatus = const Value.absent(),
    this.depositReceivedDate = const Value.absent(),
    this.depositReturnedDate = const Value.absent(),
    this.depositReturnedAmount = const Value.absent(),
  }) : roomId = Value(roomId),
       tenantId = Value(tenantId),
       moveInDate = Value(moveInDate),
       agreedRent = Value(agreedRent);
  static Insertable<OccupancyEntity> custom({
    Expression<int>? id,
    Expression<int>? roomId,
    Expression<int>? tenantId,
    Expression<DateTime>? moveInDate,
    Expression<DateTime>? moveOutDate,
    Expression<double>? agreedRent,
    Expression<double>? securityDeposit,
    Expression<bool>? isActive,
    Expression<String>? depositStatus,
    Expression<DateTime>? depositReceivedDate,
    Expression<DateTime>? depositReturnedDate,
    Expression<double>? depositReturnedAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (moveInDate != null) 'move_in_date': moveInDate,
      if (moveOutDate != null) 'move_out_date': moveOutDate,
      if (agreedRent != null) 'agreed_rent': agreedRent,
      if (securityDeposit != null) 'security_deposit': securityDeposit,
      if (isActive != null) 'is_active': isActive,
      if (depositStatus != null) 'deposit_status': depositStatus,
      if (depositReceivedDate != null)
        'deposit_received_date': depositReceivedDate,
      if (depositReturnedDate != null)
        'deposit_returned_date': depositReturnedDate,
      if (depositReturnedAmount != null)
        'deposit_returned_amount': depositReturnedAmount,
    });
  }

  OccupanciesCompanion copyWith({
    Value<int>? id,
    Value<int>? roomId,
    Value<int>? tenantId,
    Value<DateTime>? moveInDate,
    Value<DateTime?>? moveOutDate,
    Value<double>? agreedRent,
    Value<double>? securityDeposit,
    Value<bool>? isActive,
    Value<DepositStatus>? depositStatus,
    Value<DateTime?>? depositReceivedDate,
    Value<DateTime?>? depositReturnedDate,
    Value<double?>? depositReturnedAmount,
  }) {
    return OccupanciesCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      tenantId: tenantId ?? this.tenantId,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      agreedRent: agreedRent ?? this.agreedRent,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      isActive: isActive ?? this.isActive,
      depositStatus: depositStatus ?? this.depositStatus,
      depositReceivedDate: depositReceivedDate ?? this.depositReceivedDate,
      depositReturnedDate: depositReturnedDate ?? this.depositReturnedDate,
      depositReturnedAmount:
          depositReturnedAmount ?? this.depositReturnedAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (moveInDate.present) {
      map['move_in_date'] = Variable<DateTime>(moveInDate.value);
    }
    if (moveOutDate.present) {
      map['move_out_date'] = Variable<DateTime>(moveOutDate.value);
    }
    if (agreedRent.present) {
      map['agreed_rent'] = Variable<double>(agreedRent.value);
    }
    if (securityDeposit.present) {
      map['security_deposit'] = Variable<double>(securityDeposit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (depositStatus.present) {
      map['deposit_status'] = Variable<String>(
        $OccupanciesTable.$converterdepositStatus.toSql(depositStatus.value),
      );
    }
    if (depositReceivedDate.present) {
      map['deposit_received_date'] = Variable<DateTime>(
        depositReceivedDate.value,
      );
    }
    if (depositReturnedDate.present) {
      map['deposit_returned_date'] = Variable<DateTime>(
        depositReturnedDate.value,
      );
    }
    if (depositReturnedAmount.present) {
      map['deposit_returned_amount'] = Variable<double>(
        depositReturnedAmount.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccupanciesCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('tenantId: $tenantId, ')
          ..write('moveInDate: $moveInDate, ')
          ..write('moveOutDate: $moveOutDate, ')
          ..write('agreedRent: $agreedRent, ')
          ..write('securityDeposit: $securityDeposit, ')
          ..write('isActive: $isActive, ')
          ..write('depositStatus: $depositStatus, ')
          ..write('depositReceivedDate: $depositReceivedDate, ')
          ..write('depositReturnedDate: $depositReturnedDate, ')
          ..write('depositReturnedAmount: $depositReturnedAmount')
          ..write(')'))
        .toString();
  }
}

class $BillsTable extends Bills with TableInfo<$BillsTable, BillEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _occupancyIdMeta = const VerificationMeta(
    'occupancyId',
  );
  @override
  late final GeneratedColumn<int> occupancyId = GeneratedColumn<int>(
    'occupancy_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES occupancies (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BillType, String> billType =
      GeneratedColumn<String>(
        'bill_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BillType>($BillsTable.$converterbillType);
  static const VerificationMeta _billingMonthMeta = const VerificationMeta(
    'billingMonth',
  );
  @override
  late final GeneratedColumn<int> billingMonth = GeneratedColumn<int>(
    'billing_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingYearMeta = const VerificationMeta(
    'billingYear',
  );
  @override
  late final GeneratedColumn<int> billingYear = GeneratedColumn<int>(
    'billing_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodStartDateMeta = const VerificationMeta(
    'periodStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> periodStartDate =
      GeneratedColumn<DateTime>(
        'period_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _periodEndDateMeta = const VerificationMeta(
    'periodEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> periodEndDate =
      GeneratedColumn<DateTime>(
        'period_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _electricityPrevReadingMeta =
      const VerificationMeta('electricityPrevReading');
  @override
  late final GeneratedColumn<double> electricityPrevReading =
      GeneratedColumn<double>(
        'electricity_prev_reading',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _electricityCurrReadingMeta =
      const VerificationMeta('electricityCurrReading');
  @override
  late final GeneratedColumn<double> electricityCurrReading =
      GeneratedColumn<double>(
        'electricity_curr_reading',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _electricityRateAtBillingMeta =
      const VerificationMeta('electricityRateAtBilling');
  @override
  late final GeneratedColumn<double> electricityRateAtBilling =
      GeneratedColumn<double>(
        'electricity_rate_at_billing',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _electricityChargesMeta =
      const VerificationMeta('electricityCharges');
  @override
  late final GeneratedColumn<double> electricityCharges =
      GeneratedColumn<double>(
        'electricity_charges',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _meterPhotoPathMeta = const VerificationMeta(
    'meterPhotoPath',
  );
  @override
  late final GeneratedColumn<String> meterPhotoPath = GeneratedColumn<String>(
    'meter_photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occupancyId,
    billType,
    billingMonth,
    billingYear,
    periodStartDate,
    periodEndDate,
    amount,
    electricityPrevReading,
    electricityCurrReading,
    electricityRateAtBilling,
    electricityCharges,
    meterPhotoPath,
    notes,
    createdAt,
    dueDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occupancy_id')) {
      context.handle(
        _occupancyIdMeta,
        occupancyId.isAcceptableOrUnknown(
          data['occupancy_id']!,
          _occupancyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occupancyIdMeta);
    }
    if (data.containsKey('billing_month')) {
      context.handle(
        _billingMonthMeta,
        billingMonth.isAcceptableOrUnknown(
          data['billing_month']!,
          _billingMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingMonthMeta);
    }
    if (data.containsKey('billing_year')) {
      context.handle(
        _billingYearMeta,
        billingYear.isAcceptableOrUnknown(
          data['billing_year']!,
          _billingYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingYearMeta);
    }
    if (data.containsKey('period_start_date')) {
      context.handle(
        _periodStartDateMeta,
        periodStartDate.isAcceptableOrUnknown(
          data['period_start_date']!,
          _periodStartDateMeta,
        ),
      );
    }
    if (data.containsKey('period_end_date')) {
      context.handle(
        _periodEndDateMeta,
        periodEndDate.isAcceptableOrUnknown(
          data['period_end_date']!,
          _periodEndDateMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('electricity_prev_reading')) {
      context.handle(
        _electricityPrevReadingMeta,
        electricityPrevReading.isAcceptableOrUnknown(
          data['electricity_prev_reading']!,
          _electricityPrevReadingMeta,
        ),
      );
    }
    if (data.containsKey('electricity_curr_reading')) {
      context.handle(
        _electricityCurrReadingMeta,
        electricityCurrReading.isAcceptableOrUnknown(
          data['electricity_curr_reading']!,
          _electricityCurrReadingMeta,
        ),
      );
    }
    if (data.containsKey('electricity_rate_at_billing')) {
      context.handle(
        _electricityRateAtBillingMeta,
        electricityRateAtBilling.isAcceptableOrUnknown(
          data['electricity_rate_at_billing']!,
          _electricityRateAtBillingMeta,
        ),
      );
    }
    if (data.containsKey('electricity_charges')) {
      context.handle(
        _electricityChargesMeta,
        electricityCharges.isAcceptableOrUnknown(
          data['electricity_charges']!,
          _electricityChargesMeta,
        ),
      );
    }
    if (data.containsKey('meter_photo_path')) {
      context.handle(
        _meterPhotoPathMeta,
        meterPhotoPath.isAcceptableOrUnknown(
          data['meter_photo_path']!,
          _meterPhotoPathMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occupancyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occupancy_id'],
      )!,
      billType: $BillsTable.$converterbillType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}bill_type'],
        )!,
      ),
      billingMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_month'],
      )!,
      billingYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_year'],
      )!,
      periodStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start_date'],
      ),
      periodEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_end_date'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      electricityPrevReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}electricity_prev_reading'],
      ),
      electricityCurrReading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}electricity_curr_reading'],
      ),
      electricityRateAtBilling: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}electricity_rate_at_billing'],
      ),
      electricityCharges: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}electricity_charges'],
      ),
      meterPhotoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meter_photo_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BillType, String, String> $converterbillType =
      const EnumNameConverter<BillType>(BillType.values);
}

class BillEntity extends DataClass implements Insertable<BillEntity> {
  /// Primary key
  final int id;

  /// Foreign key to occupancy
  final int occupancyId;

  /// Type of bill
  final BillType billType;

  /// Billing month (1-12)
  final int billingMonth;

  /// Billing year
  final int billingYear;

  /// Period start date (for pro-rating)
  final DateTime? periodStartDate;

  /// Period end date (for pro-rating)
  final DateTime? periodEndDate;

  /// Total bill amount
  final double amount;

  /// Previous electricity meter reading
  final double? electricityPrevReading;

  /// Current electricity meter reading
  final double? electricityCurrReading;

  /// Electricity rate at time of billing (frozen)
  final double? electricityRateAtBilling;

  /// Calculated electricity charges
  final double? electricityCharges;

  /// Photo of the electricity meter reading
  final String? meterPhotoPath;

  /// Additional notes
  final String? notes;

  /// Bill creation date
  final DateTime createdAt;

  /// Due date for payment
  final DateTime? dueDate;
  const BillEntity({
    required this.id,
    required this.occupancyId,
    required this.billType,
    required this.billingMonth,
    required this.billingYear,
    this.periodStartDate,
    this.periodEndDate,
    required this.amount,
    this.electricityPrevReading,
    this.electricityCurrReading,
    this.electricityRateAtBilling,
    this.electricityCharges,
    this.meterPhotoPath,
    this.notes,
    required this.createdAt,
    this.dueDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occupancy_id'] = Variable<int>(occupancyId);
    {
      map['bill_type'] = Variable<String>(
        $BillsTable.$converterbillType.toSql(billType),
      );
    }
    map['billing_month'] = Variable<int>(billingMonth);
    map['billing_year'] = Variable<int>(billingYear);
    if (!nullToAbsent || periodStartDate != null) {
      map['period_start_date'] = Variable<DateTime>(periodStartDate);
    }
    if (!nullToAbsent || periodEndDate != null) {
      map['period_end_date'] = Variable<DateTime>(periodEndDate);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || electricityPrevReading != null) {
      map['electricity_prev_reading'] = Variable<double>(
        electricityPrevReading,
      );
    }
    if (!nullToAbsent || electricityCurrReading != null) {
      map['electricity_curr_reading'] = Variable<double>(
        electricityCurrReading,
      );
    }
    if (!nullToAbsent || electricityRateAtBilling != null) {
      map['electricity_rate_at_billing'] = Variable<double>(
        electricityRateAtBilling,
      );
    }
    if (!nullToAbsent || electricityCharges != null) {
      map['electricity_charges'] = Variable<double>(electricityCharges);
    }
    if (!nullToAbsent || meterPhotoPath != null) {
      map['meter_photo_path'] = Variable<String>(meterPhotoPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      occupancyId: Value(occupancyId),
      billType: Value(billType),
      billingMonth: Value(billingMonth),
      billingYear: Value(billingYear),
      periodStartDate: periodStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(periodStartDate),
      periodEndDate: periodEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(periodEndDate),
      amount: Value(amount),
      electricityPrevReading: electricityPrevReading == null && nullToAbsent
          ? const Value.absent()
          : Value(electricityPrevReading),
      electricityCurrReading: electricityCurrReading == null && nullToAbsent
          ? const Value.absent()
          : Value(electricityCurrReading),
      electricityRateAtBilling: electricityRateAtBilling == null && nullToAbsent
          ? const Value.absent()
          : Value(electricityRateAtBilling),
      electricityCharges: electricityCharges == null && nullToAbsent
          ? const Value.absent()
          : Value(electricityCharges),
      meterPhotoPath: meterPhotoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(meterPhotoPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  factory BillEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillEntity(
      id: serializer.fromJson<int>(json['id']),
      occupancyId: serializer.fromJson<int>(json['occupancyId']),
      billType: $BillsTable.$converterbillType.fromJson(
        serializer.fromJson<String>(json['billType']),
      ),
      billingMonth: serializer.fromJson<int>(json['billingMonth']),
      billingYear: serializer.fromJson<int>(json['billingYear']),
      periodStartDate: serializer.fromJson<DateTime?>(json['periodStartDate']),
      periodEndDate: serializer.fromJson<DateTime?>(json['periodEndDate']),
      amount: serializer.fromJson<double>(json['amount']),
      electricityPrevReading: serializer.fromJson<double?>(
        json['electricityPrevReading'],
      ),
      electricityCurrReading: serializer.fromJson<double?>(
        json['electricityCurrReading'],
      ),
      electricityRateAtBilling: serializer.fromJson<double?>(
        json['electricityRateAtBilling'],
      ),
      electricityCharges: serializer.fromJson<double?>(
        json['electricityCharges'],
      ),
      meterPhotoPath: serializer.fromJson<String?>(json['meterPhotoPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occupancyId': serializer.toJson<int>(occupancyId),
      'billType': serializer.toJson<String>(
        $BillsTable.$converterbillType.toJson(billType),
      ),
      'billingMonth': serializer.toJson<int>(billingMonth),
      'billingYear': serializer.toJson<int>(billingYear),
      'periodStartDate': serializer.toJson<DateTime?>(periodStartDate),
      'periodEndDate': serializer.toJson<DateTime?>(periodEndDate),
      'amount': serializer.toJson<double>(amount),
      'electricityPrevReading': serializer.toJson<double?>(
        electricityPrevReading,
      ),
      'electricityCurrReading': serializer.toJson<double?>(
        electricityCurrReading,
      ),
      'electricityRateAtBilling': serializer.toJson<double?>(
        electricityRateAtBilling,
      ),
      'electricityCharges': serializer.toJson<double?>(electricityCharges),
      'meterPhotoPath': serializer.toJson<String?>(meterPhotoPath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
    };
  }

  BillEntity copyWith({
    int? id,
    int? occupancyId,
    BillType? billType,
    int? billingMonth,
    int? billingYear,
    Value<DateTime?> periodStartDate = const Value.absent(),
    Value<DateTime?> periodEndDate = const Value.absent(),
    double? amount,
    Value<double?> electricityPrevReading = const Value.absent(),
    Value<double?> electricityCurrReading = const Value.absent(),
    Value<double?> electricityRateAtBilling = const Value.absent(),
    Value<double?> electricityCharges = const Value.absent(),
    Value<String?> meterPhotoPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> dueDate = const Value.absent(),
  }) => BillEntity(
    id: id ?? this.id,
    occupancyId: occupancyId ?? this.occupancyId,
    billType: billType ?? this.billType,
    billingMonth: billingMonth ?? this.billingMonth,
    billingYear: billingYear ?? this.billingYear,
    periodStartDate: periodStartDate.present
        ? periodStartDate.value
        : this.periodStartDate,
    periodEndDate: periodEndDate.present
        ? periodEndDate.value
        : this.periodEndDate,
    amount: amount ?? this.amount,
    electricityPrevReading: electricityPrevReading.present
        ? electricityPrevReading.value
        : this.electricityPrevReading,
    electricityCurrReading: electricityCurrReading.present
        ? electricityCurrReading.value
        : this.electricityCurrReading,
    electricityRateAtBilling: electricityRateAtBilling.present
        ? electricityRateAtBilling.value
        : this.electricityRateAtBilling,
    electricityCharges: electricityCharges.present
        ? electricityCharges.value
        : this.electricityCharges,
    meterPhotoPath: meterPhotoPath.present
        ? meterPhotoPath.value
        : this.meterPhotoPath,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
  );
  BillEntity copyWithCompanion(BillsCompanion data) {
    return BillEntity(
      id: data.id.present ? data.id.value : this.id,
      occupancyId: data.occupancyId.present
          ? data.occupancyId.value
          : this.occupancyId,
      billType: data.billType.present ? data.billType.value : this.billType,
      billingMonth: data.billingMonth.present
          ? data.billingMonth.value
          : this.billingMonth,
      billingYear: data.billingYear.present
          ? data.billingYear.value
          : this.billingYear,
      periodStartDate: data.periodStartDate.present
          ? data.periodStartDate.value
          : this.periodStartDate,
      periodEndDate: data.periodEndDate.present
          ? data.periodEndDate.value
          : this.periodEndDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      electricityPrevReading: data.electricityPrevReading.present
          ? data.electricityPrevReading.value
          : this.electricityPrevReading,
      electricityCurrReading: data.electricityCurrReading.present
          ? data.electricityCurrReading.value
          : this.electricityCurrReading,
      electricityRateAtBilling: data.electricityRateAtBilling.present
          ? data.electricityRateAtBilling.value
          : this.electricityRateAtBilling,
      electricityCharges: data.electricityCharges.present
          ? data.electricityCharges.value
          : this.electricityCharges,
      meterPhotoPath: data.meterPhotoPath.present
          ? data.meterPhotoPath.value
          : this.meterPhotoPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillEntity(')
          ..write('id: $id, ')
          ..write('occupancyId: $occupancyId, ')
          ..write('billType: $billType, ')
          ..write('billingMonth: $billingMonth, ')
          ..write('billingYear: $billingYear, ')
          ..write('periodStartDate: $periodStartDate, ')
          ..write('periodEndDate: $periodEndDate, ')
          ..write('amount: $amount, ')
          ..write('electricityPrevReading: $electricityPrevReading, ')
          ..write('electricityCurrReading: $electricityCurrReading, ')
          ..write('electricityRateAtBilling: $electricityRateAtBilling, ')
          ..write('electricityCharges: $electricityCharges, ')
          ..write('meterPhotoPath: $meterPhotoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occupancyId,
    billType,
    billingMonth,
    billingYear,
    periodStartDate,
    periodEndDate,
    amount,
    electricityPrevReading,
    electricityCurrReading,
    electricityRateAtBilling,
    electricityCharges,
    meterPhotoPath,
    notes,
    createdAt,
    dueDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillEntity &&
          other.id == this.id &&
          other.occupancyId == this.occupancyId &&
          other.billType == this.billType &&
          other.billingMonth == this.billingMonth &&
          other.billingYear == this.billingYear &&
          other.periodStartDate == this.periodStartDate &&
          other.periodEndDate == this.periodEndDate &&
          other.amount == this.amount &&
          other.electricityPrevReading == this.electricityPrevReading &&
          other.electricityCurrReading == this.electricityCurrReading &&
          other.electricityRateAtBilling == this.electricityRateAtBilling &&
          other.electricityCharges == this.electricityCharges &&
          other.meterPhotoPath == this.meterPhotoPath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.dueDate == this.dueDate);
}

class BillsCompanion extends UpdateCompanion<BillEntity> {
  final Value<int> id;
  final Value<int> occupancyId;
  final Value<BillType> billType;
  final Value<int> billingMonth;
  final Value<int> billingYear;
  final Value<DateTime?> periodStartDate;
  final Value<DateTime?> periodEndDate;
  final Value<double> amount;
  final Value<double?> electricityPrevReading;
  final Value<double?> electricityCurrReading;
  final Value<double?> electricityRateAtBilling;
  final Value<double?> electricityCharges;
  final Value<String?> meterPhotoPath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> dueDate;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.occupancyId = const Value.absent(),
    this.billType = const Value.absent(),
    this.billingMonth = const Value.absent(),
    this.billingYear = const Value.absent(),
    this.periodStartDate = const Value.absent(),
    this.periodEndDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.electricityPrevReading = const Value.absent(),
    this.electricityCurrReading = const Value.absent(),
    this.electricityRateAtBilling = const Value.absent(),
    this.electricityCharges = const Value.absent(),
    this.meterPhotoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
  });
  BillsCompanion.insert({
    this.id = const Value.absent(),
    required int occupancyId,
    required BillType billType,
    required int billingMonth,
    required int billingYear,
    this.periodStartDate = const Value.absent(),
    this.periodEndDate = const Value.absent(),
    required double amount,
    this.electricityPrevReading = const Value.absent(),
    this.electricityCurrReading = const Value.absent(),
    this.electricityRateAtBilling = const Value.absent(),
    this.electricityCharges = const Value.absent(),
    this.meterPhotoPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueDate = const Value.absent(),
  }) : occupancyId = Value(occupancyId),
       billType = Value(billType),
       billingMonth = Value(billingMonth),
       billingYear = Value(billingYear),
       amount = Value(amount);
  static Insertable<BillEntity> custom({
    Expression<int>? id,
    Expression<int>? occupancyId,
    Expression<String>? billType,
    Expression<int>? billingMonth,
    Expression<int>? billingYear,
    Expression<DateTime>? periodStartDate,
    Expression<DateTime>? periodEndDate,
    Expression<double>? amount,
    Expression<double>? electricityPrevReading,
    Expression<double>? electricityCurrReading,
    Expression<double>? electricityRateAtBilling,
    Expression<double>? electricityCharges,
    Expression<String>? meterPhotoPath,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? dueDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occupancyId != null) 'occupancy_id': occupancyId,
      if (billType != null) 'bill_type': billType,
      if (billingMonth != null) 'billing_month': billingMonth,
      if (billingYear != null) 'billing_year': billingYear,
      if (periodStartDate != null) 'period_start_date': periodStartDate,
      if (periodEndDate != null) 'period_end_date': periodEndDate,
      if (amount != null) 'amount': amount,
      if (electricityPrevReading != null)
        'electricity_prev_reading': electricityPrevReading,
      if (electricityCurrReading != null)
        'electricity_curr_reading': electricityCurrReading,
      if (electricityRateAtBilling != null)
        'electricity_rate_at_billing': electricityRateAtBilling,
      if (electricityCharges != null) 'electricity_charges': electricityCharges,
      if (meterPhotoPath != null) 'meter_photo_path': meterPhotoPath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (dueDate != null) 'due_date': dueDate,
    });
  }

  BillsCompanion copyWith({
    Value<int>? id,
    Value<int>? occupancyId,
    Value<BillType>? billType,
    Value<int>? billingMonth,
    Value<int>? billingYear,
    Value<DateTime?>? periodStartDate,
    Value<DateTime?>? periodEndDate,
    Value<double>? amount,
    Value<double?>? electricityPrevReading,
    Value<double?>? electricityCurrReading,
    Value<double?>? electricityRateAtBilling,
    Value<double?>? electricityCharges,
    Value<String?>? meterPhotoPath,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? dueDate,
  }) {
    return BillsCompanion(
      id: id ?? this.id,
      occupancyId: occupancyId ?? this.occupancyId,
      billType: billType ?? this.billType,
      billingMonth: billingMonth ?? this.billingMonth,
      billingYear: billingYear ?? this.billingYear,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      amount: amount ?? this.amount,
      electricityPrevReading:
          electricityPrevReading ?? this.electricityPrevReading,
      electricityCurrReading:
          electricityCurrReading ?? this.electricityCurrReading,
      electricityRateAtBilling:
          electricityRateAtBilling ?? this.electricityRateAtBilling,
      electricityCharges: electricityCharges ?? this.electricityCharges,
      meterPhotoPath: meterPhotoPath ?? this.meterPhotoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occupancyId.present) {
      map['occupancy_id'] = Variable<int>(occupancyId.value);
    }
    if (billType.present) {
      map['bill_type'] = Variable<String>(
        $BillsTable.$converterbillType.toSql(billType.value),
      );
    }
    if (billingMonth.present) {
      map['billing_month'] = Variable<int>(billingMonth.value);
    }
    if (billingYear.present) {
      map['billing_year'] = Variable<int>(billingYear.value);
    }
    if (periodStartDate.present) {
      map['period_start_date'] = Variable<DateTime>(periodStartDate.value);
    }
    if (periodEndDate.present) {
      map['period_end_date'] = Variable<DateTime>(periodEndDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (electricityPrevReading.present) {
      map['electricity_prev_reading'] = Variable<double>(
        electricityPrevReading.value,
      );
    }
    if (electricityCurrReading.present) {
      map['electricity_curr_reading'] = Variable<double>(
        electricityCurrReading.value,
      );
    }
    if (electricityRateAtBilling.present) {
      map['electricity_rate_at_billing'] = Variable<double>(
        electricityRateAtBilling.value,
      );
    }
    if (electricityCharges.present) {
      map['electricity_charges'] = Variable<double>(electricityCharges.value);
    }
    if (meterPhotoPath.present) {
      map['meter_photo_path'] = Variable<String>(meterPhotoPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('occupancyId: $occupancyId, ')
          ..write('billType: $billType, ')
          ..write('billingMonth: $billingMonth, ')
          ..write('billingYear: $billingYear, ')
          ..write('periodStartDate: $periodStartDate, ')
          ..write('periodEndDate: $periodEndDate, ')
          ..write('amount: $amount, ')
          ..write('electricityPrevReading: $electricityPrevReading, ')
          ..write('electricityCurrReading: $electricityCurrReading, ')
          ..write('electricityRateAtBilling: $electricityRateAtBilling, ')
          ..write('electricityCharges: $electricityCharges, ')
          ..write('meterPhotoPath: $meterPhotoPath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, String> paymentMode =
      GeneratedColumn<String>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($PaymentsTable.$converterpaymentMode);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billId,
    amount,
    paymentMode,
    notes,
    paymentDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentMode: $PaymentsTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, String, String> $converterpaymentMode =
      const EnumNameConverter<PaymentMode>(PaymentMode.values);
}

class PaymentEntity extends DataClass implements Insertable<PaymentEntity> {
  /// Primary key
  final int id;

  /// Foreign key to bill
  final int billId;

  /// Payment amount
  final double amount;

  /// Mode of payment
  final PaymentMode paymentMode;

  /// Additional notes
  final String? notes;

  /// Payment date
  final DateTime paymentDate;
  const PaymentEntity({
    required this.id,
    required this.billId,
    required this.amount,
    required this.paymentMode,
    this.notes,
    required this.paymentDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_id'] = Variable<int>(billId);
    map['amount'] = Variable<double>(amount);
    {
      map['payment_mode'] = Variable<String>(
        $PaymentsTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['payment_date'] = Variable<DateTime>(paymentDate);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      billId: Value(billId),
      amount: Value(amount),
      paymentMode: Value(paymentMode),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      paymentDate: Value(paymentDate),
    );
  }

  factory PaymentEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentEntity(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<int>(json['billId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMode: $PaymentsTable.$converterpaymentMode.fromJson(
        serializer.fromJson<String>(json['paymentMode']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<int>(billId),
      'amount': serializer.toJson<double>(amount),
      'paymentMode': serializer.toJson<String>(
        $PaymentsTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'notes': serializer.toJson<String?>(notes),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
    };
  }

  PaymentEntity copyWith({
    int? id,
    int? billId,
    double? amount,
    PaymentMode? paymentMode,
    Value<String?> notes = const Value.absent(),
    DateTime? paymentDate,
  }) => PaymentEntity(
    id: id ?? this.id,
    billId: billId ?? this.billId,
    amount: amount ?? this.amount,
    paymentMode: paymentMode ?? this.paymentMode,
    notes: notes.present ? notes.value : this.notes,
    paymentDate: paymentDate ?? this.paymentDate,
  );
  PaymentEntity copyWithCompanion(PaymentsCompanion data) {
    return PaymentEntity(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      notes: data.notes.present ? data.notes.value : this.notes,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentEntity(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('paymentDate: $paymentDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, billId, amount, paymentMode, notes, paymentDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentEntity &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.amount == this.amount &&
          other.paymentMode == this.paymentMode &&
          other.notes == this.notes &&
          other.paymentDate == this.paymentDate);
}

class PaymentsCompanion extends UpdateCompanion<PaymentEntity> {
  final Value<int> id;
  final Value<int> billId;
  final Value<double> amount;
  final Value<PaymentMode> paymentMode;
  final Value<String?> notes;
  final Value<DateTime> paymentDate;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.paymentDate = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int billId,
    required double amount,
    required PaymentMode paymentMode,
    this.notes = const Value.absent(),
    this.paymentDate = const Value.absent(),
  }) : billId = Value(billId),
       amount = Value(amount),
       paymentMode = Value(paymentMode);
  static Insertable<PaymentEntity> custom({
    Expression<int>? id,
    Expression<int>? billId,
    Expression<double>? amount,
    Expression<String>? paymentMode,
    Expression<String>? notes,
    Expression<DateTime>? paymentDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (amount != null) 'amount': amount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (notes != null) 'notes': notes,
      if (paymentDate != null) 'payment_date': paymentDate,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? billId,
    Value<double>? amount,
    Value<PaymentMode>? paymentMode,
    Value<String?>? notes,
    Value<DateTime>? paymentDate,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(
        $PaymentsTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('paymentDate: $paymentDate')
          ..write(')'))
        .toString();
  }
}

class $ElectricityRatesTable extends ElectricityRates
    with TableInfo<$ElectricityRatesTable, ElectricityRateEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ElectricityRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ratePerUnitMeta = const VerificationMeta(
    'ratePerUnit',
  );
  @override
  late final GeneratedColumn<double> ratePerUnit = GeneratedColumn<double>(
    'rate_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [id, ratePerUnit, effectiveFrom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'electricity_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ElectricityRateEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('rate_per_unit')) {
      context.handle(
        _ratePerUnitMeta,
        ratePerUnit.isAcceptableOrUnknown(
          data['rate_per_unit']!,
          _ratePerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratePerUnitMeta);
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ElectricityRateEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ElectricityRateEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ratePerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate_per_unit'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_from'],
      )!,
    );
  }

  @override
  $ElectricityRatesTable createAlias(String alias) {
    return $ElectricityRatesTable(attachedDatabase, alias);
  }
}

class ElectricityRateEntity extends DataClass
    implements Insertable<ElectricityRateEntity> {
  /// Primary key
  final int id;

  /// Rate per unit
  final double ratePerUnit;

  /// When this rate became effective
  final DateTime effectiveFrom;
  const ElectricityRateEntity({
    required this.id,
    required this.ratePerUnit,
    required this.effectiveFrom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['rate_per_unit'] = Variable<double>(ratePerUnit);
    map['effective_from'] = Variable<DateTime>(effectiveFrom);
    return map;
  }

  ElectricityRatesCompanion toCompanion(bool nullToAbsent) {
    return ElectricityRatesCompanion(
      id: Value(id),
      ratePerUnit: Value(ratePerUnit),
      effectiveFrom: Value(effectiveFrom),
    );
  }

  factory ElectricityRateEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ElectricityRateEntity(
      id: serializer.fromJson<int>(json['id']),
      ratePerUnit: serializer.fromJson<double>(json['ratePerUnit']),
      effectiveFrom: serializer.fromJson<DateTime>(json['effectiveFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ratePerUnit': serializer.toJson<double>(ratePerUnit),
      'effectiveFrom': serializer.toJson<DateTime>(effectiveFrom),
    };
  }

  ElectricityRateEntity copyWith({
    int? id,
    double? ratePerUnit,
    DateTime? effectiveFrom,
  }) => ElectricityRateEntity(
    id: id ?? this.id,
    ratePerUnit: ratePerUnit ?? this.ratePerUnit,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
  );
  ElectricityRateEntity copyWithCompanion(ElectricityRatesCompanion data) {
    return ElectricityRateEntity(
      id: data.id.present ? data.id.value : this.id,
      ratePerUnit: data.ratePerUnit.present
          ? data.ratePerUnit.value
          : this.ratePerUnit,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityRateEntity(')
          ..write('id: $id, ')
          ..write('ratePerUnit: $ratePerUnit, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ratePerUnit, effectiveFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ElectricityRateEntity &&
          other.id == this.id &&
          other.ratePerUnit == this.ratePerUnit &&
          other.effectiveFrom == this.effectiveFrom);
}

class ElectricityRatesCompanion extends UpdateCompanion<ElectricityRateEntity> {
  final Value<int> id;
  final Value<double> ratePerUnit;
  final Value<DateTime> effectiveFrom;
  const ElectricityRatesCompanion({
    this.id = const Value.absent(),
    this.ratePerUnit = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
  });
  ElectricityRatesCompanion.insert({
    this.id = const Value.absent(),
    required double ratePerUnit,
    required DateTime effectiveFrom,
  }) : ratePerUnit = Value(ratePerUnit),
       effectiveFrom = Value(effectiveFrom);
  static Insertable<ElectricityRateEntity> custom({
    Expression<int>? id,
    Expression<double>? ratePerUnit,
    Expression<DateTime>? effectiveFrom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ratePerUnit != null) 'rate_per_unit': ratePerUnit,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
    });
  }

  ElectricityRatesCompanion copyWith({
    Value<int>? id,
    Value<double>? ratePerUnit,
    Value<DateTime>? effectiveFrom,
  }) {
    return ElectricityRatesCompanion(
      id: id ?? this.id,
      ratePerUnit: ratePerUnit ?? this.ratePerUnit,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ratePerUnit.present) {
      map['rate_per_unit'] = Variable<double>(ratePerUnit.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ElectricityRatesCompanion(')
          ..write('id: $id, ')
          ..write('ratePerUnit: $ratePerUnit, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTable extends FamilyMembers
    with TableInfo<$FamilyMembersTable, FamilyMemberEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tenantIdMeta = const VerificationMeta(
    'tenantId',
  );
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
    'tenant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tenants (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FamilyRelationship, String>
  relationship =
      GeneratedColumn<String>(
        'relationship',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FamilyRelationship>(
        $FamilyMembersTable.$converterrelationship,
      );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aadharNumberMeta = const VerificationMeta(
    'aadharNumber',
  );
  @override
  late final GeneratedColumn<String> aadharNumber = GeneratedColumn<String>(
    'aadhar_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tenantId,
    name,
    relationship,
    phone,
    aadharNumber,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMemberEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(
        _tenantIdMeta,
        tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('aadhar_number')) {
      context.handle(
        _aadharNumberMeta,
        aadharNumber.isAcceptableOrUnknown(
          data['aadhar_number']!,
          _aadharNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMemberEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMemberEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tenantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tenant_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relationship: $FamilyMembersTable.$converterrelationship.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}relationship'],
        )!,
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      aadharNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aadhar_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FamilyMembersTable createAlias(String alias) {
    return $FamilyMembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FamilyRelationship, String, String>
  $converterrelationship = const EnumNameConverter<FamilyRelationship>(
    FamilyRelationship.values,
  );
}

class FamilyMemberEntity extends DataClass
    implements Insertable<FamilyMemberEntity> {
  /// Primary key
  final int id;

  /// Foreign key to tenant
  final int tenantId;

  /// Family member's name
  final String name;

  /// Relationship to tenant
  final FamilyRelationship relationship;

  /// Phone number (optional)
  final String? phone;

  /// Aadhar number (optional)
  final String? aadharNumber;

  /// Created timestamp
  final DateTime createdAt;
  const FamilyMemberEntity({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.relationship,
    this.phone,
    this.aadharNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['name'] = Variable<String>(name);
    {
      map['relationship'] = Variable<String>(
        $FamilyMembersTable.$converterrelationship.toSql(relationship),
      );
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || aadharNumber != null) {
      map['aadhar_number'] = Variable<String>(aadharNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FamilyMembersCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      name: Value(name),
      relationship: Value(relationship),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      aadharNumber: aadharNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(aadharNumber),
      createdAt: Value(createdAt),
    );
  }

  factory FamilyMemberEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMemberEntity(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      relationship: $FamilyMembersTable.$converterrelationship.fromJson(
        serializer.fromJson<String>(json['relationship']),
      ),
      phone: serializer.fromJson<String?>(json['phone']),
      aadharNumber: serializer.fromJson<String?>(json['aadharNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'name': serializer.toJson<String>(name),
      'relationship': serializer.toJson<String>(
        $FamilyMembersTable.$converterrelationship.toJson(relationship),
      ),
      'phone': serializer.toJson<String?>(phone),
      'aadharNumber': serializer.toJson<String?>(aadharNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FamilyMemberEntity copyWith({
    int? id,
    int? tenantId,
    String? name,
    FamilyRelationship? relationship,
    Value<String?> phone = const Value.absent(),
    Value<String?> aadharNumber = const Value.absent(),
    DateTime? createdAt,
  }) => FamilyMemberEntity(
    id: id ?? this.id,
    tenantId: tenantId ?? this.tenantId,
    name: name ?? this.name,
    relationship: relationship ?? this.relationship,
    phone: phone.present ? phone.value : this.phone,
    aadharNumber: aadharNumber.present ? aadharNumber.value : this.aadharNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  FamilyMemberEntity copyWithCompanion(FamilyMembersCompanion data) {
    return FamilyMemberEntity(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      phone: data.phone.present ? data.phone.value : this.phone,
      aadharNumber: data.aadharNumber.present
          ? data.aadharNumber.value
          : this.aadharNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMemberEntity(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('phone: $phone, ')
          ..write('aadharNumber: $aadharNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tenantId,
    name,
    relationship,
    phone,
    aadharNumber,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMemberEntity &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.relationship == this.relationship &&
          other.phone == this.phone &&
          other.aadharNumber == this.aadharNumber &&
          other.createdAt == this.createdAt);
}

class FamilyMembersCompanion extends UpdateCompanion<FamilyMemberEntity> {
  final Value<int> id;
  final Value<int> tenantId;
  final Value<String> name;
  final Value<FamilyRelationship> relationship;
  final Value<String?> phone;
  final Value<String?> aadharNumber;
  final Value<DateTime> createdAt;
  const FamilyMembersCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.relationship = const Value.absent(),
    this.phone = const Value.absent(),
    this.aadharNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FamilyMembersCompanion.insert({
    this.id = const Value.absent(),
    required int tenantId,
    required String name,
    required FamilyRelationship relationship,
    this.phone = const Value.absent(),
    this.aadharNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : tenantId = Value(tenantId),
       name = Value(name),
       relationship = Value(relationship);
  static Insertable<FamilyMemberEntity> custom({
    Expression<int>? id,
    Expression<int>? tenantId,
    Expression<String>? name,
    Expression<String>? relationship,
    Expression<String>? phone,
    Expression<String>? aadharNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (relationship != null) 'relationship': relationship,
      if (phone != null) 'phone': phone,
      if (aadharNumber != null) 'aadhar_number': aadharNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FamilyMembersCompanion copyWith({
    Value<int>? id,
    Value<int>? tenantId,
    Value<String>? name,
    Value<FamilyRelationship>? relationship,
    Value<String?>? phone,
    Value<String?>? aadharNumber,
    Value<DateTime>? createdAt,
  }) {
    return FamilyMembersCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(
        $FamilyMembersTable.$converterrelationship.toSql(relationship.value),
      );
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (aadharNumber.present) {
      map['aadhar_number'] = Variable<String>(aadharNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('phone: $phone, ')
          ..write('aadharNumber: $aadharNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DepositTransactionsTable extends DepositTransactions
    with TableInfo<$DepositTransactionsTable, DepositTransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _occupancyIdMeta = const VerificationMeta(
    'occupancyId',
  );
  @override
  late final GeneratedColumn<int> occupancyId = GeneratedColumn<int>(
    'occupancy_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES occupancies (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DepositTransactionType, String>
  transactionType =
      GeneratedColumn<String>(
        'transaction_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DepositTransactionType>(
        $DepositTransactionsTable.$convertertransactionType,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occupancyId,
    transactionType,
    amount,
    transactionDate,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deposit_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DepositTransactionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occupancy_id')) {
      context.handle(
        _occupancyIdMeta,
        occupancyId.isAcceptableOrUnknown(
          data['occupancy_id']!,
          _occupancyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occupancyIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DepositTransactionEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DepositTransactionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occupancyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occupancy_id'],
      )!,
      transactionType: $DepositTransactionsTable.$convertertransactionType
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}transaction_type'],
            )!,
          ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DepositTransactionsTable createAlias(String alias) {
    return $DepositTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DepositTransactionType, String, String>
  $convertertransactionType = const EnumNameConverter<DepositTransactionType>(
    DepositTransactionType.values,
  );
}

class DepositTransactionEntity extends DataClass
    implements Insertable<DepositTransactionEntity> {
  /// Primary key
  final int id;

  /// Foreign key to occupancy
  final int occupancyId;

  /// Type of transaction
  final DepositTransactionType transactionType;

  /// Transaction amount
  final double amount;

  /// Transaction date
  final DateTime transactionDate;

  /// Notes/reason for transaction
  final String? notes;

  /// Created timestamp
  final DateTime createdAt;
  const DepositTransactionEntity({
    required this.id,
    required this.occupancyId,
    required this.transactionType,
    required this.amount,
    required this.transactionDate,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occupancy_id'] = Variable<int>(occupancyId);
    {
      map['transaction_type'] = Variable<String>(
        $DepositTransactionsTable.$convertertransactionType.toSql(
          transactionType,
        ),
      );
    }
    map['amount'] = Variable<double>(amount);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DepositTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DepositTransactionsCompanion(
      id: Value(id),
      occupancyId: Value(occupancyId),
      transactionType: Value(transactionType),
      amount: Value(amount),
      transactionDate: Value(transactionDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory DepositTransactionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DepositTransactionEntity(
      id: serializer.fromJson<int>(json['id']),
      occupancyId: serializer.fromJson<int>(json['occupancyId']),
      transactionType: $DepositTransactionsTable.$convertertransactionType
          .fromJson(serializer.fromJson<String>(json['transactionType'])),
      amount: serializer.fromJson<double>(json['amount']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occupancyId': serializer.toJson<int>(occupancyId),
      'transactionType': serializer.toJson<String>(
        $DepositTransactionsTable.$convertertransactionType.toJson(
          transactionType,
        ),
      ),
      'amount': serializer.toJson<double>(amount),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DepositTransactionEntity copyWith({
    int? id,
    int? occupancyId,
    DepositTransactionType? transactionType,
    double? amount,
    DateTime? transactionDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => DepositTransactionEntity(
    id: id ?? this.id,
    occupancyId: occupancyId ?? this.occupancyId,
    transactionType: transactionType ?? this.transactionType,
    amount: amount ?? this.amount,
    transactionDate: transactionDate ?? this.transactionDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  DepositTransactionEntity copyWithCompanion(
    DepositTransactionsCompanion data,
  ) {
    return DepositTransactionEntity(
      id: data.id.present ? data.id.value : this.id,
      occupancyId: data.occupancyId.present
          ? data.occupancyId.value
          : this.occupancyId,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DepositTransactionEntity(')
          ..write('id: $id, ')
          ..write('occupancyId: $occupancyId, ')
          ..write('transactionType: $transactionType, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occupancyId,
    transactionType,
    amount,
    transactionDate,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DepositTransactionEntity &&
          other.id == this.id &&
          other.occupancyId == this.occupancyId &&
          other.transactionType == this.transactionType &&
          other.amount == this.amount &&
          other.transactionDate == this.transactionDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class DepositTransactionsCompanion
    extends UpdateCompanion<DepositTransactionEntity> {
  final Value<int> id;
  final Value<int> occupancyId;
  final Value<DepositTransactionType> transactionType;
  final Value<double> amount;
  final Value<DateTime> transactionDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const DepositTransactionsCompanion({
    this.id = const Value.absent(),
    this.occupancyId = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DepositTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required int occupancyId,
    required DepositTransactionType transactionType,
    required double amount,
    required DateTime transactionDate,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : occupancyId = Value(occupancyId),
       transactionType = Value(transactionType),
       amount = Value(amount),
       transactionDate = Value(transactionDate);
  static Insertable<DepositTransactionEntity> custom({
    Expression<int>? id,
    Expression<int>? occupancyId,
    Expression<String>? transactionType,
    Expression<double>? amount,
    Expression<DateTime>? transactionDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occupancyId != null) 'occupancy_id': occupancyId,
      if (transactionType != null) 'transaction_type': transactionType,
      if (amount != null) 'amount': amount,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DepositTransactionsCompanion copyWith({
    Value<int>? id,
    Value<int>? occupancyId,
    Value<DepositTransactionType>? transactionType,
    Value<double>? amount,
    Value<DateTime>? transactionDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return DepositTransactionsCompanion(
      id: id ?? this.id,
      occupancyId: occupancyId ?? this.occupancyId,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occupancyId.present) {
      map['occupancy_id'] = Variable<int>(occupancyId.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(
        $DepositTransactionsTable.$convertertransactionType.toSql(
          transactionType.value,
        ),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('occupancyId: $occupancyId, ')
          ..write('transactionType: $transactionType, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MeterPhotosTable extends MeterPhotos
    with TableInfo<$MeterPhotosTable, MeterPhotoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _billIdMeta = const VerificationMeta('billId');
  @override
  late final GeneratedColumn<int> billId = GeneratedColumn<int>(
    'bill_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES bills (id)',
    ),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoOrderMeta = const VerificationMeta(
    'photoOrder',
  );
  @override
  late final GeneratedColumn<int> photoOrder = GeneratedColumn<int>(
    'photo_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    billId,
    photoPath,
    photoOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeterPhotoEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_id')) {
      context.handle(
        _billIdMeta,
        billId.isAcceptableOrUnknown(data['bill_id']!, _billIdMeta),
      );
    } else if (isInserting) {
      context.missing(_billIdMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('photo_order')) {
      context.handle(
        _photoOrderMeta,
        photoOrder.isAcceptableOrUnknown(data['photo_order']!, _photoOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeterPhotoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterPhotoEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      billId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bill_id'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      photoOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}photo_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MeterPhotosTable createAlias(String alias) {
    return $MeterPhotosTable(attachedDatabase, alias);
  }
}

class MeterPhotoEntity extends DataClass
    implements Insertable<MeterPhotoEntity> {
  /// Primary key
  final int id;

  /// Foreign key to bill
  final int billId;

  /// Local file path to photo
  final String photoPath;

  /// Photo order (1 or 2)
  final int photoOrder;

  /// Created timestamp
  final DateTime createdAt;
  const MeterPhotoEntity({
    required this.id,
    required this.billId,
    required this.photoPath,
    required this.photoOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_id'] = Variable<int>(billId);
    map['photo_path'] = Variable<String>(photoPath);
    map['photo_order'] = Variable<int>(photoOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MeterPhotosCompanion toCompanion(bool nullToAbsent) {
    return MeterPhotosCompanion(
      id: Value(id),
      billId: Value(billId),
      photoPath: Value(photoPath),
      photoOrder: Value(photoOrder),
      createdAt: Value(createdAt),
    );
  }

  factory MeterPhotoEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterPhotoEntity(
      id: serializer.fromJson<int>(json['id']),
      billId: serializer.fromJson<int>(json['billId']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      photoOrder: serializer.fromJson<int>(json['photoOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billId': serializer.toJson<int>(billId),
      'photoPath': serializer.toJson<String>(photoPath),
      'photoOrder': serializer.toJson<int>(photoOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MeterPhotoEntity copyWith({
    int? id,
    int? billId,
    String? photoPath,
    int? photoOrder,
    DateTime? createdAt,
  }) => MeterPhotoEntity(
    id: id ?? this.id,
    billId: billId ?? this.billId,
    photoPath: photoPath ?? this.photoPath,
    photoOrder: photoOrder ?? this.photoOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  MeterPhotoEntity copyWithCompanion(MeterPhotosCompanion data) {
    return MeterPhotoEntity(
      id: data.id.present ? data.id.value : this.id,
      billId: data.billId.present ? data.billId.value : this.billId,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      photoOrder: data.photoOrder.present
          ? data.photoOrder.value
          : this.photoOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterPhotoEntity(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoOrder: $photoOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, billId, photoPath, photoOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeterPhotoEntity &&
          other.id == this.id &&
          other.billId == this.billId &&
          other.photoPath == this.photoPath &&
          other.photoOrder == this.photoOrder &&
          other.createdAt == this.createdAt);
}

class MeterPhotosCompanion extends UpdateCompanion<MeterPhotoEntity> {
  final Value<int> id;
  final Value<int> billId;
  final Value<String> photoPath;
  final Value<int> photoOrder;
  final Value<DateTime> createdAt;
  const MeterPhotosCompanion({
    this.id = const Value.absent(),
    this.billId = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.photoOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MeterPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int billId,
    required String photoPath,
    this.photoOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : billId = Value(billId),
       photoPath = Value(photoPath);
  static Insertable<MeterPhotoEntity> custom({
    Expression<int>? id,
    Expression<int>? billId,
    Expression<String>? photoPath,
    Expression<int>? photoOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billId != null) 'bill_id': billId,
      if (photoPath != null) 'photo_path': photoPath,
      if (photoOrder != null) 'photo_order': photoOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MeterPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? billId,
    Value<String>? photoPath,
    Value<int>? photoOrder,
    Value<DateTime>? createdAt,
  }) {
    return MeterPhotosCompanion(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      photoPath: photoPath ?? this.photoPath,
      photoOrder: photoOrder ?? this.photoOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billId.present) {
      map['bill_id'] = Variable<int>(billId.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (photoOrder.present) {
      map['photo_order'] = Variable<int>(photoOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterPhotosCompanion(')
          ..write('id: $id, ')
          ..write('billId: $billId, ')
          ..write('photoPath: $photoPath, ')
          ..write('photoOrder: $photoOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AutoBillSettingsTable extends AutoBillSettings
    with TableInfo<$AutoBillSettingsTable, AutoBillSettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AutoBillSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<int> roomId = GeneratedColumn<int>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rooms (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generateRentMeta = const VerificationMeta(
    'generateRent',
  );
  @override
  late final GeneratedColumn<bool> generateRent = GeneratedColumn<bool>(
    'generate_rent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("generate_rent" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _generateElectricityMeta =
      const VerificationMeta('generateElectricity');
  @override
  late final GeneratedColumn<bool> generateElectricity = GeneratedColumn<bool>(
    'generate_electricity',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("generate_electricity" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generationDayMeta = const VerificationMeta(
    'generationDay',
  );
  @override
  late final GeneratedColumn<int> generationDay = GeneratedColumn<int>(
    'generation_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dueDayOffsetMeta = const VerificationMeta(
    'dueDayOffset',
  );
  @override
  late final GeneratedColumn<int> dueDayOffset = GeneratedColumn<int>(
    'due_day_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _lastGeneratedAtMeta = const VerificationMeta(
    'lastGeneratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastGeneratedAt =
      GeneratedColumn<DateTime>(
        'last_generated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    enabled,
    generateRent,
    generateElectricity,
    generationDay,
    dueDayOffset,
    lastGeneratedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auto_bill_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AutoBillSettingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('generate_rent')) {
      context.handle(
        _generateRentMeta,
        generateRent.isAcceptableOrUnknown(
          data['generate_rent']!,
          _generateRentMeta,
        ),
      );
    }
    if (data.containsKey('generate_electricity')) {
      context.handle(
        _generateElectricityMeta,
        generateElectricity.isAcceptableOrUnknown(
          data['generate_electricity']!,
          _generateElectricityMeta,
        ),
      );
    }
    if (data.containsKey('generation_day')) {
      context.handle(
        _generationDayMeta,
        generationDay.isAcceptableOrUnknown(
          data['generation_day']!,
          _generationDayMeta,
        ),
      );
    }
    if (data.containsKey('due_day_offset')) {
      context.handle(
        _dueDayOffsetMeta,
        dueDayOffset.isAcceptableOrUnknown(
          data['due_day_offset']!,
          _dueDayOffsetMeta,
        ),
      );
    }
    if (data.containsKey('last_generated_at')) {
      context.handle(
        _lastGeneratedAtMeta,
        lastGeneratedAt.isAcceptableOrUnknown(
          data['last_generated_at']!,
          _lastGeneratedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AutoBillSettingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AutoBillSettingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}room_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      generateRent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}generate_rent'],
      )!,
      generateElectricity: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}generate_electricity'],
      )!,
      generationDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generation_day'],
      )!,
      dueDayOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day_offset'],
      )!,
      lastGeneratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_generated_at'],
      ),
    );
  }

  @override
  $AutoBillSettingsTable createAlias(String alias) {
    return $AutoBillSettingsTable(attachedDatabase, alias);
  }
}

class AutoBillSettingEntity extends DataClass
    implements Insertable<AutoBillSettingEntity> {
  /// Primary key
  final int id;

  /// Foreign key to room
  final int roomId;

  /// Whether auto-billing is enabled
  final bool enabled;

  /// Generate rent bills automatically
  final bool generateRent;

  /// Generate electricity bills automatically
  final bool generateElectricity;

  /// Day of month to generate bills (1-28)
  final int generationDay;

  /// Number of days after generation for due date
  final int dueDayOffset;

  /// Last date bills were generated
  final DateTime? lastGeneratedAt;
  const AutoBillSettingEntity({
    required this.id,
    required this.roomId,
    required this.enabled,
    required this.generateRent,
    required this.generateElectricity,
    required this.generationDay,
    required this.dueDayOffset,
    this.lastGeneratedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['room_id'] = Variable<int>(roomId);
    map['enabled'] = Variable<bool>(enabled);
    map['generate_rent'] = Variable<bool>(generateRent);
    map['generate_electricity'] = Variable<bool>(generateElectricity);
    map['generation_day'] = Variable<int>(generationDay);
    map['due_day_offset'] = Variable<int>(dueDayOffset);
    if (!nullToAbsent || lastGeneratedAt != null) {
      map['last_generated_at'] = Variable<DateTime>(lastGeneratedAt);
    }
    return map;
  }

  AutoBillSettingsCompanion toCompanion(bool nullToAbsent) {
    return AutoBillSettingsCompanion(
      id: Value(id),
      roomId: Value(roomId),
      enabled: Value(enabled),
      generateRent: Value(generateRent),
      generateElectricity: Value(generateElectricity),
      generationDay: Value(generationDay),
      dueDayOffset: Value(dueDayOffset),
      lastGeneratedAt: lastGeneratedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGeneratedAt),
    );
  }

  factory AutoBillSettingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AutoBillSettingEntity(
      id: serializer.fromJson<int>(json['id']),
      roomId: serializer.fromJson<int>(json['roomId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      generateRent: serializer.fromJson<bool>(json['generateRent']),
      generateElectricity: serializer.fromJson<bool>(
        json['generateElectricity'],
      ),
      generationDay: serializer.fromJson<int>(json['generationDay']),
      dueDayOffset: serializer.fromJson<int>(json['dueDayOffset']),
      lastGeneratedAt: serializer.fromJson<DateTime?>(json['lastGeneratedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'roomId': serializer.toJson<int>(roomId),
      'enabled': serializer.toJson<bool>(enabled),
      'generateRent': serializer.toJson<bool>(generateRent),
      'generateElectricity': serializer.toJson<bool>(generateElectricity),
      'generationDay': serializer.toJson<int>(generationDay),
      'dueDayOffset': serializer.toJson<int>(dueDayOffset),
      'lastGeneratedAt': serializer.toJson<DateTime?>(lastGeneratedAt),
    };
  }

  AutoBillSettingEntity copyWith({
    int? id,
    int? roomId,
    bool? enabled,
    bool? generateRent,
    bool? generateElectricity,
    int? generationDay,
    int? dueDayOffset,
    Value<DateTime?> lastGeneratedAt = const Value.absent(),
  }) => AutoBillSettingEntity(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    enabled: enabled ?? this.enabled,
    generateRent: generateRent ?? this.generateRent,
    generateElectricity: generateElectricity ?? this.generateElectricity,
    generationDay: generationDay ?? this.generationDay,
    dueDayOffset: dueDayOffset ?? this.dueDayOffset,
    lastGeneratedAt: lastGeneratedAt.present
        ? lastGeneratedAt.value
        : this.lastGeneratedAt,
  );
  AutoBillSettingEntity copyWithCompanion(AutoBillSettingsCompanion data) {
    return AutoBillSettingEntity(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      generateRent: data.generateRent.present
          ? data.generateRent.value
          : this.generateRent,
      generateElectricity: data.generateElectricity.present
          ? data.generateElectricity.value
          : this.generateElectricity,
      generationDay: data.generationDay.present
          ? data.generationDay.value
          : this.generationDay,
      dueDayOffset: data.dueDayOffset.present
          ? data.dueDayOffset.value
          : this.dueDayOffset,
      lastGeneratedAt: data.lastGeneratedAt.present
          ? data.lastGeneratedAt.value
          : this.lastGeneratedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AutoBillSettingEntity(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('enabled: $enabled, ')
          ..write('generateRent: $generateRent, ')
          ..write('generateElectricity: $generateElectricity, ')
          ..write('generationDay: $generationDay, ')
          ..write('dueDayOffset: $dueDayOffset, ')
          ..write('lastGeneratedAt: $lastGeneratedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomId,
    enabled,
    generateRent,
    generateElectricity,
    generationDay,
    dueDayOffset,
    lastGeneratedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AutoBillSettingEntity &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.enabled == this.enabled &&
          other.generateRent == this.generateRent &&
          other.generateElectricity == this.generateElectricity &&
          other.generationDay == this.generationDay &&
          other.dueDayOffset == this.dueDayOffset &&
          other.lastGeneratedAt == this.lastGeneratedAt);
}

class AutoBillSettingsCompanion extends UpdateCompanion<AutoBillSettingEntity> {
  final Value<int> id;
  final Value<int> roomId;
  final Value<bool> enabled;
  final Value<bool> generateRent;
  final Value<bool> generateElectricity;
  final Value<int> generationDay;
  final Value<int> dueDayOffset;
  final Value<DateTime?> lastGeneratedAt;
  const AutoBillSettingsCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.generateRent = const Value.absent(),
    this.generateElectricity = const Value.absent(),
    this.generationDay = const Value.absent(),
    this.dueDayOffset = const Value.absent(),
    this.lastGeneratedAt = const Value.absent(),
  });
  AutoBillSettingsCompanion.insert({
    this.id = const Value.absent(),
    required int roomId,
    this.enabled = const Value.absent(),
    this.generateRent = const Value.absent(),
    this.generateElectricity = const Value.absent(),
    this.generationDay = const Value.absent(),
    this.dueDayOffset = const Value.absent(),
    this.lastGeneratedAt = const Value.absent(),
  }) : roomId = Value(roomId);
  static Insertable<AutoBillSettingEntity> custom({
    Expression<int>? id,
    Expression<int>? roomId,
    Expression<bool>? enabled,
    Expression<bool>? generateRent,
    Expression<bool>? generateElectricity,
    Expression<int>? generationDay,
    Expression<int>? dueDayOffset,
    Expression<DateTime>? lastGeneratedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (enabled != null) 'enabled': enabled,
      if (generateRent != null) 'generate_rent': generateRent,
      if (generateElectricity != null)
        'generate_electricity': generateElectricity,
      if (generationDay != null) 'generation_day': generationDay,
      if (dueDayOffset != null) 'due_day_offset': dueDayOffset,
      if (lastGeneratedAt != null) 'last_generated_at': lastGeneratedAt,
    });
  }

  AutoBillSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? roomId,
    Value<bool>? enabled,
    Value<bool>? generateRent,
    Value<bool>? generateElectricity,
    Value<int>? generationDay,
    Value<int>? dueDayOffset,
    Value<DateTime?>? lastGeneratedAt,
  }) {
    return AutoBillSettingsCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      enabled: enabled ?? this.enabled,
      generateRent: generateRent ?? this.generateRent,
      generateElectricity: generateElectricity ?? this.generateElectricity,
      generationDay: generationDay ?? this.generationDay,
      dueDayOffset: dueDayOffset ?? this.dueDayOffset,
      lastGeneratedAt: lastGeneratedAt ?? this.lastGeneratedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<int>(roomId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (generateRent.present) {
      map['generate_rent'] = Variable<bool>(generateRent.value);
    }
    if (generateElectricity.present) {
      map['generate_electricity'] = Variable<bool>(generateElectricity.value);
    }
    if (generationDay.present) {
      map['generation_day'] = Variable<int>(generationDay.value);
    }
    if (dueDayOffset.present) {
      map['due_day_offset'] = Variable<int>(dueDayOffset.value);
    }
    if (lastGeneratedAt.present) {
      map['last_generated_at'] = Variable<DateTime>(lastGeneratedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AutoBillSettingsCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('enabled: $enabled, ')
          ..write('generateRent: $generateRent, ')
          ..write('generateElectricity: $generateElectricity, ')
          ..write('generationDay: $generationDay, ')
          ..write('dueDayOffset: $dueDayOffset, ')
          ..write('lastGeneratedAt: $lastGeneratedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationSettingsTable extends NotificationSettings
    with TableInfo<$NotificationSettingsTable, NotificationSettingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NotificationType, String>
  notificationType =
      GeneratedColumn<String>(
        'notification_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NotificationType>(
        $NotificationSettingsTable.$converternotificationType,
      );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _daysBeforeMeta = const VerificationMeta(
    'daysBefore',
  );
  @override
  late final GeneratedColumn<int> daysBefore = GeneratedColumn<int>(
    'days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _quietHoursStartMeta = const VerificationMeta(
    'quietHoursStart',
  );
  @override
  late final GeneratedColumn<int> quietHoursStart = GeneratedColumn<int>(
    'quiet_hours_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quietHoursEndMeta = const VerificationMeta(
    'quietHoursEnd',
  );
  @override
  late final GeneratedColumn<int> quietHoursEnd = GeneratedColumn<int>(
    'quiet_hours_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notificationType,
    enabled,
    daysBefore,
    quietHoursStart,
    quietHoursEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationSettingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('days_before')) {
      context.handle(
        _daysBeforeMeta,
        daysBefore.isAcceptableOrUnknown(data['days_before']!, _daysBeforeMeta),
      );
    }
    if (data.containsKey('quiet_hours_start')) {
      context.handle(
        _quietHoursStartMeta,
        quietHoursStart.isAcceptableOrUnknown(
          data['quiet_hours_start']!,
          _quietHoursStartMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_end')) {
      context.handle(
        _quietHoursEndMeta,
        quietHoursEnd.isAcceptableOrUnknown(
          data['quiet_hours_end']!,
          _quietHoursEndMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationSettingEntity map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSettingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notificationType: $NotificationSettingsTable.$converternotificationType
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}notification_type'],
            )!,
          ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      daysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_before'],
      )!,
      quietHoursStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_start'],
      ),
      quietHoursEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_end'],
      ),
    );
  }

  @override
  $NotificationSettingsTable createAlias(String alias) {
    return $NotificationSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationType, String, String>
  $converternotificationType = const EnumNameConverter<NotificationType>(
    NotificationType.values,
  );
}

class NotificationSettingEntity extends DataClass
    implements Insertable<NotificationSettingEntity> {
  /// Primary key
  final int id;

  /// Type of notification
  final NotificationType notificationType;

  /// Whether this notification is enabled
  final bool enabled;

  /// Days before/after to trigger (positive = before due, negative = after)
  final int daysBefore;

  /// Quiet hours start (0-23)
  final int? quietHoursStart;

  /// Quiet hours end (0-23)
  final int? quietHoursEnd;
  const NotificationSettingEntity({
    required this.id,
    required this.notificationType,
    required this.enabled,
    required this.daysBefore,
    this.quietHoursStart,
    this.quietHoursEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['notification_type'] = Variable<String>(
        $NotificationSettingsTable.$converternotificationType.toSql(
          notificationType,
        ),
      );
    }
    map['enabled'] = Variable<bool>(enabled);
    map['days_before'] = Variable<int>(daysBefore);
    if (!nullToAbsent || quietHoursStart != null) {
      map['quiet_hours_start'] = Variable<int>(quietHoursStart);
    }
    if (!nullToAbsent || quietHoursEnd != null) {
      map['quiet_hours_end'] = Variable<int>(quietHoursEnd);
    }
    return map;
  }

  NotificationSettingsCompanion toCompanion(bool nullToAbsent) {
    return NotificationSettingsCompanion(
      id: Value(id),
      notificationType: Value(notificationType),
      enabled: Value(enabled),
      daysBefore: Value(daysBefore),
      quietHoursStart: quietHoursStart == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursStart),
      quietHoursEnd: quietHoursEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursEnd),
    );
  }

  factory NotificationSettingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSettingEntity(
      id: serializer.fromJson<int>(json['id']),
      notificationType: $NotificationSettingsTable.$converternotificationType
          .fromJson(serializer.fromJson<String>(json['notificationType'])),
      enabled: serializer.fromJson<bool>(json['enabled']),
      daysBefore: serializer.fromJson<int>(json['daysBefore']),
      quietHoursStart: serializer.fromJson<int?>(json['quietHoursStart']),
      quietHoursEnd: serializer.fromJson<int?>(json['quietHoursEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notificationType': serializer.toJson<String>(
        $NotificationSettingsTable.$converternotificationType.toJson(
          notificationType,
        ),
      ),
      'enabled': serializer.toJson<bool>(enabled),
      'daysBefore': serializer.toJson<int>(daysBefore),
      'quietHoursStart': serializer.toJson<int?>(quietHoursStart),
      'quietHoursEnd': serializer.toJson<int?>(quietHoursEnd),
    };
  }

  NotificationSettingEntity copyWith({
    int? id,
    NotificationType? notificationType,
    bool? enabled,
    int? daysBefore,
    Value<int?> quietHoursStart = const Value.absent(),
    Value<int?> quietHoursEnd = const Value.absent(),
  }) => NotificationSettingEntity(
    id: id ?? this.id,
    notificationType: notificationType ?? this.notificationType,
    enabled: enabled ?? this.enabled,
    daysBefore: daysBefore ?? this.daysBefore,
    quietHoursStart: quietHoursStart.present
        ? quietHoursStart.value
        : this.quietHoursStart,
    quietHoursEnd: quietHoursEnd.present
        ? quietHoursEnd.value
        : this.quietHoursEnd,
  );
  NotificationSettingEntity copyWithCompanion(
    NotificationSettingsCompanion data,
  ) {
    return NotificationSettingEntity(
      id: data.id.present ? data.id.value : this.id,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      daysBefore: data.daysBefore.present
          ? data.daysBefore.value
          : this.daysBefore,
      quietHoursStart: data.quietHoursStart.present
          ? data.quietHoursStart.value
          : this.quietHoursStart,
      quietHoursEnd: data.quietHoursEnd.present
          ? data.quietHoursEnd.value
          : this.quietHoursEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingEntity(')
          ..write('id: $id, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled, ')
          ..write('daysBefore: $daysBefore, ')
          ..write('quietHoursStart: $quietHoursStart, ')
          ..write('quietHoursEnd: $quietHoursEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notificationType,
    enabled,
    daysBefore,
    quietHoursStart,
    quietHoursEnd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSettingEntity &&
          other.id == this.id &&
          other.notificationType == this.notificationType &&
          other.enabled == this.enabled &&
          other.daysBefore == this.daysBefore &&
          other.quietHoursStart == this.quietHoursStart &&
          other.quietHoursEnd == this.quietHoursEnd);
}

class NotificationSettingsCompanion
    extends UpdateCompanion<NotificationSettingEntity> {
  final Value<int> id;
  final Value<NotificationType> notificationType;
  final Value<bool> enabled;
  final Value<int> daysBefore;
  final Value<int?> quietHoursStart;
  final Value<int?> quietHoursEnd;
  const NotificationSettingsCompanion({
    this.id = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.enabled = const Value.absent(),
    this.daysBefore = const Value.absent(),
    this.quietHoursStart = const Value.absent(),
    this.quietHoursEnd = const Value.absent(),
  });
  NotificationSettingsCompanion.insert({
    this.id = const Value.absent(),
    required NotificationType notificationType,
    this.enabled = const Value.absent(),
    this.daysBefore = const Value.absent(),
    this.quietHoursStart = const Value.absent(),
    this.quietHoursEnd = const Value.absent(),
  }) : notificationType = Value(notificationType);
  static Insertable<NotificationSettingEntity> custom({
    Expression<int>? id,
    Expression<String>? notificationType,
    Expression<bool>? enabled,
    Expression<int>? daysBefore,
    Expression<int>? quietHoursStart,
    Expression<int>? quietHoursEnd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationType != null) 'notification_type': notificationType,
      if (enabled != null) 'enabled': enabled,
      if (daysBefore != null) 'days_before': daysBefore,
      if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
      if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
    });
  }

  NotificationSettingsCompanion copyWith({
    Value<int>? id,
    Value<NotificationType>? notificationType,
    Value<bool>? enabled,
    Value<int>? daysBefore,
    Value<int?>? quietHoursStart,
    Value<int?>? quietHoursEnd,
  }) {
    return NotificationSettingsCompanion(
      id: id ?? this.id,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
      daysBefore: daysBefore ?? this.daysBefore,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(
        $NotificationSettingsTable.$converternotificationType.toSql(
          notificationType.value,
        ),
      );
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (daysBefore.present) {
      map['days_before'] = Variable<int>(daysBefore.value);
    }
    if (quietHoursStart.present) {
      map['quiet_hours_start'] = Variable<int>(quietHoursStart.value);
    }
    if (quietHoursEnd.present) {
      map['quiet_hours_end'] = Variable<int>(quietHoursEnd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsCompanion(')
          ..write('id: $id, ')
          ..write('notificationType: $notificationType, ')
          ..write('enabled: $enabled, ')
          ..write('daysBefore: $daysBefore, ')
          ..write('quietHoursStart: $quietHoursStart, ')
          ..write('quietHoursEnd: $quietHoursEnd')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LandlordsTable landlords = $LandlordsTable(this);
  late final $PropertiesTable properties = $PropertiesTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $TenantsTable tenants = $TenantsTable(this);
  late final $CustomFieldsTable customFields = $CustomFieldsTable(this);
  late final $OccupanciesTable occupancies = $OccupanciesTable(this);
  late final $BillsTable bills = $BillsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $ElectricityRatesTable electricityRates = $ElectricityRatesTable(
    this,
  );
  late final $FamilyMembersTable familyMembers = $FamilyMembersTable(this);
  late final $DepositTransactionsTable depositTransactions =
      $DepositTransactionsTable(this);
  late final $MeterPhotosTable meterPhotos = $MeterPhotosTable(this);
  late final $AutoBillSettingsTable autoBillSettings = $AutoBillSettingsTable(
    this,
  );
  late final $NotificationSettingsTable notificationSettings =
      $NotificationSettingsTable(this);
  late final LandlordDao landlordDao = LandlordDao(this as AppDatabase);
  late final PropertyDao propertyDao = PropertyDao(this as AppDatabase);
  late final TenantDao tenantDao = TenantDao(this as AppDatabase);
  late final BillingDao billingDao = BillingDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    landlords,
    properties,
    rooms,
    tenants,
    customFields,
    occupancies,
    bills,
    payments,
    electricityRates,
    familyMembers,
    depositTransactions,
    meterPhotos,
    autoBillSettings,
    notificationSettings,
  ];
}

typedef $$LandlordsTableCreateCompanionBuilder =
    LandlordsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> upiId,
      Value<String?> phone,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$LandlordsTableUpdateCompanionBuilder =
    LandlordsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> upiId,
      Value<String?> phone,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$LandlordsTableFilterComposer
    extends Composer<_$AppDatabase, $LandlordsTable> {
  $$LandlordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LandlordsTableOrderingComposer
    extends Composer<_$AppDatabase, $LandlordsTable> {
  $$LandlordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LandlordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LandlordsTable> {
  $$LandlordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LandlordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LandlordsTable,
          LandlordEntity,
          $$LandlordsTableFilterComposer,
          $$LandlordsTableOrderingComposer,
          $$LandlordsTableAnnotationComposer,
          $$LandlordsTableCreateCompanionBuilder,
          $$LandlordsTableUpdateCompanionBuilder,
          (
            LandlordEntity,
            BaseReferences<_$AppDatabase, $LandlordsTable, LandlordEntity>,
          ),
          LandlordEntity,
          PrefetchHooks Function()
        > {
  $$LandlordsTableTableManager(_$AppDatabase db, $LandlordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LandlordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LandlordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LandlordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LandlordsCompanion(
                id: id,
                name: name,
                upiId: upiId,
                phone: phone,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> upiId = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LandlordsCompanion.insert(
                id: id,
                name: name,
                upiId: upiId,
                phone: phone,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LandlordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LandlordsTable,
      LandlordEntity,
      $$LandlordsTableFilterComposer,
      $$LandlordsTableOrderingComposer,
      $$LandlordsTableAnnotationComposer,
      $$LandlordsTableCreateCompanionBuilder,
      $$LandlordsTableUpdateCompanionBuilder,
      (
        LandlordEntity,
        BaseReferences<_$AppDatabase, $LandlordsTable, LandlordEntity>,
      ),
      LandlordEntity,
      PrefetchHooks Function()
    >;
typedef $$PropertiesTableCreateCompanionBuilder =
    PropertiesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
    });
typedef $$PropertiesTableUpdateCompanionBuilder =
    PropertiesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
    });

final class $$PropertiesTableReferences
    extends BaseReferences<_$AppDatabase, $PropertiesTable, PropertyEntity> {
  $$PropertiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoomsTable, List<RoomEntity>> _roomsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rooms,
    aliasName: $_aliasNameGenerator(db.properties.id, db.rooms.propertyId),
  );

  $$RoomsTableProcessedTableManager get roomsRefs {
    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.propertyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_roomsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PropertiesTableFilterComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> roomsRefs(
    Expression<bool> Function($$RoomsTableFilterComposer f) f,
  ) {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PropertiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PropertiesTable> {
  $$PropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> roomsRefs<T extends Object>(
    Expression<T> Function($$RoomsTableAnnotationComposer a) f,
  ) {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.propertyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PropertiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PropertiesTable,
          PropertyEntity,
          $$PropertiesTableFilterComposer,
          $$PropertiesTableOrderingComposer,
          $$PropertiesTableAnnotationComposer,
          $$PropertiesTableCreateCompanionBuilder,
          $$PropertiesTableUpdateCompanionBuilder,
          (PropertyEntity, $$PropertiesTableReferences),
          PropertyEntity,
          PrefetchHooks Function({bool roomsRefs})
        > {
  $$PropertiesTableTableManager(_$AppDatabase db, $PropertiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PropertiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PropertiesCompanion(
                id: id,
                name: name,
                address: address,
                photoPath: photoPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PropertiesCompanion.insert(
                id: id,
                name: name,
                address: address,
                photoPath: photoPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PropertiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (roomsRefs) db.rooms],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (roomsRefs)
                    await $_getPrefetchedData<
                      PropertyEntity,
                      $PropertiesTable,
                      RoomEntity
                    >(
                      currentTable: table,
                      referencedTable: $$PropertiesTableReferences
                          ._roomsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PropertiesTableReferences(db, table, p0).roomsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.propertyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PropertiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PropertiesTable,
      PropertyEntity,
      $$PropertiesTableFilterComposer,
      $$PropertiesTableOrderingComposer,
      $$PropertiesTableAnnotationComposer,
      $$PropertiesTableCreateCompanionBuilder,
      $$PropertiesTableUpdateCompanionBuilder,
      (PropertyEntity, $$PropertiesTableReferences),
      PropertyEntity,
      PrefetchHooks Function({bool roomsRefs})
    >;
typedef $$RoomsTableCreateCompanionBuilder =
    RoomsCompanion Function({
      Value<int> id,
      required int propertyId,
      required String roomNumber,
      Value<double> baseRent,
      Value<bool> hasElectricityMeter,
      Value<double> currentElectricityRate,
      Value<DateTime> createdAt,
    });
typedef $$RoomsTableUpdateCompanionBuilder =
    RoomsCompanion Function({
      Value<int> id,
      Value<int> propertyId,
      Value<String> roomNumber,
      Value<double> baseRent,
      Value<bool> hasElectricityMeter,
      Value<double> currentElectricityRate,
      Value<DateTime> createdAt,
    });

final class $$RoomsTableReferences
    extends BaseReferences<_$AppDatabase, $RoomsTable, RoomEntity> {
  $$RoomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PropertiesTable _propertyIdTable(_$AppDatabase db) => db.properties
      .createAlias($_aliasNameGenerator(db.rooms.propertyId, db.properties.id));

  $$PropertiesTableProcessedTableManager get propertyId {
    final $_column = $_itemColumn<int>('property_id')!;

    final manager = $$PropertiesTableTableManager(
      $_db,
      $_db.properties,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_propertyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OccupanciesTable, List<OccupancyEntity>>
  _occupanciesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.occupancies,
    aliasName: $_aliasNameGenerator(db.rooms.id, db.occupancies.roomId),
  );

  $$OccupanciesTableProcessedTableManager get occupanciesRefs {
    final manager = $$OccupanciesTableTableManager(
      $_db,
      $_db.occupancies,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_occupanciesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AutoBillSettingsTable,
    List<AutoBillSettingEntity>
  >
  _autoBillSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.autoBillSettings,
    aliasName: $_aliasNameGenerator(db.rooms.id, db.autoBillSettings.roomId),
  );

  $$AutoBillSettingsTableProcessedTableManager get autoBillSettingsRefs {
    final manager = $$AutoBillSettingsTableTableManager(
      $_db,
      $_db.autoBillSettings,
    ).filter((f) => f.roomId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _autoBillSettingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomNumber => $composableBuilder(
    column: $table.roomNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseRent => $composableBuilder(
    column: $table.baseRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasElectricityMeter => $composableBuilder(
    column: $table.hasElectricityMeter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentElectricityRate => $composableBuilder(
    column: $table.currentElectricityRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PropertiesTableFilterComposer get propertyId {
    final $$PropertiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableFilterComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> occupanciesRefs(
    Expression<bool> Function($$OccupanciesTableFilterComposer f) f,
  ) {
    final $$OccupanciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableFilterComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> autoBillSettingsRefs(
    Expression<bool> Function($$AutoBillSettingsTableFilterComposer f) f,
  ) {
    final $$AutoBillSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.autoBillSettings,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AutoBillSettingsTableFilterComposer(
            $db: $db,
            $table: $db.autoBillSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomNumber => $composableBuilder(
    column: $table.roomNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseRent => $composableBuilder(
    column: $table.baseRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasElectricityMeter => $composableBuilder(
    column: $table.hasElectricityMeter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentElectricityRate => $composableBuilder(
    column: $table.currentElectricityRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PropertiesTableOrderingComposer get propertyId {
    final $$PropertiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableOrderingComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roomNumber => $composableBuilder(
    column: $table.roomNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get baseRent =>
      $composableBuilder(column: $table.baseRent, builder: (column) => column);

  GeneratedColumn<bool> get hasElectricityMeter => $composableBuilder(
    column: $table.hasElectricityMeter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentElectricityRate => $composableBuilder(
    column: $table.currentElectricityRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PropertiesTableAnnotationComposer get propertyId {
    final $$PropertiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.propertyId,
      referencedTable: $db.properties,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PropertiesTableAnnotationComposer(
            $db: $db,
            $table: $db.properties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> occupanciesRefs<T extends Object>(
    Expression<T> Function($$OccupanciesTableAnnotationComposer a) f,
  ) {
    final $$OccupanciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableAnnotationComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> autoBillSettingsRefs<T extends Object>(
    Expression<T> Function($$AutoBillSettingsTableAnnotationComposer a) f,
  ) {
    final $$AutoBillSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.autoBillSettings,
      getReferencedColumn: (t) => t.roomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AutoBillSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.autoBillSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          RoomEntity,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (RoomEntity, $$RoomsTableReferences),
          RoomEntity,
          PrefetchHooks Function({
            bool propertyId,
            bool occupanciesRefs,
            bool autoBillSettingsRefs,
          })
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> propertyId = const Value.absent(),
                Value<String> roomNumber = const Value.absent(),
                Value<double> baseRent = const Value.absent(),
                Value<bool> hasElectricityMeter = const Value.absent(),
                Value<double> currentElectricityRate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoomsCompanion(
                id: id,
                propertyId: propertyId,
                roomNumber: roomNumber,
                baseRent: baseRent,
                hasElectricityMeter: hasElectricityMeter,
                currentElectricityRate: currentElectricityRate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int propertyId,
                required String roomNumber,
                Value<double> baseRent = const Value.absent(),
                Value<bool> hasElectricityMeter = const Value.absent(),
                Value<double> currentElectricityRate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoomsCompanion.insert(
                id: id,
                propertyId: propertyId,
                roomNumber: roomNumber,
                baseRent: baseRent,
                hasElectricityMeter: hasElectricityMeter,
                currentElectricityRate: currentElectricityRate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoomsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                propertyId = false,
                occupanciesRefs = false,
                autoBillSettingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (occupanciesRefs) db.occupancies,
                    if (autoBillSettingsRefs) db.autoBillSettings,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (propertyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.propertyId,
                                    referencedTable: $$RoomsTableReferences
                                        ._propertyIdTable(db),
                                    referencedColumn: $$RoomsTableReferences
                                        ._propertyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (occupanciesRefs)
                        await $_getPrefetchedData<
                          RoomEntity,
                          $RoomsTable,
                          OccupancyEntity
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._occupanciesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).occupanciesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (autoBillSettingsRefs)
                        await $_getPrefetchedData<
                          RoomEntity,
                          $RoomsTable,
                          AutoBillSettingEntity
                        >(
                          currentTable: table,
                          referencedTable: $$RoomsTableReferences
                              ._autoBillSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoomsTableReferences(
                                db,
                                table,
                                p0,
                              ).autoBillSettingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.roomId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      RoomEntity,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (RoomEntity, $$RoomsTableReferences),
      RoomEntity,
      PrefetchHooks Function({
        bool propertyId,
        bool occupanciesRefs,
        bool autoBillSettingsRefs,
      })
    >;
typedef $$TenantsTableCreateCompanionBuilder =
    TenantsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> aadharNumber,
      Value<String?> photoPath,
      Value<bool> isPoliceVerified,
      Value<String?> policeVerificationDocPath,
      Value<DateTime> createdAt,
    });
typedef $$TenantsTableUpdateCompanionBuilder =
    TenantsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> aadharNumber,
      Value<String?> photoPath,
      Value<bool> isPoliceVerified,
      Value<String?> policeVerificationDocPath,
      Value<DateTime> createdAt,
    });

final class $$TenantsTableReferences
    extends BaseReferences<_$AppDatabase, $TenantsTable, TenantEntity> {
  $$TenantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomFieldsTable, List<CustomFieldEntity>>
  _customFieldsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customFields,
    aliasName: $_aliasNameGenerator(db.tenants.id, db.customFields.tenantId),
  );

  $$CustomFieldsTableProcessedTableManager get customFieldsRefs {
    final manager = $$CustomFieldsTableTableManager(
      $_db,
      $_db.customFields,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_customFieldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OccupanciesTable, List<OccupancyEntity>>
  _occupanciesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.occupancies,
    aliasName: $_aliasNameGenerator(db.tenants.id, db.occupancies.tenantId),
  );

  $$OccupanciesTableProcessedTableManager get occupanciesRefs {
    final manager = $$OccupanciesTableTableManager(
      $_db,
      $_db.occupancies,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_occupanciesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FamilyMembersTable, List<FamilyMemberEntity>>
  _familyMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.familyMembers,
    aliasName: $_aliasNameGenerator(db.tenants.id, db.familyMembers.tenantId),
  );

  $$FamilyMembersTableProcessedTableManager get familyMembersRefs {
    final manager = $$FamilyMembersTableTableManager(
      $_db,
      $_db.familyMembers,
    ).filter((f) => f.tenantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_familyMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TenantsTableFilterComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPoliceVerified => $composableBuilder(
    column: $table.isPoliceVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get policeVerificationDocPath => $composableBuilder(
    column: $table.policeVerificationDocPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customFieldsRefs(
    Expression<bool> Function($$CustomFieldsTableFilterComposer f) f,
  ) {
    final $$CustomFieldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customFields,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldsTableFilterComposer(
            $db: $db,
            $table: $db.customFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> occupanciesRefs(
    Expression<bool> Function($$OccupanciesTableFilterComposer f) f,
  ) {
    final $$OccupanciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableFilterComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> familyMembersRefs(
    Expression<bool> Function($$FamilyMembersTableFilterComposer f) f,
  ) {
    final $$FamilyMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableFilterComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPoliceVerified => $composableBuilder(
    column: $table.isPoliceVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get policeVerificationDocPath => $composableBuilder(
    column: $table.policeVerificationDocPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TenantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantsTable> {
  $$TenantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<bool> get isPoliceVerified => $composableBuilder(
    column: $table.isPoliceVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get policeVerificationDocPath => $composableBuilder(
    column: $table.policeVerificationDocPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customFieldsRefs<T extends Object>(
    Expression<T> Function($$CustomFieldsTableAnnotationComposer a) f,
  ) {
    final $$CustomFieldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customFields,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldsTableAnnotationComposer(
            $db: $db,
            $table: $db.customFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> occupanciesRefs<T extends Object>(
    Expression<T> Function($$OccupanciesTableAnnotationComposer a) f,
  ) {
    final $$OccupanciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableAnnotationComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> familyMembersRefs<T extends Object>(
    Expression<T> Function($$FamilyMembersTableAnnotationComposer a) f,
  ) {
    final $$FamilyMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.tenantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TenantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TenantsTable,
          TenantEntity,
          $$TenantsTableFilterComposer,
          $$TenantsTableOrderingComposer,
          $$TenantsTableAnnotationComposer,
          $$TenantsTableCreateCompanionBuilder,
          $$TenantsTableUpdateCompanionBuilder,
          (TenantEntity, $$TenantsTableReferences),
          TenantEntity,
          PrefetchHooks Function({
            bool customFieldsRefs,
            bool occupanciesRefs,
            bool familyMembersRefs,
          })
        > {
  $$TenantsTableTableManager(_$AppDatabase db, $TenantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> aadharNumber = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isPoliceVerified = const Value.absent(),
                Value<String?> policeVerificationDocPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TenantsCompanion(
                id: id,
                name: name,
                phone: phone,
                aadharNumber: aadharNumber,
                photoPath: photoPath,
                isPoliceVerified: isPoliceVerified,
                policeVerificationDocPath: policeVerificationDocPath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> aadharNumber = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<bool> isPoliceVerified = const Value.absent(),
                Value<String?> policeVerificationDocPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TenantsCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                aadharNumber: aadharNumber,
                photoPath: photoPath,
                isPoliceVerified: isPoliceVerified,
                policeVerificationDocPath: policeVerificationDocPath,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TenantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customFieldsRefs = false,
                occupanciesRefs = false,
                familyMembersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customFieldsRefs) db.customFields,
                    if (occupanciesRefs) db.occupancies,
                    if (familyMembersRefs) db.familyMembers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customFieldsRefs)
                        await $_getPrefetchedData<
                          TenantEntity,
                          $TenantsTable,
                          CustomFieldEntity
                        >(
                          currentTable: table,
                          referencedTable: $$TenantsTableReferences
                              ._customFieldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TenantsTableReferences(
                                db,
                                table,
                                p0,
                              ).customFieldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tenantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (occupanciesRefs)
                        await $_getPrefetchedData<
                          TenantEntity,
                          $TenantsTable,
                          OccupancyEntity
                        >(
                          currentTable: table,
                          referencedTable: $$TenantsTableReferences
                              ._occupanciesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TenantsTableReferences(
                                db,
                                table,
                                p0,
                              ).occupanciesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tenantId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (familyMembersRefs)
                        await $_getPrefetchedData<
                          TenantEntity,
                          $TenantsTable,
                          FamilyMemberEntity
                        >(
                          currentTable: table,
                          referencedTable: $$TenantsTableReferences
                              ._familyMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TenantsTableReferences(
                                db,
                                table,
                                p0,
                              ).familyMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tenantId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TenantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TenantsTable,
      TenantEntity,
      $$TenantsTableFilterComposer,
      $$TenantsTableOrderingComposer,
      $$TenantsTableAnnotationComposer,
      $$TenantsTableCreateCompanionBuilder,
      $$TenantsTableUpdateCompanionBuilder,
      (TenantEntity, $$TenantsTableReferences),
      TenantEntity,
      PrefetchHooks Function({
        bool customFieldsRefs,
        bool occupanciesRefs,
        bool familyMembersRefs,
      })
    >;
typedef $$CustomFieldsTableCreateCompanionBuilder =
    CustomFieldsCompanion Function({
      Value<int> id,
      required int tenantId,
      required String fieldName,
      required String fieldValue,
    });
typedef $$CustomFieldsTableUpdateCompanionBuilder =
    CustomFieldsCompanion Function({
      Value<int> id,
      Value<int> tenantId,
      Value<String> fieldName,
      Value<String> fieldValue,
    });

final class $$CustomFieldsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CustomFieldsTable, CustomFieldEntity> {
  $$CustomFieldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TenantsTable _tenantIdTable(_$AppDatabase db) =>
      db.tenants.createAlias(
        $_aliasNameGenerator(db.customFields.tenantId, db.tenants.id),
      );

  $$TenantsTableProcessedTableManager get tenantId {
    final $_column = $_itemColumn<int>('tenant_id')!;

    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldValue => $composableBuilder(
    column: $table.fieldValue,
    builder: (column) => ColumnFilters(column),
  );

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldName => $composableBuilder(
    column: $table.fieldName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldValue => $composableBuilder(
    column: $table.fieldValue,
    builder: (column) => ColumnOrderings(column),
  );

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldsTable> {
  $$CustomFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fieldName =>
      $composableBuilder(column: $table.fieldName, builder: (column) => column);

  GeneratedColumn<String> get fieldValue => $composableBuilder(
    column: $table.fieldValue,
    builder: (column) => column,
  );

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldsTable,
          CustomFieldEntity,
          $$CustomFieldsTableFilterComposer,
          $$CustomFieldsTableOrderingComposer,
          $$CustomFieldsTableAnnotationComposer,
          $$CustomFieldsTableCreateCompanionBuilder,
          $$CustomFieldsTableUpdateCompanionBuilder,
          (CustomFieldEntity, $$CustomFieldsTableReferences),
          CustomFieldEntity,
          PrefetchHooks Function({bool tenantId})
        > {
  $$CustomFieldsTableTableManager(_$AppDatabase db, $CustomFieldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tenantId = const Value.absent(),
                Value<String> fieldName = const Value.absent(),
                Value<String> fieldValue = const Value.absent(),
              }) => CustomFieldsCompanion(
                id: id,
                tenantId: tenantId,
                fieldName: fieldName,
                fieldValue: fieldValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tenantId,
                required String fieldName,
                required String fieldValue,
              }) => CustomFieldsCompanion.insert(
                id: id,
                tenantId: tenantId,
                fieldName: fieldName,
                fieldValue: fieldValue,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomFieldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tenantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tenantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tenantId,
                                referencedTable: $$CustomFieldsTableReferences
                                    ._tenantIdTable(db),
                                referencedColumn: $$CustomFieldsTableReferences
                                    ._tenantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldsTable,
      CustomFieldEntity,
      $$CustomFieldsTableFilterComposer,
      $$CustomFieldsTableOrderingComposer,
      $$CustomFieldsTableAnnotationComposer,
      $$CustomFieldsTableCreateCompanionBuilder,
      $$CustomFieldsTableUpdateCompanionBuilder,
      (CustomFieldEntity, $$CustomFieldsTableReferences),
      CustomFieldEntity,
      PrefetchHooks Function({bool tenantId})
    >;
typedef $$OccupanciesTableCreateCompanionBuilder =
    OccupanciesCompanion Function({
      Value<int> id,
      required int roomId,
      required int tenantId,
      required DateTime moveInDate,
      Value<DateTime?> moveOutDate,
      required double agreedRent,
      Value<double> securityDeposit,
      Value<bool> isActive,
      Value<DepositStatus> depositStatus,
      Value<DateTime?> depositReceivedDate,
      Value<DateTime?> depositReturnedDate,
      Value<double?> depositReturnedAmount,
    });
typedef $$OccupanciesTableUpdateCompanionBuilder =
    OccupanciesCompanion Function({
      Value<int> id,
      Value<int> roomId,
      Value<int> tenantId,
      Value<DateTime> moveInDate,
      Value<DateTime?> moveOutDate,
      Value<double> agreedRent,
      Value<double> securityDeposit,
      Value<bool> isActive,
      Value<DepositStatus> depositStatus,
      Value<DateTime?> depositReceivedDate,
      Value<DateTime?> depositReturnedDate,
      Value<double?> depositReturnedAmount,
    });

final class $$OccupanciesTableReferences
    extends BaseReferences<_$AppDatabase, $OccupanciesTable, OccupancyEntity> {
  $$OccupanciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoomsTable _roomIdTable(_$AppDatabase db) => db.rooms.createAlias(
    $_aliasNameGenerator(db.occupancies.roomId, db.rooms.id),
  );

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<int>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TenantsTable _tenantIdTable(_$AppDatabase db) =>
      db.tenants.createAlias(
        $_aliasNameGenerator(db.occupancies.tenantId, db.tenants.id),
      );

  $$TenantsTableProcessedTableManager get tenantId {
    final $_column = $_itemColumn<int>('tenant_id')!;

    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BillsTable, List<BillEntity>> _billsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.bills,
    aliasName: $_aliasNameGenerator(db.occupancies.id, db.bills.occupancyId),
  );

  $$BillsTableProcessedTableManager get billsRefs {
    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.occupancyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_billsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DepositTransactionsTable,
    List<DepositTransactionEntity>
  >
  _depositTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.depositTransactions,
        aliasName: $_aliasNameGenerator(
          db.occupancies.id,
          db.depositTransactions.occupancyId,
        ),
      );

  $$DepositTransactionsTableProcessedTableManager get depositTransactionsRefs {
    final manager = $$DepositTransactionsTableTableManager(
      $_db,
      $_db.depositTransactions,
    ).filter((f) => f.occupancyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _depositTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OccupanciesTableFilterComposer
    extends Composer<_$AppDatabase, $OccupanciesTable> {
  $$OccupanciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get agreedRent => $composableBuilder(
    column: $table.agreedRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get securityDeposit => $composableBuilder(
    column: $table.securityDeposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DepositStatus, DepositStatus, String>
  get depositStatus => $composableBuilder(
    column: $table.depositStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get depositReceivedDate => $composableBuilder(
    column: $table.depositReceivedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get depositReturnedDate => $composableBuilder(
    column: $table.depositReturnedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get depositReturnedAmount => $composableBuilder(
    column: $table.depositReturnedAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> billsRefs(
    Expression<bool> Function($$BillsTableFilterComposer f) f,
  ) {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.occupancyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> depositTransactionsRefs(
    Expression<bool> Function($$DepositTransactionsTableFilterComposer f) f,
  ) {
    final $$DepositTransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.depositTransactions,
      getReferencedColumn: (t) => t.occupancyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DepositTransactionsTableFilterComposer(
            $db: $db,
            $table: $db.depositTransactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OccupanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $OccupanciesTable> {
  $$OccupanciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get agreedRent => $composableBuilder(
    column: $table.agreedRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get securityDeposit => $composableBuilder(
    column: $table.securityDeposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get depositStatus => $composableBuilder(
    column: $table.depositStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get depositReceivedDate => $composableBuilder(
    column: $table.depositReceivedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get depositReturnedDate => $composableBuilder(
    column: $table.depositReturnedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get depositReturnedAmount => $composableBuilder(
    column: $table.depositReturnedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OccupanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OccupanciesTable> {
  $$OccupanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get moveInDate => $composableBuilder(
    column: $table.moveInDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get moveOutDate => $composableBuilder(
    column: $table.moveOutDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get agreedRent => $composableBuilder(
    column: $table.agreedRent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get securityDeposit => $composableBuilder(
    column: $table.securityDeposit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DepositStatus, String> get depositStatus =>
      $composableBuilder(
        column: $table.depositStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get depositReceivedDate => $composableBuilder(
    column: $table.depositReceivedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get depositReturnedDate => $composableBuilder(
    column: $table.depositReturnedDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get depositReturnedAmount => $composableBuilder(
    column: $table.depositReturnedAmount,
    builder: (column) => column,
  );

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> billsRefs<T extends Object>(
    Expression<T> Function($$BillsTableAnnotationComposer a) f,
  ) {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.occupancyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> depositTransactionsRefs<T extends Object>(
    Expression<T> Function($$DepositTransactionsTableAnnotationComposer a) f,
  ) {
    final $$DepositTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.depositTransactions,
          getReferencedColumn: (t) => t.occupancyId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DepositTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.depositTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OccupanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OccupanciesTable,
          OccupancyEntity,
          $$OccupanciesTableFilterComposer,
          $$OccupanciesTableOrderingComposer,
          $$OccupanciesTableAnnotationComposer,
          $$OccupanciesTableCreateCompanionBuilder,
          $$OccupanciesTableUpdateCompanionBuilder,
          (OccupancyEntity, $$OccupanciesTableReferences),
          OccupancyEntity,
          PrefetchHooks Function({
            bool roomId,
            bool tenantId,
            bool billsRefs,
            bool depositTransactionsRefs,
          })
        > {
  $$OccupanciesTableTableManager(_$AppDatabase db, $OccupanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OccupanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OccupanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OccupanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roomId = const Value.absent(),
                Value<int> tenantId = const Value.absent(),
                Value<DateTime> moveInDate = const Value.absent(),
                Value<DateTime?> moveOutDate = const Value.absent(),
                Value<double> agreedRent = const Value.absent(),
                Value<double> securityDeposit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DepositStatus> depositStatus = const Value.absent(),
                Value<DateTime?> depositReceivedDate = const Value.absent(),
                Value<DateTime?> depositReturnedDate = const Value.absent(),
                Value<double?> depositReturnedAmount = const Value.absent(),
              }) => OccupanciesCompanion(
                id: id,
                roomId: roomId,
                tenantId: tenantId,
                moveInDate: moveInDate,
                moveOutDate: moveOutDate,
                agreedRent: agreedRent,
                securityDeposit: securityDeposit,
                isActive: isActive,
                depositStatus: depositStatus,
                depositReceivedDate: depositReceivedDate,
                depositReturnedDate: depositReturnedDate,
                depositReturnedAmount: depositReturnedAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roomId,
                required int tenantId,
                required DateTime moveInDate,
                Value<DateTime?> moveOutDate = const Value.absent(),
                required double agreedRent,
                Value<double> securityDeposit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DepositStatus> depositStatus = const Value.absent(),
                Value<DateTime?> depositReceivedDate = const Value.absent(),
                Value<DateTime?> depositReturnedDate = const Value.absent(),
                Value<double?> depositReturnedAmount = const Value.absent(),
              }) => OccupanciesCompanion.insert(
                id: id,
                roomId: roomId,
                tenantId: tenantId,
                moveInDate: moveInDate,
                moveOutDate: moveOutDate,
                agreedRent: agreedRent,
                securityDeposit: securityDeposit,
                isActive: isActive,
                depositStatus: depositStatus,
                depositReceivedDate: depositReceivedDate,
                depositReturnedDate: depositReturnedDate,
                depositReturnedAmount: depositReturnedAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OccupanciesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                roomId = false,
                tenantId = false,
                billsRefs = false,
                depositTransactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (billsRefs) db.bills,
                    if (depositTransactionsRefs) db.depositTransactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (roomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.roomId,
                                    referencedTable:
                                        $$OccupanciesTableReferences
                                            ._roomIdTable(db),
                                    referencedColumn:
                                        $$OccupanciesTableReferences
                                            ._roomIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (tenantId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tenantId,
                                    referencedTable:
                                        $$OccupanciesTableReferences
                                            ._tenantIdTable(db),
                                    referencedColumn:
                                        $$OccupanciesTableReferences
                                            ._tenantIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (billsRefs)
                        await $_getPrefetchedData<
                          OccupancyEntity,
                          $OccupanciesTable,
                          BillEntity
                        >(
                          currentTable: table,
                          referencedTable: $$OccupanciesTableReferences
                              ._billsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OccupanciesTableReferences(
                                db,
                                table,
                                p0,
                              ).billsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.occupancyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (depositTransactionsRefs)
                        await $_getPrefetchedData<
                          OccupancyEntity,
                          $OccupanciesTable,
                          DepositTransactionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$OccupanciesTableReferences
                              ._depositTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OccupanciesTableReferences(
                                db,
                                table,
                                p0,
                              ).depositTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.occupancyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OccupanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OccupanciesTable,
      OccupancyEntity,
      $$OccupanciesTableFilterComposer,
      $$OccupanciesTableOrderingComposer,
      $$OccupanciesTableAnnotationComposer,
      $$OccupanciesTableCreateCompanionBuilder,
      $$OccupanciesTableUpdateCompanionBuilder,
      (OccupancyEntity, $$OccupanciesTableReferences),
      OccupancyEntity,
      PrefetchHooks Function({
        bool roomId,
        bool tenantId,
        bool billsRefs,
        bool depositTransactionsRefs,
      })
    >;
typedef $$BillsTableCreateCompanionBuilder =
    BillsCompanion Function({
      Value<int> id,
      required int occupancyId,
      required BillType billType,
      required int billingMonth,
      required int billingYear,
      Value<DateTime?> periodStartDate,
      Value<DateTime?> periodEndDate,
      required double amount,
      Value<double?> electricityPrevReading,
      Value<double?> electricityCurrReading,
      Value<double?> electricityRateAtBilling,
      Value<double?> electricityCharges,
      Value<String?> meterPhotoPath,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> dueDate,
    });
typedef $$BillsTableUpdateCompanionBuilder =
    BillsCompanion Function({
      Value<int> id,
      Value<int> occupancyId,
      Value<BillType> billType,
      Value<int> billingMonth,
      Value<int> billingYear,
      Value<DateTime?> periodStartDate,
      Value<DateTime?> periodEndDate,
      Value<double> amount,
      Value<double?> electricityPrevReading,
      Value<double?> electricityCurrReading,
      Value<double?> electricityRateAtBilling,
      Value<double?> electricityCharges,
      Value<String?> meterPhotoPath,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> dueDate,
    });

final class $$BillsTableReferences
    extends BaseReferences<_$AppDatabase, $BillsTable, BillEntity> {
  $$BillsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OccupanciesTable _occupancyIdTable(_$AppDatabase db) =>
      db.occupancies.createAlias(
        $_aliasNameGenerator(db.bills.occupancyId, db.occupancies.id),
      );

  $$OccupanciesTableProcessedTableManager get occupancyId {
    final $_column = $_itemColumn<int>('occupancy_id')!;

    final manager = $$OccupanciesTableTableManager(
      $_db,
      $_db.occupancies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_occupancyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<PaymentEntity>>
  _paymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.bills.id, db.payments.billId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MeterPhotosTable, List<MeterPhotoEntity>>
  _meterPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.meterPhotos,
    aliasName: $_aliasNameGenerator(db.bills.id, db.meterPhotos.billId),
  );

  $$MeterPhotosTableProcessedTableManager get meterPhotosRefs {
    final manager = $$MeterPhotosTableTableManager(
      $_db,
      $_db.meterPhotos,
    ).filter((f) => f.billId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meterPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BillType, BillType, String> get billType =>
      $composableBuilder(
        column: $table.billType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingYear => $composableBuilder(
    column: $table.billingYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodEndDate => $composableBuilder(
    column: $table.periodEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get electricityPrevReading => $composableBuilder(
    column: $table.electricityPrevReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get electricityCurrReading => $composableBuilder(
    column: $table.electricityCurrReading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get electricityRateAtBilling => $composableBuilder(
    column: $table.electricityRateAtBilling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get electricityCharges => $composableBuilder(
    column: $table.electricityCharges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meterPhotoPath => $composableBuilder(
    column: $table.meterPhotoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  $$OccupanciesTableFilterComposer get occupancyId {
    final $$OccupanciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableFilterComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> meterPhotosRefs(
    Expression<bool> Function($$MeterPhotosTableFilterComposer f) f,
  ) {
    final $$MeterPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meterPhotos,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeterPhotosTableFilterComposer(
            $db: $db,
            $table: $db.meterPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billType => $composableBuilder(
    column: $table.billType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingYear => $composableBuilder(
    column: $table.billingYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodEndDate => $composableBuilder(
    column: $table.periodEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get electricityPrevReading => $composableBuilder(
    column: $table.electricityPrevReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get electricityCurrReading => $composableBuilder(
    column: $table.electricityCurrReading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get electricityRateAtBilling => $composableBuilder(
    column: $table.electricityRateAtBilling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get electricityCharges => $composableBuilder(
    column: $table.electricityCharges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meterPhotoPath => $composableBuilder(
    column: $table.meterPhotoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$OccupanciesTableOrderingComposer get occupancyId {
    final $$OccupanciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableOrderingComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BillType, String> get billType =>
      $composableBuilder(column: $table.billType, builder: (column) => column);

  GeneratedColumn<int> get billingMonth => $composableBuilder(
    column: $table.billingMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get billingYear => $composableBuilder(
    column: $table.billingYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodEndDate => $composableBuilder(
    column: $table.periodEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get electricityPrevReading => $composableBuilder(
    column: $table.electricityPrevReading,
    builder: (column) => column,
  );

  GeneratedColumn<double> get electricityCurrReading => $composableBuilder(
    column: $table.electricityCurrReading,
    builder: (column) => column,
  );

  GeneratedColumn<double> get electricityRateAtBilling => $composableBuilder(
    column: $table.electricityRateAtBilling,
    builder: (column) => column,
  );

  GeneratedColumn<double> get electricityCharges => $composableBuilder(
    column: $table.electricityCharges,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meterPhotoPath => $composableBuilder(
    column: $table.meterPhotoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  $$OccupanciesTableAnnotationComposer get occupancyId {
    final $$OccupanciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableAnnotationComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> meterPhotosRefs<T extends Object>(
    Expression<T> Function($$MeterPhotosTableAnnotationComposer a) f,
  ) {
    final $$MeterPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meterPhotos,
      getReferencedColumn: (t) => t.billId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MeterPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.meterPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillsTable,
          BillEntity,
          $$BillsTableFilterComposer,
          $$BillsTableOrderingComposer,
          $$BillsTableAnnotationComposer,
          $$BillsTableCreateCompanionBuilder,
          $$BillsTableUpdateCompanionBuilder,
          (BillEntity, $$BillsTableReferences),
          BillEntity,
          PrefetchHooks Function({
            bool occupancyId,
            bool paymentsRefs,
            bool meterPhotosRefs,
          })
        > {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> occupancyId = const Value.absent(),
                Value<BillType> billType = const Value.absent(),
                Value<int> billingMonth = const Value.absent(),
                Value<int> billingYear = const Value.absent(),
                Value<DateTime?> periodStartDate = const Value.absent(),
                Value<DateTime?> periodEndDate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double?> electricityPrevReading = const Value.absent(),
                Value<double?> electricityCurrReading = const Value.absent(),
                Value<double?> electricityRateAtBilling = const Value.absent(),
                Value<double?> electricityCharges = const Value.absent(),
                Value<String?> meterPhotoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
              }) => BillsCompanion(
                id: id,
                occupancyId: occupancyId,
                billType: billType,
                billingMonth: billingMonth,
                billingYear: billingYear,
                periodStartDate: periodStartDate,
                periodEndDate: periodEndDate,
                amount: amount,
                electricityPrevReading: electricityPrevReading,
                electricityCurrReading: electricityCurrReading,
                electricityRateAtBilling: electricityRateAtBilling,
                electricityCharges: electricityCharges,
                meterPhotoPath: meterPhotoPath,
                notes: notes,
                createdAt: createdAt,
                dueDate: dueDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int occupancyId,
                required BillType billType,
                required int billingMonth,
                required int billingYear,
                Value<DateTime?> periodStartDate = const Value.absent(),
                Value<DateTime?> periodEndDate = const Value.absent(),
                required double amount,
                Value<double?> electricityPrevReading = const Value.absent(),
                Value<double?> electricityCurrReading = const Value.absent(),
                Value<double?> electricityRateAtBilling = const Value.absent(),
                Value<double?> electricityCharges = const Value.absent(),
                Value<String?> meterPhotoPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
              }) => BillsCompanion.insert(
                id: id,
                occupancyId: occupancyId,
                billType: billType,
                billingMonth: billingMonth,
                billingYear: billingYear,
                periodStartDate: periodStartDate,
                periodEndDate: periodEndDate,
                amount: amount,
                electricityPrevReading: electricityPrevReading,
                electricityCurrReading: electricityCurrReading,
                electricityRateAtBilling: electricityRateAtBilling,
                electricityCharges: electricityCharges,
                meterPhotoPath: meterPhotoPath,
                notes: notes,
                createdAt: createdAt,
                dueDate: dueDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$BillsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                occupancyId = false,
                paymentsRefs = false,
                meterPhotosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (paymentsRefs) db.payments,
                    if (meterPhotosRefs) db.meterPhotos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (occupancyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.occupancyId,
                                    referencedTable: $$BillsTableReferences
                                        ._occupancyIdTable(db),
                                    referencedColumn: $$BillsTableReferences
                                        ._occupancyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          BillEntity,
                          $BillsTable,
                          PaymentEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.billId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (meterPhotosRefs)
                        await $_getPrefetchedData<
                          BillEntity,
                          $BillsTable,
                          MeterPhotoEntity
                        >(
                          currentTable: table,
                          referencedTable: $$BillsTableReferences
                              ._meterPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BillsTableReferences(
                                db,
                                table,
                                p0,
                              ).meterPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.billId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillsTable,
      BillEntity,
      $$BillsTableFilterComposer,
      $$BillsTableOrderingComposer,
      $$BillsTableAnnotationComposer,
      $$BillsTableCreateCompanionBuilder,
      $$BillsTableUpdateCompanionBuilder,
      (BillEntity, $$BillsTableReferences),
      BillEntity,
      PrefetchHooks Function({
        bool occupancyId,
        bool paymentsRefs,
        bool meterPhotosRefs,
      })
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int billId,
      required double amount,
      required PaymentMode paymentMode,
      Value<String?> notes,
      Value<DateTime> paymentDate,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> billId,
      Value<double> amount,
      Value<PaymentMode> paymentMode,
      Value<String?> notes,
      Value<DateTime> paymentDate,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, PaymentEntity> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) => db.bills.createAlias(
    $_aliasNameGenerator(db.payments.billId, db.bills.id),
  );

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<int>('bill_id')!;

    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, String>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableOrderingComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMode, String> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          PaymentEntity,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (PaymentEntity, $$PaymentsTableReferences),
          PaymentEntity,
          PrefetchHooks Function({bool billId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> billId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                billId: billId,
                amount: amount,
                paymentMode: paymentMode,
                notes: notes,
                paymentDate: paymentDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int billId,
                required double amount,
                required PaymentMode paymentMode,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                billId: billId,
                amount: amount,
                paymentMode: paymentMode,
                notes: notes,
                paymentDate: paymentDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (billId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.billId,
                                referencedTable: $$PaymentsTableReferences
                                    ._billIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._billIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      PaymentEntity,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (PaymentEntity, $$PaymentsTableReferences),
      PaymentEntity,
      PrefetchHooks Function({bool billId})
    >;
typedef $$ElectricityRatesTableCreateCompanionBuilder =
    ElectricityRatesCompanion Function({
      Value<int> id,
      required double ratePerUnit,
      required DateTime effectiveFrom,
    });
typedef $$ElectricityRatesTableUpdateCompanionBuilder =
    ElectricityRatesCompanion Function({
      Value<int> id,
      Value<double> ratePerUnit,
      Value<DateTime> effectiveFrom,
    });

class $$ElectricityRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ElectricityRatesTable> {
  $$ElectricityRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratePerUnit => $composableBuilder(
    column: $table.ratePerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ElectricityRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ElectricityRatesTable> {
  $$ElectricityRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratePerUnit => $composableBuilder(
    column: $table.ratePerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ElectricityRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ElectricityRatesTable> {
  $$ElectricityRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get ratePerUnit => $composableBuilder(
    column: $table.ratePerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );
}

class $$ElectricityRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ElectricityRatesTable,
          ElectricityRateEntity,
          $$ElectricityRatesTableFilterComposer,
          $$ElectricityRatesTableOrderingComposer,
          $$ElectricityRatesTableAnnotationComposer,
          $$ElectricityRatesTableCreateCompanionBuilder,
          $$ElectricityRatesTableUpdateCompanionBuilder,
          (
            ElectricityRateEntity,
            BaseReferences<
              _$AppDatabase,
              $ElectricityRatesTable,
              ElectricityRateEntity
            >,
          ),
          ElectricityRateEntity,
          PrefetchHooks Function()
        > {
  $$ElectricityRatesTableTableManager(
    _$AppDatabase db,
    $ElectricityRatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ElectricityRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ElectricityRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ElectricityRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> ratePerUnit = const Value.absent(),
                Value<DateTime> effectiveFrom = const Value.absent(),
              }) => ElectricityRatesCompanion(
                id: id,
                ratePerUnit: ratePerUnit,
                effectiveFrom: effectiveFrom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double ratePerUnit,
                required DateTime effectiveFrom,
              }) => ElectricityRatesCompanion.insert(
                id: id,
                ratePerUnit: ratePerUnit,
                effectiveFrom: effectiveFrom,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ElectricityRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ElectricityRatesTable,
      ElectricityRateEntity,
      $$ElectricityRatesTableFilterComposer,
      $$ElectricityRatesTableOrderingComposer,
      $$ElectricityRatesTableAnnotationComposer,
      $$ElectricityRatesTableCreateCompanionBuilder,
      $$ElectricityRatesTableUpdateCompanionBuilder,
      (
        ElectricityRateEntity,
        BaseReferences<
          _$AppDatabase,
          $ElectricityRatesTable,
          ElectricityRateEntity
        >,
      ),
      ElectricityRateEntity,
      PrefetchHooks Function()
    >;
typedef $$FamilyMembersTableCreateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      required int tenantId,
      required String name,
      required FamilyRelationship relationship,
      Value<String?> phone,
      Value<String?> aadharNumber,
      Value<DateTime> createdAt,
    });
typedef $$FamilyMembersTableUpdateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      Value<int> tenantId,
      Value<String> name,
      Value<FamilyRelationship> relationship,
      Value<String?> phone,
      Value<String?> aadharNumber,
      Value<DateTime> createdAt,
    });

final class $$FamilyMembersTableReferences
    extends
        BaseReferences<_$AppDatabase, $FamilyMembersTable, FamilyMemberEntity> {
  $$FamilyMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TenantsTable _tenantIdTable(_$AppDatabase db) =>
      db.tenants.createAlias(
        $_aliasNameGenerator(db.familyMembers.tenantId, db.tenants.id),
      );

  $$TenantsTableProcessedTableManager get tenantId {
    final $_column = $_itemColumn<int>('tenant_id')!;

    final manager = $$TenantsTableTableManager(
      $_db,
      $_db.tenants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tenantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FamilyMembersTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FamilyRelationship, FamilyRelationship, String>
  get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TenantsTableFilterComposer get tenantId {
    final $$TenantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableFilterComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TenantsTableOrderingComposer get tenantId {
    final $$TenantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableOrderingComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FamilyRelationship, String>
  get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get aadharNumber => $composableBuilder(
    column: $table.aadharNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TenantsTableAnnotationComposer get tenantId {
    final $$TenantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tenantId,
      referencedTable: $db.tenants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TenantsTableAnnotationComposer(
            $db: $db,
            $table: $db.tenants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyMembersTable,
          FamilyMemberEntity,
          $$FamilyMembersTableFilterComposer,
          $$FamilyMembersTableOrderingComposer,
          $$FamilyMembersTableAnnotationComposer,
          $$FamilyMembersTableCreateCompanionBuilder,
          $$FamilyMembersTableUpdateCompanionBuilder,
          (FamilyMemberEntity, $$FamilyMembersTableReferences),
          FamilyMemberEntity,
          PrefetchHooks Function({bool tenantId})
        > {
  $$FamilyMembersTableTableManager(_$AppDatabase db, $FamilyMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tenantId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<FamilyRelationship> relationship = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> aadharNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamilyMembersCompanion(
                id: id,
                tenantId: tenantId,
                name: name,
                relationship: relationship,
                phone: phone,
                aadharNumber: aadharNumber,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tenantId,
                required String name,
                required FamilyRelationship relationship,
                Value<String?> phone = const Value.absent(),
                Value<String?> aadharNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamilyMembersCompanion.insert(
                id: id,
                tenantId: tenantId,
                name: name,
                relationship: relationship,
                phone: phone,
                aadharNumber: aadharNumber,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FamilyMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tenantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tenantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tenantId,
                                referencedTable: $$FamilyMembersTableReferences
                                    ._tenantIdTable(db),
                                referencedColumn: $$FamilyMembersTableReferences
                                    ._tenantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FamilyMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyMembersTable,
      FamilyMemberEntity,
      $$FamilyMembersTableFilterComposer,
      $$FamilyMembersTableOrderingComposer,
      $$FamilyMembersTableAnnotationComposer,
      $$FamilyMembersTableCreateCompanionBuilder,
      $$FamilyMembersTableUpdateCompanionBuilder,
      (FamilyMemberEntity, $$FamilyMembersTableReferences),
      FamilyMemberEntity,
      PrefetchHooks Function({bool tenantId})
    >;
typedef $$DepositTransactionsTableCreateCompanionBuilder =
    DepositTransactionsCompanion Function({
      Value<int> id,
      required int occupancyId,
      required DepositTransactionType transactionType,
      required double amount,
      required DateTime transactionDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$DepositTransactionsTableUpdateCompanionBuilder =
    DepositTransactionsCompanion Function({
      Value<int> id,
      Value<int> occupancyId,
      Value<DepositTransactionType> transactionType,
      Value<double> amount,
      Value<DateTime> transactionDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$DepositTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DepositTransactionsTable,
          DepositTransactionEntity
        > {
  $$DepositTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OccupanciesTable _occupancyIdTable(_$AppDatabase db) =>
      db.occupancies.createAlias(
        $_aliasNameGenerator(
          db.depositTransactions.occupancyId,
          db.occupancies.id,
        ),
      );

  $$OccupanciesTableProcessedTableManager get occupancyId {
    final $_column = $_itemColumn<int>('occupancy_id')!;

    final manager = $$OccupanciesTableTableManager(
      $_db,
      $_db.occupancies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_occupancyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DepositTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $DepositTransactionsTable> {
  $$DepositTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    DepositTransactionType,
    DepositTransactionType,
    String
  >
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OccupanciesTableFilterComposer get occupancyId {
    final $$OccupanciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableFilterComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepositTransactionsTable> {
  $$DepositTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OccupanciesTableOrderingComposer get occupancyId {
    final $$OccupanciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableOrderingComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepositTransactionsTable> {
  $$DepositTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DepositTransactionType, String>
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OccupanciesTableAnnotationComposer get occupancyId {
    final $$OccupanciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occupancyId,
      referencedTable: $db.occupancies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OccupanciesTableAnnotationComposer(
            $db: $db,
            $table: $db.occupancies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DepositTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepositTransactionsTable,
          DepositTransactionEntity,
          $$DepositTransactionsTableFilterComposer,
          $$DepositTransactionsTableOrderingComposer,
          $$DepositTransactionsTableAnnotationComposer,
          $$DepositTransactionsTableCreateCompanionBuilder,
          $$DepositTransactionsTableUpdateCompanionBuilder,
          (DepositTransactionEntity, $$DepositTransactionsTableReferences),
          DepositTransactionEntity,
          PrefetchHooks Function({bool occupancyId})
        > {
  $$DepositTransactionsTableTableManager(
    _$AppDatabase db,
    $DepositTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepositTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepositTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DepositTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> occupancyId = const Value.absent(),
                Value<DepositTransactionType> transactionType =
                    const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DepositTransactionsCompanion(
                id: id,
                occupancyId: occupancyId,
                transactionType: transactionType,
                amount: amount,
                transactionDate: transactionDate,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int occupancyId,
                required DepositTransactionType transactionType,
                required double amount,
                required DateTime transactionDate,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DepositTransactionsCompanion.insert(
                id: id,
                occupancyId: occupancyId,
                transactionType: transactionType,
                amount: amount,
                transactionDate: transactionDate,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DepositTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({occupancyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (occupancyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.occupancyId,
                                referencedTable:
                                    $$DepositTransactionsTableReferences
                                        ._occupancyIdTable(db),
                                referencedColumn:
                                    $$DepositTransactionsTableReferences
                                        ._occupancyIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DepositTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepositTransactionsTable,
      DepositTransactionEntity,
      $$DepositTransactionsTableFilterComposer,
      $$DepositTransactionsTableOrderingComposer,
      $$DepositTransactionsTableAnnotationComposer,
      $$DepositTransactionsTableCreateCompanionBuilder,
      $$DepositTransactionsTableUpdateCompanionBuilder,
      (DepositTransactionEntity, $$DepositTransactionsTableReferences),
      DepositTransactionEntity,
      PrefetchHooks Function({bool occupancyId})
    >;
typedef $$MeterPhotosTableCreateCompanionBuilder =
    MeterPhotosCompanion Function({
      Value<int> id,
      required int billId,
      required String photoPath,
      Value<int> photoOrder,
      Value<DateTime> createdAt,
    });
typedef $$MeterPhotosTableUpdateCompanionBuilder =
    MeterPhotosCompanion Function({
      Value<int> id,
      Value<int> billId,
      Value<String> photoPath,
      Value<int> photoOrder,
      Value<DateTime> createdAt,
    });

final class $$MeterPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $MeterPhotosTable, MeterPhotoEntity> {
  $$MeterPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BillsTable _billIdTable(_$AppDatabase db) => db.bills.createAlias(
    $_aliasNameGenerator(db.meterPhotos.billId, db.bills.id),
  );

  $$BillsTableProcessedTableManager get billId {
    final $_column = $_itemColumn<int>('bill_id')!;

    final manager = $$BillsTableTableManager(
      $_db,
      $_db.bills,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_billIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MeterPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $MeterPhotosTable> {
  $$MeterPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get photoOrder => $composableBuilder(
    column: $table.photoOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BillsTableFilterComposer get billId {
    final $$BillsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableFilterComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeterPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $MeterPhotosTable> {
  $$MeterPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get photoOrder => $composableBuilder(
    column: $table.photoOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BillsTableOrderingComposer get billId {
    final $$BillsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableOrderingComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeterPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeterPhotosTable> {
  $$MeterPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get photoOrder => $composableBuilder(
    column: $table.photoOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BillsTableAnnotationComposer get billId {
    final $$BillsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.billId,
      referencedTable: $db.bills,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BillsTableAnnotationComposer(
            $db: $db,
            $table: $db.bills,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MeterPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeterPhotosTable,
          MeterPhotoEntity,
          $$MeterPhotosTableFilterComposer,
          $$MeterPhotosTableOrderingComposer,
          $$MeterPhotosTableAnnotationComposer,
          $$MeterPhotosTableCreateCompanionBuilder,
          $$MeterPhotosTableUpdateCompanionBuilder,
          (MeterPhotoEntity, $$MeterPhotosTableReferences),
          MeterPhotoEntity,
          PrefetchHooks Function({bool billId})
        > {
  $$MeterPhotosTableTableManager(_$AppDatabase db, $MeterPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeterPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeterPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeterPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> billId = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<int> photoOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeterPhotosCompanion(
                id: id,
                billId: billId,
                photoPath: photoPath,
                photoOrder: photoOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int billId,
                required String photoPath,
                Value<int> photoOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MeterPhotosCompanion.insert(
                id: id,
                billId: billId,
                photoPath: photoPath,
                photoOrder: photoOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MeterPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({billId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (billId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.billId,
                                referencedTable: $$MeterPhotosTableReferences
                                    ._billIdTable(db),
                                referencedColumn: $$MeterPhotosTableReferences
                                    ._billIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MeterPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeterPhotosTable,
      MeterPhotoEntity,
      $$MeterPhotosTableFilterComposer,
      $$MeterPhotosTableOrderingComposer,
      $$MeterPhotosTableAnnotationComposer,
      $$MeterPhotosTableCreateCompanionBuilder,
      $$MeterPhotosTableUpdateCompanionBuilder,
      (MeterPhotoEntity, $$MeterPhotosTableReferences),
      MeterPhotoEntity,
      PrefetchHooks Function({bool billId})
    >;
typedef $$AutoBillSettingsTableCreateCompanionBuilder =
    AutoBillSettingsCompanion Function({
      Value<int> id,
      required int roomId,
      Value<bool> enabled,
      Value<bool> generateRent,
      Value<bool> generateElectricity,
      Value<int> generationDay,
      Value<int> dueDayOffset,
      Value<DateTime?> lastGeneratedAt,
    });
typedef $$AutoBillSettingsTableUpdateCompanionBuilder =
    AutoBillSettingsCompanion Function({
      Value<int> id,
      Value<int> roomId,
      Value<bool> enabled,
      Value<bool> generateRent,
      Value<bool> generateElectricity,
      Value<int> generationDay,
      Value<int> dueDayOffset,
      Value<DateTime?> lastGeneratedAt,
    });

final class $$AutoBillSettingsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AutoBillSettingsTable,
          AutoBillSettingEntity
        > {
  $$AutoBillSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoomsTable _roomIdTable(_$AppDatabase db) => db.rooms.createAlias(
    $_aliasNameGenerator(db.autoBillSettings.roomId, db.rooms.id),
  );

  $$RoomsTableProcessedTableManager get roomId {
    final $_column = $_itemColumn<int>('room_id')!;

    final manager = $$RoomsTableTableManager(
      $_db,
      $_db.rooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AutoBillSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AutoBillSettingsTable> {
  $$AutoBillSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get generateRent => $composableBuilder(
    column: $table.generateRent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get generateElectricity => $composableBuilder(
    column: $table.generateElectricity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generationDay => $composableBuilder(
    column: $table.generationDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDayOffset => $composableBuilder(
    column: $table.dueDayOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastGeneratedAt => $composableBuilder(
    column: $table.lastGeneratedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoomsTableFilterComposer get roomId {
    final $$RoomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableFilterComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AutoBillSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AutoBillSettingsTable> {
  $$AutoBillSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get generateRent => $composableBuilder(
    column: $table.generateRent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get generateElectricity => $composableBuilder(
    column: $table.generateElectricity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generationDay => $composableBuilder(
    column: $table.generationDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDayOffset => $composableBuilder(
    column: $table.dueDayOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastGeneratedAt => $composableBuilder(
    column: $table.lastGeneratedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoomsTableOrderingComposer get roomId {
    final $$RoomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableOrderingComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AutoBillSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AutoBillSettingsTable> {
  $$AutoBillSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get generateRent => $composableBuilder(
    column: $table.generateRent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get generateElectricity => $composableBuilder(
    column: $table.generateElectricity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generationDay => $composableBuilder(
    column: $table.generationDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDayOffset => $composableBuilder(
    column: $table.dueDayOffset,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastGeneratedAt => $composableBuilder(
    column: $table.lastGeneratedAt,
    builder: (column) => column,
  );

  $$RoomsTableAnnotationComposer get roomId {
    final $$RoomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roomId,
      referencedTable: $db.rooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoomsTableAnnotationComposer(
            $db: $db,
            $table: $db.rooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AutoBillSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AutoBillSettingsTable,
          AutoBillSettingEntity,
          $$AutoBillSettingsTableFilterComposer,
          $$AutoBillSettingsTableOrderingComposer,
          $$AutoBillSettingsTableAnnotationComposer,
          $$AutoBillSettingsTableCreateCompanionBuilder,
          $$AutoBillSettingsTableUpdateCompanionBuilder,
          (AutoBillSettingEntity, $$AutoBillSettingsTableReferences),
          AutoBillSettingEntity,
          PrefetchHooks Function({bool roomId})
        > {
  $$AutoBillSettingsTableTableManager(
    _$AppDatabase db,
    $AutoBillSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AutoBillSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AutoBillSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AutoBillSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> roomId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> generateRent = const Value.absent(),
                Value<bool> generateElectricity = const Value.absent(),
                Value<int> generationDay = const Value.absent(),
                Value<int> dueDayOffset = const Value.absent(),
                Value<DateTime?> lastGeneratedAt = const Value.absent(),
              }) => AutoBillSettingsCompanion(
                id: id,
                roomId: roomId,
                enabled: enabled,
                generateRent: generateRent,
                generateElectricity: generateElectricity,
                generationDay: generationDay,
                dueDayOffset: dueDayOffset,
                lastGeneratedAt: lastGeneratedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int roomId,
                Value<bool> enabled = const Value.absent(),
                Value<bool> generateRent = const Value.absent(),
                Value<bool> generateElectricity = const Value.absent(),
                Value<int> generationDay = const Value.absent(),
                Value<int> dueDayOffset = const Value.absent(),
                Value<DateTime?> lastGeneratedAt = const Value.absent(),
              }) => AutoBillSettingsCompanion.insert(
                id: id,
                roomId: roomId,
                enabled: enabled,
                generateRent: generateRent,
                generateElectricity: generateElectricity,
                generationDay: generationDay,
                dueDayOffset: dueDayOffset,
                lastGeneratedAt: lastGeneratedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AutoBillSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({roomId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (roomId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roomId,
                                referencedTable:
                                    $$AutoBillSettingsTableReferences
                                        ._roomIdTable(db),
                                referencedColumn:
                                    $$AutoBillSettingsTableReferences
                                        ._roomIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AutoBillSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AutoBillSettingsTable,
      AutoBillSettingEntity,
      $$AutoBillSettingsTableFilterComposer,
      $$AutoBillSettingsTableOrderingComposer,
      $$AutoBillSettingsTableAnnotationComposer,
      $$AutoBillSettingsTableCreateCompanionBuilder,
      $$AutoBillSettingsTableUpdateCompanionBuilder,
      (AutoBillSettingEntity, $$AutoBillSettingsTableReferences),
      AutoBillSettingEntity,
      PrefetchHooks Function({bool roomId})
    >;
typedef $$NotificationSettingsTableCreateCompanionBuilder =
    NotificationSettingsCompanion Function({
      Value<int> id,
      required NotificationType notificationType,
      Value<bool> enabled,
      Value<int> daysBefore,
      Value<int?> quietHoursStart,
      Value<int?> quietHoursEnd,
    });
typedef $$NotificationSettingsTableUpdateCompanionBuilder =
    NotificationSettingsCompanion Function({
      Value<int> id,
      Value<NotificationType> notificationType,
      Value<bool> enabled,
      Value<int> daysBefore,
      Value<int?> quietHoursStart,
      Value<int?> quietHoursEnd,
    });

class $$NotificationSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NotificationType, NotificationType, String>
  get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationType, String>
  get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get daysBefore => $composableBuilder(
    column: $table.daysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => column,
  );
}

class $$NotificationSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationSettingsTable,
          NotificationSettingEntity,
          $$NotificationSettingsTableFilterComposer,
          $$NotificationSettingsTableOrderingComposer,
          $$NotificationSettingsTableAnnotationComposer,
          $$NotificationSettingsTableCreateCompanionBuilder,
          $$NotificationSettingsTableUpdateCompanionBuilder,
          (
            NotificationSettingEntity,
            BaseReferences<
              _$AppDatabase,
              $NotificationSettingsTable,
              NotificationSettingEntity
            >,
          ),
          NotificationSettingEntity,
          PrefetchHooks Function()
        > {
  $$NotificationSettingsTableTableManager(
    _$AppDatabase db,
    $NotificationSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationSettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NotificationType> notificationType = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> daysBefore = const Value.absent(),
                Value<int?> quietHoursStart = const Value.absent(),
                Value<int?> quietHoursEnd = const Value.absent(),
              }) => NotificationSettingsCompanion(
                id: id,
                notificationType: notificationType,
                enabled: enabled,
                daysBefore: daysBefore,
                quietHoursStart: quietHoursStart,
                quietHoursEnd: quietHoursEnd,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required NotificationType notificationType,
                Value<bool> enabled = const Value.absent(),
                Value<int> daysBefore = const Value.absent(),
                Value<int?> quietHoursStart = const Value.absent(),
                Value<int?> quietHoursEnd = const Value.absent(),
              }) => NotificationSettingsCompanion.insert(
                id: id,
                notificationType: notificationType,
                enabled: enabled,
                daysBefore: daysBefore,
                quietHoursStart: quietHoursStart,
                quietHoursEnd: quietHoursEnd,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationSettingsTable,
      NotificationSettingEntity,
      $$NotificationSettingsTableFilterComposer,
      $$NotificationSettingsTableOrderingComposer,
      $$NotificationSettingsTableAnnotationComposer,
      $$NotificationSettingsTableCreateCompanionBuilder,
      $$NotificationSettingsTableUpdateCompanionBuilder,
      (
        NotificationSettingEntity,
        BaseReferences<
          _$AppDatabase,
          $NotificationSettingsTable,
          NotificationSettingEntity
        >,
      ),
      NotificationSettingEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LandlordsTableTableManager get landlords =>
      $$LandlordsTableTableManager(_db, _db.landlords);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db, _db.properties);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db, _db.tenants);
  $$CustomFieldsTableTableManager get customFields =>
      $$CustomFieldsTableTableManager(_db, _db.customFields);
  $$OccupanciesTableTableManager get occupancies =>
      $$OccupanciesTableTableManager(_db, _db.occupancies);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$ElectricityRatesTableTableManager get electricityRates =>
      $$ElectricityRatesTableTableManager(_db, _db.electricityRates);
  $$FamilyMembersTableTableManager get familyMembers =>
      $$FamilyMembersTableTableManager(_db, _db.familyMembers);
  $$DepositTransactionsTableTableManager get depositTransactions =>
      $$DepositTransactionsTableTableManager(_db, _db.depositTransactions);
  $$MeterPhotosTableTableManager get meterPhotos =>
      $$MeterPhotosTableTableManager(_db, _db.meterPhotos);
  $$AutoBillSettingsTableTableManager get autoBillSettings =>
      $$AutoBillSettingsTableTableManager(_db, _db.autoBillSettings);
  $$NotificationSettingsTableTableManager get notificationSettings =>
      $$NotificationSettingsTableTableManager(_db, _db.notificationSettings);
}

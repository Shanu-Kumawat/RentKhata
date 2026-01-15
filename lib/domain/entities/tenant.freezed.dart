// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Tenant _$TenantFromJson(Map<String, dynamic> json) {
  return _Tenant.fromJson(json);
}

/// @nodoc
mixin _$Tenant {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get aadharNumber => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  bool get isPoliceVerified => throw _privateConstructorUsedError;
  String? get policeVerificationDocPath => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Identity fields
  String? get fatherName => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  String? get gender =>
      throw _privateConstructorUsedError; // Additional contact
  String? get secondaryPhone =>
      throw _privateConstructorUsedError; // Permanent address
  String? get permanentAddressLine => throw _privateConstructorUsedError;
  String? get permanentCity => throw _privateConstructorUsedError;
  String? get permanentState => throw _privateConstructorUsedError;
  String? get permanentPincode =>
      throw _privateConstructorUsedError; // Work details
  String? get companyName => throw _privateConstructorUsedError;
  String? get officeAddress =>
      throw _privateConstructorUsedError; // ID document photos
  String? get aadhaarFrontPhotoPath => throw _privateConstructorUsedError;
  String? get aadhaarBackPhotoPath =>
      throw _privateConstructorUsedError; // Introducer/Reference
  String? get introducerName => throw _privateConstructorUsedError;
  String? get introducerAddress => throw _privateConstructorUsedError;
  String? get introducerPhone =>
      throw _privateConstructorUsedError; // Denormalized fields
  int? get currentRoomId => throw _privateConstructorUsedError;
  String? get currentRoomNumber => throw _privateConstructorUsedError;
  String? get currentPropertyName => throw _privateConstructorUsedError;
  bool get isCurrentlyOccupying => throw _privateConstructorUsedError;

  /// Serializes this Tenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TenantCopyWith<Tenant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TenantCopyWith<$Res> {
  factory $TenantCopyWith(Tenant value, $Res Function(Tenant) then) =
      _$TenantCopyWithImpl<$Res, Tenant>;
  @useResult
  $Res call({
    int id,
    String name,
    String? phone,
    String? aadharNumber,
    String? photoPath,
    bool isPoliceVerified,
    String? policeVerificationDocPath,
    DateTime createdAt,
    String? fatherName,
    int? age,
    String? gender,
    String? secondaryPhone,
    String? permanentAddressLine,
    String? permanentCity,
    String? permanentState,
    String? permanentPincode,
    String? companyName,
    String? officeAddress,
    String? aadhaarFrontPhotoPath,
    String? aadhaarBackPhotoPath,
    String? introducerName,
    String? introducerAddress,
    String? introducerPhone,
    int? currentRoomId,
    String? currentRoomNumber,
    String? currentPropertyName,
    bool isCurrentlyOccupying,
  });
}

/// @nodoc
class _$TenantCopyWithImpl<$Res, $Val extends Tenant>
    implements $TenantCopyWith<$Res> {
  _$TenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? aadharNumber = freezed,
    Object? photoPath = freezed,
    Object? isPoliceVerified = null,
    Object? policeVerificationDocPath = freezed,
    Object? createdAt = null,
    Object? fatherName = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? secondaryPhone = freezed,
    Object? permanentAddressLine = freezed,
    Object? permanentCity = freezed,
    Object? permanentState = freezed,
    Object? permanentPincode = freezed,
    Object? companyName = freezed,
    Object? officeAddress = freezed,
    Object? aadhaarFrontPhotoPath = freezed,
    Object? aadhaarBackPhotoPath = freezed,
    Object? introducerName = freezed,
    Object? introducerAddress = freezed,
    Object? introducerPhone = freezed,
    Object? currentRoomId = freezed,
    Object? currentRoomNumber = freezed,
    Object? currentPropertyName = freezed,
    Object? isCurrentlyOccupying = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            aadharNumber: freezed == aadharNumber
                ? _value.aadharNumber
                : aadharNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            isPoliceVerified: null == isPoliceVerified
                ? _value.isPoliceVerified
                : isPoliceVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            policeVerificationDocPath: freezed == policeVerificationDocPath
                ? _value.policeVerificationDocPath
                : policeVerificationDocPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fatherName: freezed == fatherName
                ? _value.fatherName
                : fatherName // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            secondaryPhone: freezed == secondaryPhone
                ? _value.secondaryPhone
                : secondaryPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            permanentAddressLine: freezed == permanentAddressLine
                ? _value.permanentAddressLine
                : permanentAddressLine // ignore: cast_nullable_to_non_nullable
                      as String?,
            permanentCity: freezed == permanentCity
                ? _value.permanentCity
                : permanentCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            permanentState: freezed == permanentState
                ? _value.permanentState
                : permanentState // ignore: cast_nullable_to_non_nullable
                      as String?,
            permanentPincode: freezed == permanentPincode
                ? _value.permanentPincode
                : permanentPincode // ignore: cast_nullable_to_non_nullable
                      as String?,
            companyName: freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            officeAddress: freezed == officeAddress
                ? _value.officeAddress
                : officeAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            aadhaarFrontPhotoPath: freezed == aadhaarFrontPhotoPath
                ? _value.aadhaarFrontPhotoPath
                : aadhaarFrontPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            aadhaarBackPhotoPath: freezed == aadhaarBackPhotoPath
                ? _value.aadhaarBackPhotoPath
                : aadhaarBackPhotoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            introducerName: freezed == introducerName
                ? _value.introducerName
                : introducerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            introducerAddress: freezed == introducerAddress
                ? _value.introducerAddress
                : introducerAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            introducerPhone: freezed == introducerPhone
                ? _value.introducerPhone
                : introducerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentRoomId: freezed == currentRoomId
                ? _value.currentRoomId
                : currentRoomId // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentRoomNumber: freezed == currentRoomNumber
                ? _value.currentRoomNumber
                : currentRoomNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentPropertyName: freezed == currentPropertyName
                ? _value.currentPropertyName
                : currentPropertyName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCurrentlyOccupying: null == isCurrentlyOccupying
                ? _value.isCurrentlyOccupying
                : isCurrentlyOccupying // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TenantImplCopyWith<$Res> implements $TenantCopyWith<$Res> {
  factory _$$TenantImplCopyWith(
    _$TenantImpl value,
    $Res Function(_$TenantImpl) then,
  ) = __$$TenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? phone,
    String? aadharNumber,
    String? photoPath,
    bool isPoliceVerified,
    String? policeVerificationDocPath,
    DateTime createdAt,
    String? fatherName,
    int? age,
    String? gender,
    String? secondaryPhone,
    String? permanentAddressLine,
    String? permanentCity,
    String? permanentState,
    String? permanentPincode,
    String? companyName,
    String? officeAddress,
    String? aadhaarFrontPhotoPath,
    String? aadhaarBackPhotoPath,
    String? introducerName,
    String? introducerAddress,
    String? introducerPhone,
    int? currentRoomId,
    String? currentRoomNumber,
    String? currentPropertyName,
    bool isCurrentlyOccupying,
  });
}

/// @nodoc
class __$$TenantImplCopyWithImpl<$Res>
    extends _$TenantCopyWithImpl<$Res, _$TenantImpl>
    implements _$$TenantImplCopyWith<$Res> {
  __$$TenantImplCopyWithImpl(
    _$TenantImpl _value,
    $Res Function(_$TenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? aadharNumber = freezed,
    Object? photoPath = freezed,
    Object? isPoliceVerified = null,
    Object? policeVerificationDocPath = freezed,
    Object? createdAt = null,
    Object? fatherName = freezed,
    Object? age = freezed,
    Object? gender = freezed,
    Object? secondaryPhone = freezed,
    Object? permanentAddressLine = freezed,
    Object? permanentCity = freezed,
    Object? permanentState = freezed,
    Object? permanentPincode = freezed,
    Object? companyName = freezed,
    Object? officeAddress = freezed,
    Object? aadhaarFrontPhotoPath = freezed,
    Object? aadhaarBackPhotoPath = freezed,
    Object? introducerName = freezed,
    Object? introducerAddress = freezed,
    Object? introducerPhone = freezed,
    Object? currentRoomId = freezed,
    Object? currentRoomNumber = freezed,
    Object? currentPropertyName = freezed,
    Object? isCurrentlyOccupying = null,
  }) {
    return _then(
      _$TenantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        aadharNumber: freezed == aadharNumber
            ? _value.aadharNumber
            : aadharNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        isPoliceVerified: null == isPoliceVerified
            ? _value.isPoliceVerified
            : isPoliceVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        policeVerificationDocPath: freezed == policeVerificationDocPath
            ? _value.policeVerificationDocPath
            : policeVerificationDocPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fatherName: freezed == fatherName
            ? _value.fatherName
            : fatherName // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        secondaryPhone: freezed == secondaryPhone
            ? _value.secondaryPhone
            : secondaryPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        permanentAddressLine: freezed == permanentAddressLine
            ? _value.permanentAddressLine
            : permanentAddressLine // ignore: cast_nullable_to_non_nullable
                  as String?,
        permanentCity: freezed == permanentCity
            ? _value.permanentCity
            : permanentCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        permanentState: freezed == permanentState
            ? _value.permanentState
            : permanentState // ignore: cast_nullable_to_non_nullable
                  as String?,
        permanentPincode: freezed == permanentPincode
            ? _value.permanentPincode
            : permanentPincode // ignore: cast_nullable_to_non_nullable
                  as String?,
        companyName: freezed == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        officeAddress: freezed == officeAddress
            ? _value.officeAddress
            : officeAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        aadhaarFrontPhotoPath: freezed == aadhaarFrontPhotoPath
            ? _value.aadhaarFrontPhotoPath
            : aadhaarFrontPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        aadhaarBackPhotoPath: freezed == aadhaarBackPhotoPath
            ? _value.aadhaarBackPhotoPath
            : aadhaarBackPhotoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        introducerName: freezed == introducerName
            ? _value.introducerName
            : introducerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        introducerAddress: freezed == introducerAddress
            ? _value.introducerAddress
            : introducerAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        introducerPhone: freezed == introducerPhone
            ? _value.introducerPhone
            : introducerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentRoomId: freezed == currentRoomId
            ? _value.currentRoomId
            : currentRoomId // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentRoomNumber: freezed == currentRoomNumber
            ? _value.currentRoomNumber
            : currentRoomNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentPropertyName: freezed == currentPropertyName
            ? _value.currentPropertyName
            : currentPropertyName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCurrentlyOccupying: null == isCurrentlyOccupying
            ? _value.isCurrentlyOccupying
            : isCurrentlyOccupying // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TenantImpl implements _Tenant {
  const _$TenantImpl({
    required this.id,
    required this.name,
    this.phone,
    this.aadharNumber,
    this.photoPath,
    this.isPoliceVerified = false,
    this.policeVerificationDocPath,
    required this.createdAt,
    this.fatherName,
    this.age,
    this.gender,
    this.secondaryPhone,
    this.permanentAddressLine,
    this.permanentCity,
    this.permanentState,
    this.permanentPincode,
    this.companyName,
    this.officeAddress,
    this.aadhaarFrontPhotoPath,
    this.aadhaarBackPhotoPath,
    this.introducerName,
    this.introducerAddress,
    this.introducerPhone,
    this.currentRoomId,
    this.currentRoomNumber,
    this.currentPropertyName,
    this.isCurrentlyOccupying = false,
  });

  factory _$TenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$TenantImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? aadharNumber;
  @override
  final String? photoPath;
  @override
  @JsonKey()
  final bool isPoliceVerified;
  @override
  final String? policeVerificationDocPath;
  @override
  final DateTime createdAt;
  // Identity fields
  @override
  final String? fatherName;
  @override
  final int? age;
  @override
  final String? gender;
  // Additional contact
  @override
  final String? secondaryPhone;
  // Permanent address
  @override
  final String? permanentAddressLine;
  @override
  final String? permanentCity;
  @override
  final String? permanentState;
  @override
  final String? permanentPincode;
  // Work details
  @override
  final String? companyName;
  @override
  final String? officeAddress;
  // ID document photos
  @override
  final String? aadhaarFrontPhotoPath;
  @override
  final String? aadhaarBackPhotoPath;
  // Introducer/Reference
  @override
  final String? introducerName;
  @override
  final String? introducerAddress;
  @override
  final String? introducerPhone;
  // Denormalized fields
  @override
  final int? currentRoomId;
  @override
  final String? currentRoomNumber;
  @override
  final String? currentPropertyName;
  @override
  @JsonKey()
  final bool isCurrentlyOccupying;

  @override
  String toString() {
    return 'Tenant(id: $id, name: $name, phone: $phone, aadharNumber: $aadharNumber, photoPath: $photoPath, isPoliceVerified: $isPoliceVerified, policeVerificationDocPath: $policeVerificationDocPath, createdAt: $createdAt, fatherName: $fatherName, age: $age, gender: $gender, secondaryPhone: $secondaryPhone, permanentAddressLine: $permanentAddressLine, permanentCity: $permanentCity, permanentState: $permanentState, permanentPincode: $permanentPincode, companyName: $companyName, officeAddress: $officeAddress, aadhaarFrontPhotoPath: $aadhaarFrontPhotoPath, aadhaarBackPhotoPath: $aadhaarBackPhotoPath, introducerName: $introducerName, introducerAddress: $introducerAddress, introducerPhone: $introducerPhone, currentRoomId: $currentRoomId, currentRoomNumber: $currentRoomNumber, currentPropertyName: $currentPropertyName, isCurrentlyOccupying: $isCurrentlyOccupying)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.aadharNumber, aadharNumber) ||
                other.aadharNumber == aadharNumber) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.isPoliceVerified, isPoliceVerified) ||
                other.isPoliceVerified == isPoliceVerified) &&
            (identical(
                  other.policeVerificationDocPath,
                  policeVerificationDocPath,
                ) ||
                other.policeVerificationDocPath == policeVerificationDocPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.fatherName, fatherName) ||
                other.fatherName == fatherName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.secondaryPhone, secondaryPhone) ||
                other.secondaryPhone == secondaryPhone) &&
            (identical(other.permanentAddressLine, permanentAddressLine) ||
                other.permanentAddressLine == permanentAddressLine) &&
            (identical(other.permanentCity, permanentCity) ||
                other.permanentCity == permanentCity) &&
            (identical(other.permanentState, permanentState) ||
                other.permanentState == permanentState) &&
            (identical(other.permanentPincode, permanentPincode) ||
                other.permanentPincode == permanentPincode) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.officeAddress, officeAddress) ||
                other.officeAddress == officeAddress) &&
            (identical(other.aadhaarFrontPhotoPath, aadhaarFrontPhotoPath) ||
                other.aadhaarFrontPhotoPath == aadhaarFrontPhotoPath) &&
            (identical(other.aadhaarBackPhotoPath, aadhaarBackPhotoPath) ||
                other.aadhaarBackPhotoPath == aadhaarBackPhotoPath) &&
            (identical(other.introducerName, introducerName) ||
                other.introducerName == introducerName) &&
            (identical(other.introducerAddress, introducerAddress) ||
                other.introducerAddress == introducerAddress) &&
            (identical(other.introducerPhone, introducerPhone) ||
                other.introducerPhone == introducerPhone) &&
            (identical(other.currentRoomId, currentRoomId) ||
                other.currentRoomId == currentRoomId) &&
            (identical(other.currentRoomNumber, currentRoomNumber) ||
                other.currentRoomNumber == currentRoomNumber) &&
            (identical(other.currentPropertyName, currentPropertyName) ||
                other.currentPropertyName == currentPropertyName) &&
            (identical(other.isCurrentlyOccupying, isCurrentlyOccupying) ||
                other.isCurrentlyOccupying == isCurrentlyOccupying));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    phone,
    aadharNumber,
    photoPath,
    isPoliceVerified,
    policeVerificationDocPath,
    createdAt,
    fatherName,
    age,
    gender,
    secondaryPhone,
    permanentAddressLine,
    permanentCity,
    permanentState,
    permanentPincode,
    companyName,
    officeAddress,
    aadhaarFrontPhotoPath,
    aadhaarBackPhotoPath,
    introducerName,
    introducerAddress,
    introducerPhone,
    currentRoomId,
    currentRoomNumber,
    currentPropertyName,
    isCurrentlyOccupying,
  ]);

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      __$$TenantImplCopyWithImpl<_$TenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TenantImplToJson(this);
  }
}

abstract class _Tenant implements Tenant {
  const factory _Tenant({
    required final int id,
    required final String name,
    final String? phone,
    final String? aadharNumber,
    final String? photoPath,
    final bool isPoliceVerified,
    final String? policeVerificationDocPath,
    required final DateTime createdAt,
    final String? fatherName,
    final int? age,
    final String? gender,
    final String? secondaryPhone,
    final String? permanentAddressLine,
    final String? permanentCity,
    final String? permanentState,
    final String? permanentPincode,
    final String? companyName,
    final String? officeAddress,
    final String? aadhaarFrontPhotoPath,
    final String? aadhaarBackPhotoPath,
    final String? introducerName,
    final String? introducerAddress,
    final String? introducerPhone,
    final int? currentRoomId,
    final String? currentRoomNumber,
    final String? currentPropertyName,
    final bool isCurrentlyOccupying,
  }) = _$TenantImpl;

  factory _Tenant.fromJson(Map<String, dynamic> json) = _$TenantImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get aadharNumber;
  @override
  String? get photoPath;
  @override
  bool get isPoliceVerified;
  @override
  String? get policeVerificationDocPath;
  @override
  DateTime get createdAt; // Identity fields
  @override
  String? get fatherName;
  @override
  int? get age;
  @override
  String? get gender; // Additional contact
  @override
  String? get secondaryPhone; // Permanent address
  @override
  String? get permanentAddressLine;
  @override
  String? get permanentCity;
  @override
  String? get permanentState;
  @override
  String? get permanentPincode; // Work details
  @override
  String? get companyName;
  @override
  String? get officeAddress; // ID document photos
  @override
  String? get aadhaarFrontPhotoPath;
  @override
  String? get aadhaarBackPhotoPath; // Introducer/Reference
  @override
  String? get introducerName;
  @override
  String? get introducerAddress;
  @override
  String? get introducerPhone; // Denormalized fields
  @override
  int? get currentRoomId;
  @override
  String? get currentRoomNumber;
  @override
  String? get currentPropertyName;
  @override
  bool get isCurrentlyOccupying;

  /// Create a copy of Tenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TenantImplCopyWith<_$TenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomField _$CustomFieldFromJson(Map<String, dynamic> json) {
  return _CustomField.fromJson(json);
}

/// @nodoc
mixin _$CustomField {
  int get id => throw _privateConstructorUsedError;
  int get tenantId => throw _privateConstructorUsedError;
  String get fieldName => throw _privateConstructorUsedError;
  String get fieldValue => throw _privateConstructorUsedError;

  /// Serializes this CustomField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomFieldCopyWith<CustomField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomFieldCopyWith<$Res> {
  factory $CustomFieldCopyWith(
    CustomField value,
    $Res Function(CustomField) then,
  ) = _$CustomFieldCopyWithImpl<$Res, CustomField>;
  @useResult
  $Res call({int id, int tenantId, String fieldName, String fieldValue});
}

/// @nodoc
class _$CustomFieldCopyWithImpl<$Res, $Val extends CustomField>
    implements $CustomFieldCopyWith<$Res> {
  _$CustomFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? fieldName = null,
    Object? fieldValue = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            tenantId: null == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as int,
            fieldName: null == fieldName
                ? _value.fieldName
                : fieldName // ignore: cast_nullable_to_non_nullable
                      as String,
            fieldValue: null == fieldValue
                ? _value.fieldValue
                : fieldValue // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomFieldImplCopyWith<$Res>
    implements $CustomFieldCopyWith<$Res> {
  factory _$$CustomFieldImplCopyWith(
    _$CustomFieldImpl value,
    $Res Function(_$CustomFieldImpl) then,
  ) = __$$CustomFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, int tenantId, String fieldName, String fieldValue});
}

/// @nodoc
class __$$CustomFieldImplCopyWithImpl<$Res>
    extends _$CustomFieldCopyWithImpl<$Res, _$CustomFieldImpl>
    implements _$$CustomFieldImplCopyWith<$Res> {
  __$$CustomFieldImplCopyWithImpl(
    _$CustomFieldImpl _value,
    $Res Function(_$CustomFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tenantId = null,
    Object? fieldName = null,
    Object? fieldValue = null,
  }) {
    return _then(
      _$CustomFieldImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        tenantId: null == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as int,
        fieldName: null == fieldName
            ? _value.fieldName
            : fieldName // ignore: cast_nullable_to_non_nullable
                  as String,
        fieldValue: null == fieldValue
            ? _value.fieldValue
            : fieldValue // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomFieldImpl implements _CustomField {
  const _$CustomFieldImpl({
    required this.id,
    required this.tenantId,
    required this.fieldName,
    required this.fieldValue,
  });

  factory _$CustomFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomFieldImplFromJson(json);

  @override
  final int id;
  @override
  final int tenantId;
  @override
  final String fieldName;
  @override
  final String fieldValue;

  @override
  String toString() {
    return 'CustomField(id: $id, tenantId: $tenantId, fieldName: $fieldName, fieldValue: $fieldValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomFieldImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.fieldValue, fieldValue) ||
                other.fieldValue == fieldValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tenantId, fieldName, fieldValue);

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomFieldImplCopyWith<_$CustomFieldImpl> get copyWith =>
      __$$CustomFieldImplCopyWithImpl<_$CustomFieldImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomFieldImplToJson(this);
  }
}

abstract class _CustomField implements CustomField {
  const factory _CustomField({
    required final int id,
    required final int tenantId,
    required final String fieldName,
    required final String fieldValue,
  }) = _$CustomFieldImpl;

  factory _CustomField.fromJson(Map<String, dynamic> json) =
      _$CustomFieldImpl.fromJson;

  @override
  int get id;
  @override
  int get tenantId;
  @override
  String get fieldName;
  @override
  String get fieldValue;

  /// Create a copy of CustomField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomFieldImplCopyWith<_$CustomFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

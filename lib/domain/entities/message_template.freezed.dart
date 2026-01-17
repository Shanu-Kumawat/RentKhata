// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageTemplate _$MessageTemplateFromJson(Map<String, dynamic> json) {
  return _MessageTemplate.fromJson(json);
}

/// @nodoc
mixin _$MessageTemplate {
  int get id => throw _privateConstructorUsedError;
  TemplateType get templateType => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MessageTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageTemplateCopyWith<MessageTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageTemplateCopyWith<$Res> {
  factory $MessageTemplateCopyWith(
    MessageTemplate value,
    $Res Function(MessageTemplate) then,
  ) = _$MessageTemplateCopyWithImpl<$Res, MessageTemplate>;
  @useResult
  $Res call({
    int id,
    TemplateType templateType,
    String name,
    String body,
    bool isDefault,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MessageTemplateCopyWithImpl<$Res, $Val extends MessageTemplate>
    implements $MessageTemplateCopyWith<$Res> {
  _$MessageTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateType = null,
    Object? name = null,
    Object? body = null,
    Object? isDefault = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            templateType: null == templateType
                ? _value.templateType
                : templateType // ignore: cast_nullable_to_non_nullable
                      as TemplateType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageTemplateImplCopyWith<$Res>
    implements $MessageTemplateCopyWith<$Res> {
  factory _$$MessageTemplateImplCopyWith(
    _$MessageTemplateImpl value,
    $Res Function(_$MessageTemplateImpl) then,
  ) = __$$MessageTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    TemplateType templateType,
    String name,
    String body,
    bool isDefault,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MessageTemplateImplCopyWithImpl<$Res>
    extends _$MessageTemplateCopyWithImpl<$Res, _$MessageTemplateImpl>
    implements _$$MessageTemplateImplCopyWith<$Res> {
  __$$MessageTemplateImplCopyWithImpl(
    _$MessageTemplateImpl _value,
    $Res Function(_$MessageTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateType = null,
    Object? name = null,
    Object? body = null,
    Object? isDefault = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MessageTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        templateType: null == templateType
            ? _value.templateType
            : templateType // ignore: cast_nullable_to_non_nullable
                  as TemplateType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageTemplateImpl extends _MessageTemplate {
  const _$MessageTemplateImpl({
    required this.id,
    required this.templateType,
    required this.name,
    required this.body,
    this.isDefault = false,
    required this.createdAt,
  }) : super._();

  factory _$MessageTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageTemplateImplFromJson(json);

  @override
  final int id;
  @override
  final TemplateType templateType;
  @override
  final String name;
  @override
  final String body;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MessageTemplate(id: $id, templateType: $templateType, name: $name, body: $body, isDefault: $isDefault, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateType, templateType) ||
                other.templateType == templateType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    templateType,
    name,
    body,
    isDefault,
    createdAt,
  );

  /// Create a copy of MessageTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageTemplateImplCopyWith<_$MessageTemplateImpl> get copyWith =>
      __$$MessageTemplateImplCopyWithImpl<_$MessageTemplateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageTemplateImplToJson(this);
  }
}

abstract class _MessageTemplate extends MessageTemplate {
  const factory _MessageTemplate({
    required final int id,
    required final TemplateType templateType,
    required final String name,
    required final String body,
    final bool isDefault,
    required final DateTime createdAt,
  }) = _$MessageTemplateImpl;
  const _MessageTemplate._() : super._();

  factory _MessageTemplate.fromJson(Map<String, dynamic> json) =
      _$MessageTemplateImpl.fromJson;

  @override
  int get id;
  @override
  TemplateType get templateType;
  @override
  String get name;
  @override
  String get body;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;

  /// Create a copy of MessageTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageTemplateImplCopyWith<_$MessageTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

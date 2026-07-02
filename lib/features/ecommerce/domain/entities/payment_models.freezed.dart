// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TestCard _$TestCardFromJson(Map<String, dynamic> json) {
  return _TestCard.fromJson(json);
}

/// @nodoc
mixin _$TestCard {
  String get number => throw _privateConstructorUsedError;
  String get holder => throw _privateConstructorUsedError;
  String get behavior => throw _privateConstructorUsedError;
  double? get availableFunds => throw _privateConstructorUsedError;
  String? get declineReason => throw _privateConstructorUsedError;

  /// Serializes this TestCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestCardCopyWith<TestCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestCardCopyWith<$Res> {
  factory $TestCardCopyWith(TestCard value, $Res Function(TestCard) then) =
      _$TestCardCopyWithImpl<$Res, TestCard>;
  @useResult
  $Res call({
    String number,
    String holder,
    String behavior,
    double? availableFunds,
    String? declineReason,
  });
}

/// @nodoc
class _$TestCardCopyWithImpl<$Res, $Val extends TestCard>
    implements $TestCardCopyWith<$Res> {
  _$TestCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? holder = null,
    Object? behavior = null,
    Object? availableFunds = freezed,
    Object? declineReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
            holder: null == holder
                ? _value.holder
                : holder // ignore: cast_nullable_to_non_nullable
                      as String,
            behavior: null == behavior
                ? _value.behavior
                : behavior // ignore: cast_nullable_to_non_nullable
                      as String,
            availableFunds: freezed == availableFunds
                ? _value.availableFunds
                : availableFunds // ignore: cast_nullable_to_non_nullable
                      as double?,
            declineReason: freezed == declineReason
                ? _value.declineReason
                : declineReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TestCardImplCopyWith<$Res>
    implements $TestCardCopyWith<$Res> {
  factory _$$TestCardImplCopyWith(
    _$TestCardImpl value,
    $Res Function(_$TestCardImpl) then,
  ) = __$$TestCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String number,
    String holder,
    String behavior,
    double? availableFunds,
    String? declineReason,
  });
}

/// @nodoc
class __$$TestCardImplCopyWithImpl<$Res>
    extends _$TestCardCopyWithImpl<$Res, _$TestCardImpl>
    implements _$$TestCardImplCopyWith<$Res> {
  __$$TestCardImplCopyWithImpl(
    _$TestCardImpl _value,
    $Res Function(_$TestCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TestCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? holder = null,
    Object? behavior = null,
    Object? availableFunds = freezed,
    Object? declineReason = freezed,
  }) {
    return _then(
      _$TestCardImpl(
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
        holder: null == holder
            ? _value.holder
            : holder // ignore: cast_nullable_to_non_nullable
                  as String,
        behavior: null == behavior
            ? _value.behavior
            : behavior // ignore: cast_nullable_to_non_nullable
                  as String,
        availableFunds: freezed == availableFunds
            ? _value.availableFunds
            : availableFunds // ignore: cast_nullable_to_non_nullable
                  as double?,
        declineReason: freezed == declineReason
            ? _value.declineReason
            : declineReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TestCardImpl implements _TestCard {
  const _$TestCardImpl({
    required this.number,
    required this.holder,
    required this.behavior,
    this.availableFunds,
    this.declineReason,
  });

  factory _$TestCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestCardImplFromJson(json);

  @override
  final String number;
  @override
  final String holder;
  @override
  final String behavior;
  @override
  final double? availableFunds;
  @override
  final String? declineReason;

  @override
  String toString() {
    return 'TestCard(number: $number, holder: $holder, behavior: $behavior, availableFunds: $availableFunds, declineReason: $declineReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestCardImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.holder, holder) || other.holder == holder) &&
            (identical(other.behavior, behavior) ||
                other.behavior == behavior) &&
            (identical(other.availableFunds, availableFunds) ||
                other.availableFunds == availableFunds) &&
            (identical(other.declineReason, declineReason) ||
                other.declineReason == declineReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    number,
    holder,
    behavior,
    availableFunds,
    declineReason,
  );

  /// Create a copy of TestCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestCardImplCopyWith<_$TestCardImpl> get copyWith =>
      __$$TestCardImplCopyWithImpl<_$TestCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestCardImplToJson(this);
  }
}

abstract class _TestCard implements TestCard {
  const factory _TestCard({
    required final String number,
    required final String holder,
    required final String behavior,
    final double? availableFunds,
    final String? declineReason,
  }) = _$TestCardImpl;

  factory _TestCard.fromJson(Map<String, dynamic> json) =
      _$TestCardImpl.fromJson;

  @override
  String get number;
  @override
  String get holder;
  @override
  String get behavior;
  @override
  double? get availableFunds;
  @override
  String? get declineReason;

  /// Create a copy of TestCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestCardImplCopyWith<_$TestCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  return _PaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PaymentRequest {
  double get amount => throw _privateConstructorUsedError;
  String get cardNumber => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this PaymentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentRequestCopyWith<PaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestCopyWith<$Res> {
  factory $PaymentRequestCopyWith(
    PaymentRequest value,
    $Res Function(PaymentRequest) then,
  ) = _$PaymentRequestCopyWithImpl<$Res, PaymentRequest>;
  @useResult
  $Res call({double amount, String cardNumber, String currency});
}

/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res, $Val extends PaymentRequest>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? cardNumber = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            cardNumber: null == cardNumber
                ? _value.cardNumber
                : cardNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentRequestImplCopyWith<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  factory _$$PaymentRequestImplCopyWith(
    _$PaymentRequestImpl value,
    $Res Function(_$PaymentRequestImpl) then,
  ) = __$$PaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double amount, String cardNumber, String currency});
}

/// @nodoc
class __$$PaymentRequestImplCopyWithImpl<$Res>
    extends _$PaymentRequestCopyWithImpl<$Res, _$PaymentRequestImpl>
    implements _$$PaymentRequestImplCopyWith<$Res> {
  __$$PaymentRequestImplCopyWithImpl(
    _$PaymentRequestImpl _value,
    $Res Function(_$PaymentRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? cardNumber = null,
    Object? currency = null,
  }) {
    return _then(
      _$PaymentRequestImpl(
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        cardNumber: null == cardNumber
            ? _value.cardNumber
            : cardNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentRequestImpl implements _PaymentRequest {
  const _$PaymentRequestImpl({
    required this.amount,
    required this.cardNumber,
    this.currency = 'USD',
  });

  factory _$PaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentRequestImplFromJson(json);

  @override
  final double amount;
  @override
  final String cardNumber;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'PaymentRequest(amount: $amount, cardNumber: $cardNumber, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.cardNumber, cardNumber) ||
                other.cardNumber == cardNumber) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, cardNumber, currency);

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      __$$PaymentRequestImplCopyWithImpl<_$PaymentRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentRequestImplToJson(this);
  }
}

abstract class _PaymentRequest implements PaymentRequest {
  const factory _PaymentRequest({
    required final double amount,
    required final String cardNumber,
    final String currency,
  }) = _$PaymentRequestImpl;

  factory _PaymentRequest.fromJson(Map<String, dynamic> json) =
      _$PaymentRequestImpl.fromJson;

  @override
  double get amount;
  @override
  String get cardNumber;
  @override
  String get currency;

  /// Create a copy of PaymentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) {
  return _PaymentResponse.fromJson(json);
}

/// @nodoc
mixin _$PaymentResponse {
  bool get success => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get cardLast4 => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this PaymentResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentResponseCopyWith<PaymentResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentResponseCopyWith<$Res> {
  factory $PaymentResponseCopyWith(
    PaymentResponse value,
    $Res Function(PaymentResponse) then,
  ) = _$PaymentResponseCopyWithImpl<$Res, PaymentResponse>;
  @useResult
  $Res call({
    bool success,
    String status,
    String? transactionId,
    double amount,
    String currency,
    String cardLast4,
    String message,
    String timestamp,
  });
}

/// @nodoc
class _$PaymentResponseCopyWithImpl<$Res, $Val extends PaymentResponse>
    implements $PaymentResponseCopyWith<$Res> {
  _$PaymentResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? cardLast4 = null,
    Object? message = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            cardLast4: null == cardLast4
                ? _value.cardLast4
                : cardLast4 // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentResponseImplCopyWith<$Res>
    implements $PaymentResponseCopyWith<$Res> {
  factory _$$PaymentResponseImplCopyWith(
    _$PaymentResponseImpl value,
    $Res Function(_$PaymentResponseImpl) then,
  ) = __$$PaymentResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String status,
    String? transactionId,
    double amount,
    String currency,
    String cardLast4,
    String message,
    String timestamp,
  });
}

/// @nodoc
class __$$PaymentResponseImplCopyWithImpl<$Res>
    extends _$PaymentResponseCopyWithImpl<$Res, _$PaymentResponseImpl>
    implements _$$PaymentResponseImplCopyWith<$Res> {
  __$$PaymentResponseImplCopyWithImpl(
    _$PaymentResponseImpl _value,
    $Res Function(_$PaymentResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? status = null,
    Object? transactionId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? cardLast4 = null,
    Object? message = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$PaymentResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        cardLast4: null == cardLast4
            ? _value.cardLast4
            : cardLast4 // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentResponseImpl implements _PaymentResponse {
  const _$PaymentResponseImpl({
    required this.success,
    required this.status,
    this.transactionId,
    required this.amount,
    required this.currency,
    required this.cardLast4,
    required this.message,
    required this.timestamp,
  });

  factory _$PaymentResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String status;
  @override
  final String? transactionId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String cardLast4;
  @override
  final String message;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'PaymentResponse(success: $success, status: $status, transactionId: $transactionId, amount: $amount, currency: $currency, cardLast4: $cardLast4, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.cardLast4, cardLast4) ||
                other.cardLast4 == cardLast4) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    status,
    transactionId,
    amount,
    currency,
    cardLast4,
    message,
    timestamp,
  );

  /// Create a copy of PaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentResponseImplCopyWith<_$PaymentResponseImpl> get copyWith =>
      __$$PaymentResponseImplCopyWithImpl<_$PaymentResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentResponseImplToJson(this);
  }
}

abstract class _PaymentResponse implements PaymentResponse {
  const factory _PaymentResponse({
    required final bool success,
    required final String status,
    final String? transactionId,
    required final double amount,
    required final String currency,
    required final String cardLast4,
    required final String message,
    required final String timestamp,
  }) = _$PaymentResponseImpl;

  factory _PaymentResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get status;
  @override
  String? get transactionId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get cardLast4;
  @override
  String get message;
  @override
  String get timestamp;

  /// Create a copy of PaymentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentResponseImplCopyWith<_$PaymentResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

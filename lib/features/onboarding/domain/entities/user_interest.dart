import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_interest.freezed.dart';
part 'user_interest.g.dart';

@freezed
class UserInterest with _$UserInterest {
  const factory UserInterest({
    required String id,
    required String name,
  }) = _UserInterest;

  factory UserInterest.fromJson(Map<String, dynamic> json) => _$UserInterestFromJson(json);
}

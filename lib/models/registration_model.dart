import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:http/http.dart';
// import 'package:task_manager/login.dart';
// import 'dart:convert';

part 'registration_model.freezed.dart';
part 'registration_model.g.dart';

@freezed
class RegistrationModel with _$RegistrationModel {
  const factory RegistrationModel({
    required String name,
    required String email,
  }) = _RegistrationModel;

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationModelFromJson(json);
}

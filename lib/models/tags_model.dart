import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';
import 'tag.dart';

part 'tags_model.freezed.dart';
part 'tags_model.g.dart';

@freezed
class TagsModel with _$TagsModel {
  const factory TagsModel({
    required List<Tag> items,
    required int total,
    required int limit,
    required int offset,
  }) = _TagsModel;

  factory TagsModel.fromJson(Map<String, dynamic> json) =>
      _$TagsModelFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      prev: json['prev'] as int,
      next: json['next'] as int,
      totalPage: json['totalPage'] as int,
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'perPage': instance.perPage,
      'prev': instance.prev,
      'next': instance.next,
      'totalPage': instance.totalPage,
    };

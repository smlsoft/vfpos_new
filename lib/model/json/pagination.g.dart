// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      prev: json['prev'] as int,
      next: json['next'] as int,
      totalPage: json['totalPage'] as int,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'perPage': instance.perPage,
      'prev': instance.prev,
      'next': instance.next,
      'totalPage': instance.totalPage,
    };

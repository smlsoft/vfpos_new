// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posterminal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosTerminalModel _$PosTerminalModelFromJson(Map<String, dynamic> json) =>
    PosTerminalModel(
      guidfixed: json['guidfixed'] as String,
      branch: BranchModel.fromJson(json['branch'] as Map<String, dynamic>),
      code: json['code'] as String,
      devicenumber: json['devicenumber'] as String,
      docformatinv: json['docformatinv'] as String,
      docformattaxinv: json['docformattaxinv'] as String,
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      receiptform: json['receiptform'] as String,
      warehouse:
          WarehouseModel.fromJson(json['warehouse'] as Map<String, dynamic>),
      activepin: json['activepin'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => EmployeePosModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      doccode: json['doccode'] as String?,
      docformatesalereturn: json['docformatesalereturn'] as String?,
      vattype: json['vattype'] as int?,
      vatrate: (json['vatrate'] as num?)?.toDouble(),
      slips: (json['slips'] as List<dynamic>?)
          ?.map((e) => SlipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isejournal: json['isejournal'] as bool?,
      qrcodes: (json['qrcodes'] as List<dynamic>?)
          ?.map((e) => QrModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isvatregister: json['isvatregister'] as bool?,
      mediaguid: json['mediaguid'] as String?,
      timezoneoffset: json['timezoneoffset'] as String?,
      timezonelabel: json['timezonelabel'] as String?,
      timeforsales: (json['timeforsales'] as List<dynamic>?)
          ?.map((e) => TimeForsaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      billheader: (json['billheader'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      billfooter: (json['billfooter'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      logourl: json['logourl'] as String?,
      isusecreadit: json['isusecreadit'] as bool?,
    );

Map<String, dynamic> _$PosTerminalModelToJson(PosTerminalModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'branch': instance.branch,
      'code': instance.code,
      'devicenumber': instance.devicenumber,
      'docformatinv': instance.docformatinv,
      'docformattaxinv': instance.docformattaxinv,
      'location': instance.location,
      'receiptform': instance.receiptform,
      'warehouse': instance.warehouse,
      'activepin': instance.activepin,
      'employees': instance.employees,
      'doccode': instance.doccode,
      'docformatesalereturn': instance.docformatesalereturn,
      'vattype': instance.vattype,
      'vatrate': instance.vatrate,
      'slips': instance.slips,
      'isejournal': instance.isejournal,
      'qrcodes': instance.qrcodes,
      'billheader': instance.billheader,
      'billfooter': instance.billfooter,
      'logourl': instance.logourl,
      'isvatregister': instance.isvatregister,
      'mediaguid': instance.mediaguid,
      'timezoneoffset': instance.timezoneoffset,
      'timezonelabel': instance.timezonelabel,
      'timeforsales': instance.timeforsales,
      'isusecreadit': instance.isusecreadit,
    };

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
      code: json['code'] as String,
      guidfixed: json['guidfixed'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'names': instance.names,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names,
    };

WarehouseModel _$WarehouseModelFromJson(Map<String, dynamic> json) =>
    WarehouseModel(
      code: json['code'] as String,
      guidfixed: json['guidfixed'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WarehouseModelToJson(WarehouseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'names': instance.names,
    };

EmployeePosModel _$EmployeePosModelFromJson(Map<String, dynamic> json) =>
    EmployeePosModel(
      code: json['code'] as String,
      guidfixed: json['guidfixed'] as String,
      name: json['name'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EmployeePosModelToJson(EmployeePosModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'name': instance.name,
      'permissions': instance.permissions,
    };

SlipModel _$SlipModelFromJson(Map<String, dynamic> json) => SlipModel(
      code: json['code'] as String,
      isrequire: json['isrequire'] as bool,
      name: json['name'] as String,
      formcode: json['formcode'] as String?,
      formnames: (json['formnames'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      headernames: (json['headernames'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlipModelToJson(SlipModel instance) => <String, dynamic>{
      'code': instance.code,
      'isrequire': instance.isrequire,
      'name': instance.name,
      'formcode': instance.formcode,
      'formnames': instance.formnames,
      'headernames': instance.headernames,
    };

TimeForsaleModel _$TimeForsaleModelFromJson(Map<String, dynamic> json) =>
    TimeForsaleModel(
      from: json['from'] as String,
      to: json['to'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TimeForsaleModelToJson(TimeForsaleModel instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'names': instance.names,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageSystemModel _$LanguageSystemModelFromJson(Map<String, dynamic> json) =>
    LanguageSystemModel(
      code: json['code'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$LanguageSystemModelToJson(
        LanguageSystemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
    };

LanguageSystemCodeModel _$LanguageSystemCodeModelFromJson(
        Map<String, dynamic> json) =>
    LanguageSystemCodeModel(
      code: json['code'] as String,
      langs: (json['langs'] as List<dynamic>)
          .map((e) => LanguageSystemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguageSystemCodeModelToJson(
        LanguageSystemCodeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'langs': instance.langs.map((e) => e.toJson()).toList(),
    };

PrinterLocalStrongDataModel _$PrinterLocalStrongDataModelFromJson(
        Map<String, dynamic> json) =>
    PrinterLocalStrongDataModel(
      code: json['code'] as String? ?? "",
      name: json['name'] as String? ?? "",
      ipAddress: json['ipAddress'] as String? ?? "",
      ipPort: json['ipPort'] as int? ?? 0,
      productName: json['productName'] as String? ?? "",
      deviceName: json['deviceName'] as String? ?? "",
      deviceId: json['deviceId'] as String? ?? "",
      manufacturer: json['manufacturer'] as String? ?? "",
      vendorId: json['vendorId'] as String? ?? "",
      productId: json['productId'] as String? ?? "",
      paperType: json['paperType'] as int? ?? 2,
      isReady: json['isReady'] as bool? ?? false,
      formSummeryCode: json['formSummeryCode'] as String? ?? "",
      formTaxCode: json['formTaxCode'] as String? ?? "",
      formFullTaxCode: json['formFullTaxCode'] as String? ?? "",
      isConfigConnectSuccess: json['isConfigConnectSuccess'] as bool? ?? false,
      printerType:
          $enumDecodeNullable(_$PrinterTypeEnumEnumMap, json['printerType']) ??
              PrinterTypeEnum.thermal,
      printerConnectType: $enumDecodeNullable(
              _$PrinterConnectEnumEnumMap, json['printerConnectType']) ??
          PrinterConnectEnum.ip,
      printBillAuto: json['printBillAuto'] as bool? ?? false,
    );

Map<String, dynamic> _$PrinterLocalStrongDataModelToJson(
        PrinterLocalStrongDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'ipPort': instance.ipPort,
      'productName': instance.productName,
      'deviceName': instance.deviceName,
      'deviceId': instance.deviceId,
      'manufacturer': instance.manufacturer,
      'vendorId': instance.vendorId,
      'productId': instance.productId,
      'paperType': instance.paperType,
      'printBillAuto': instance.printBillAuto,
      'printerType': _$PrinterTypeEnumEnumMap[instance.printerType]!,
      'printerConnectType':
          _$PrinterConnectEnumEnumMap[instance.printerConnectType]!,
      'isConfigConnectSuccess': instance.isConfigConnectSuccess,
      'isReady': instance.isReady,
      'formSummeryCode': instance.formSummeryCode,
      'formTaxCode': instance.formTaxCode,
      'formFullTaxCode': instance.formFullTaxCode,
    };

const _$PrinterTypeEnumEnumMap = {
  PrinterTypeEnum.thermal: 'thermal',
  PrinterTypeEnum.dot: 'dot',
  PrinterTypeEnum.laser: 'laser',
  PrinterTypeEnum.inkjet: 'inkjet',
};

const _$PrinterConnectEnumEnumMap = {
  PrinterConnectEnum.ip: 'ip',
  PrinterConnectEnum.bluetooth: 'bluetooth',
  PrinterConnectEnum.usb: 'usb',
  PrinterConnectEnum.windows: 'windows',
  PrinterConnectEnum.sunmi1: 'sunmi1',
};

PosHoldProcessModel _$PosHoldProcessModelFromJson(Map<String, dynamic> json) =>
    PosHoldProcessModel(
      code: json['code'] as String,
    )
      ..holdType = json['holdType'] as int
      ..logCount = json['logCount'] as int
      ..saleCode = json['saleCode'] as String
      ..saleName = json['saleName'] as String
      ..customerCode = json['customerCode'] as String
      ..customerName = json['customerName'] as String
      ..customerPhone = json['customerPhone'] as String
      ..payScreenData =
          PosPayModel.fromJson(json['payScreenData'] as Map<String, dynamic>)
      ..posProcess =
          PosProcessModel.fromJson(json['posProcess'] as Map<String, dynamic>)
      ..tableNumber = json['tableNumber'] as String
      ..isDelivery = json['isDelivery'] as bool
      ..deliveryNumber = json['deliveryNumber'] as String;

Map<String, dynamic> _$PosHoldProcessModelToJson(
        PosHoldProcessModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'holdType': instance.holdType,
      'logCount': instance.logCount,
      'saleCode': instance.saleCode,
      'saleName': instance.saleName,
      'customerCode': instance.customerCode,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'payScreenData': instance.payScreenData.toJson(),
      'posProcess': instance.posProcess.toJson(),
      'tableNumber': instance.tableNumber,
      'isDelivery': instance.isDelivery,
      'deliveryNumber': instance.deliveryNumber,
    };

HttpGetDataModel _$HttpGetDataModelFromJson(Map<String, dynamic> json) =>
    HttpGetDataModel(
      code: json['code'] as String,
      json: json['json'] as String,
    );

Map<String, dynamic> _$HttpGetDataModelToJson(HttpGetDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'json': instance.json,
    };

HttpParameterModel _$HttpParameterModelFromJson(Map<String, dynamic> json) =>
    HttpParameterModel(
      parentGuid: json['parentGuid'] as String? ?? "",
      guid: json['guid'] as String? ?? "",
      barcode: json['barcode'] as String? ?? "",
      jsonData: json['jsonData'] as String? ?? "",
      holdCode: json['holdCode'] as String? ?? "",
      docMode: json['docMode'] as int? ?? 0,
    );

Map<String, dynamic> _$HttpParameterModelToJson(HttpParameterModel instance) =>
    <String, dynamic>{
      'parentGuid': instance.parentGuid,
      'guid': instance.guid,
      'barcode': instance.barcode,
      'jsonData': instance.jsonData,
      'holdCode': instance.holdCode,
      'docMode': instance.docMode,
    };

LanguageDataModel _$LanguageDataModelFromJson(Map<String, dynamic> json) =>
    LanguageDataModel(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LanguageDataModelToJson(LanguageDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

ResponseDataModel _$ResponseDataModelFromJson(Map<String, dynamic> json) =>
    ResponseDataModel(
      data: json['data'] as List<dynamic>,
    );

Map<String, dynamic> _$ResponseDataModelToJson(ResponseDataModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

OrderProductOptionModel _$OrderProductOptionModelFromJson(
        Map<String, dynamic> json) =>
    OrderProductOptionModel(
      guid: json['guid'] as String,
      choicetype: json['choicetype'] as int,
      maxselect: json['maxselect'] as int,
      minselect: json['minselect'] as int,
      names: (json['names'] as List<dynamic>)
          .map((e) =>
              OrderProductLanguageNameModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      choices: (json['choices'] as List<dynamic>)
          .map((e) =>
              OrderProductOptionChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderProductOptionModelToJson(
        OrderProductOptionModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'choicetype': instance.choicetype,
      'maxselect': instance.maxselect,
      'minselect': instance.minselect,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };

OrderProductOptionChoiceModel _$OrderProductOptionChoiceModelFromJson(
        Map<String, dynamic> json) =>
    OrderProductOptionChoiceModel(
      guid: json['guid'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) =>
              OrderProductLanguageNameModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as String,
      qty: (json['qty'] as num).toDouble(),
      selected: json['selected'] as bool,
      priceValue: (json['priceValue'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderProductOptionChoiceModelToJson(
        OrderProductOptionChoiceModel instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'price': instance.price,
      'qty': instance.qty,
      'selected': instance.selected,
      'priceValue': instance.priceValue,
    };

OrderProductLanguageNameModel _$OrderProductLanguageNameModelFromJson(
        Map<String, dynamic> json) =>
    OrderProductLanguageNameModel(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$OrderProductLanguageNameModelToJson(
        OrderProductLanguageNameModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

PriceDataModel _$PriceDataModelFromJson(Map<String, dynamic> json) =>
    PriceDataModel(
      keynumber: json['keynumber'] as int,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceDataModelToJson(PriceDataModel instance) =>
    <String, dynamic>{
      'keynumber': instance.keynumber,
      'price': instance.price,
    };

ProfileSettingModel _$ProfileSettingModelFromJson(Map<String, dynamic> json) =>
    ProfileSettingModel(
      company: ProfileSettingCompanyModel.fromJson(
          json['company'] as Map<String, dynamic>),
      languagelist: (json['languagelist'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      configsystem: ProfileSettingConfigSystemModel.fromJson(
          json['configsystem'] as Map<String, dynamic>),
      branch: (json['branch'] as List<dynamic>)
          .map((e) =>
              ProfileSettingBranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileSettingModelToJson(
        ProfileSettingModel instance) =>
    <String, dynamic>{
      'company': instance.company.toJson(),
      'languagelist': instance.languagelist,
      'configsystem': instance.configsystem.toJson(),
      'branch': instance.branch.map((e) => e.toJson()).toList(),
    };

ProfileSettingBranchModel _$ProfileSettingBranchModelFromJson(
        Map<String, dynamic> json) =>
    ProfileSettingBranchModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileSettingBranchModelToJson(
        ProfileSettingBranchModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };

ProfileSettingConfigSystemModel _$ProfileSettingConfigSystemModelFromJson(
        Map<String, dynamic> json) =>
    ProfileSettingConfigSystemModel(
      vatrate: (json['vatrate'] as num).toDouble(),
      vattypesale: json['vattypesale'] as int,
      vattypepurchase: json['vattypepurchase'] as int,
      inquirytypesale: json['inquirytypesale'] as int,
      inquirytypepurchase: json['inquirytypepurchase'] as int,
      headerreceiptpos: json['headerreceiptpos'] as String,
      footerreciptpos: json['footerreciptpos'] as String,
    );

Map<String, dynamic> _$ProfileSettingConfigSystemModelToJson(
        ProfileSettingConfigSystemModel instance) =>
    <String, dynamic>{
      'vatrate': instance.vatrate,
      'vattypesale': instance.vattypesale,
      'vattypepurchase': instance.vattypepurchase,
      'inquirytypesale': instance.inquirytypesale,
      'inquirytypepurchase': instance.inquirytypepurchase,
      'headerreceiptpos': instance.headerreceiptpos,
      'footerreciptpos': instance.footerreciptpos,
    };

ProfileSettingCompanyModel _$ProfileSettingCompanyModelFromJson(
        Map<String, dynamic> json) =>
    ProfileSettingCompanyModel(
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxID: json['taxID'] as String,
      branchNames: (json['branchNames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phones:
          (json['phones'] as List<dynamic>).map((e) => e as String).toList(),
      emailOwners: (json['emailOwners'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      emailStaffs: (json['emailStaffs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      usebranch: json['usebranch'] as bool,
      usedepartment: json['usedepartment'] as bool,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      logo: json['logo'] as String,
    );

Map<String, dynamic> _$ProfileSettingCompanyModelToJson(
        ProfileSettingCompanyModel instance) =>
    <String, dynamic>{
      'names': instance.names.map((e) => e.toJson()).toList(),
      'taxID': instance.taxID,
      'branchNames': instance.branchNames.map((e) => e.toJson()).toList(),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'phones': instance.phones,
      'emailOwners': instance.emailOwners,
      'emailStaffs': instance.emailStaffs,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'usebranch': instance.usebranch,
      'usedepartment': instance.usedepartment,
      'images': instance.images,
      'logo': instance.logo,
    };

OrderTempUpdateForSplitModel _$OrderTempUpdateForSplitModelFromJson(
        Map<String, dynamic> json) =>
    OrderTempUpdateForSplitModel(
      sourceTable: json['sourceTable'] as String,
      targetTable: json['targetTable'] as String,
      sourceGuid: json['sourceGuid'] as String,
    );

Map<String, dynamic> _$OrderTempUpdateForSplitModelToJson(
        OrderTempUpdateForSplitModel instance) =>
    <String, dynamic>{
      'sourceTable': instance.sourceTable,
      'targetTable': instance.targetTable,
      'sourceGuid': instance.sourceGuid,
    };

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
      holdType: json['holdType'] as int? ?? 1,
      tableNumber: json['tableNumber'] as String? ?? "",
      isDelivery: json['isDelivery'] as bool? ?? false,
      deliveryNumber: json['deliveryNumber'] as String? ?? "",
      customerCode: json['customerCode'] as String? ?? "",
      customerName: json['customerName'] as String? ?? "",
      customerPhone: json['customerPhone'] as String? ?? "",
    )
      ..logCount = json['logCount'] as int
      ..saleCode = json['saleCode'] as String
      ..saleName = json['saleName'] as String
      ..payScreenData =
          PosPayModel.fromJson(json['payScreenData'] as Map<String, dynamic>)
      ..posProcess =
          PosProcessModel.fromJson(json['posProcess'] as Map<String, dynamic>);

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

ProfileCreditCardModel _$ProfileCreditCardModelFromJson(
        Map<String, dynamic> json) =>
    ProfileCreditCardModel(
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookbank: ProfileCreditCardBookBankModel.fromJson(
          json['bookbank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileCreditCardModelToJson(
        ProfileCreditCardModel instance) =>
    <String, dynamic>{
      'names': instance.names?.map((e) => e.toJson()).toList(),
      'bookbank': instance.bookbank.toJson(),
    };

ProfileTransferModel _$ProfileTransferModelFromJson(
        Map<String, dynamic> json) =>
    ProfileTransferModel(
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookbank: ProfileCreditCardBookBankModel.fromJson(
          json['bookbank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileTransferModelToJson(
        ProfileTransferModel instance) =>
    <String, dynamic>{
      'names': instance.names?.map((e) => e.toJson()).toList(),
      'bookbank': instance.bookbank.toJson(),
    };

ProfileCreditCardBookBankModel _$ProfileCreditCardBookBankModelFromJson(
        Map<String, dynamic> json) =>
    ProfileCreditCardBookBankModel(
      accountcode: json['accountcode'] as String?,
      accountname: json['accountname'] as String?,
      bankbranch: json['bankbranch'] as String?,
      bankcode: json['bankcode'] as String?,
      banknames: (json['banknames'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookcode: json['bookcode'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      passbook: json['passbook'] as String?,
    );

Map<String, dynamic> _$ProfileCreditCardBookBankModelToJson(
        ProfileCreditCardBookBankModel instance) =>
    <String, dynamic>{
      'accountcode': instance.accountcode,
      'accountname': instance.accountname,
      'bankbranch': instance.bankbranch,
      'bankcode': instance.bankcode,
      'banknames': instance.banknames?.map((e) => e.toJson()).toList(),
      'bookcode': instance.bookcode,
      'images': instance.images,
      'names': instance.names?.map((e) => e.toJson()).toList(),
      'passbook': instance.passbook,
    };

ProfileQrPaymentModel _$ProfileQrPaymentModelFromJson(
        Map<String, dynamic> json) =>
    ProfileQrPaymentModel(
      guidfixed: json['guidfixed'] as String?,
      code: json['code'] as String,
      bankcode: json['bankcode'] as String,
      banknames: (json['banknames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookbankcode: json['bookbankcode'] as String,
      bookbanknames: (json['bookbanknames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookbankimages: (json['bookbankimages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isactive: json['isactive'] as bool,
      qrtype: json['qrtype'] as int,
      qrnames: (json['qrnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      qrcode: json['qrcode'] as String,
      logo: json['logo'] as String,
      apikey: json['apikey'] as String?,
      accessCode: json['accessCode'] as String?,
      bankcharge: json['bankcharge'] as String?,
      billerCode: json['billerCode'] as String?,
      billerID: json['billerID'] as String?,
      closeQr: json['closeQr'] as int?,
      customercharge: json['customercharge'] as String?,
      merchantName: json['merchantName'] as String?,
      storeID: json['storeID'] as String?,
      terminalID: json['terminalID'] as String?,
    );

Map<String, dynamic> _$ProfileQrPaymentModelToJson(
        ProfileQrPaymentModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'bankcode': instance.bankcode,
      'banknames': instance.banknames.map((e) => e.toJson()).toList(),
      'bookbankcode': instance.bookbankcode,
      'bookbanknames': instance.bookbanknames.map((e) => e.toJson()).toList(),
      'bookbankimages': instance.bookbankimages,
      'isactive': instance.isactive,
      'qrtype': instance.qrtype,
      'qrnames': instance.qrnames.map((e) => e.toJson()).toList(),
      'qrcode': instance.qrcode,
      'logo': instance.logo,
      'apikey': instance.apikey,
      'accessCode': instance.accessCode,
      'bankcharge': instance.bankcharge,
      'billerCode': instance.billerCode,
      'billerID': instance.billerID,
      'closeQr': instance.closeQr,
      'customercharge': instance.customercharge,
      'guidfixed': instance.guidfixed,
      'merchantName': instance.merchantName,
      'storeID': instance.storeID,
      'terminalID': instance.terminalID,
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

ProfileSettingCompanyImageModel _$ProfileSettingCompanyImageModelFromJson(
        Map<String, dynamic> json) =>
    ProfileSettingCompanyImageModel(
      xorder: json['xorder'] as int,
      uri: json['uri'] as String,
    );

Map<String, dynamic> _$ProfileSettingCompanyImageModelToJson(
        ProfileSettingCompanyImageModel instance) =>
    <String, dynamic>{
      'xorder': instance.xorder,
      'uri': instance.uri,
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
      images: (json['images'] as List<dynamic>)
          .map((e) => ProfileSettingCompanyImageModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      logo: json['logo'] as String?,
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
      'images': instance.images.map((e) => e.toJson()).toList(),
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

PosConfigSlipModel _$PosConfigSlipModelFromJson(Map<String, dynamic> json) =>
    PosConfigSlipModel(
      code: json['code'] as String,
      name: json['name'] as String,
      formcode: json['formcode'] as String,
      formnames: (json['formnames'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PosConfigSlipModelToJson(PosConfigSlipModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'formcode': instance.formcode,
      'formnames': instance.formnames.map((e) => e.toJson()).toList(),
    };

PosConfigModel _$PosConfigModelFromJson(Map<String, dynamic> json) =>
    PosConfigModel(
      code: json['code'] as String,
      doccode: json['doccode'] as String,
      vattype: json['vattype'] as int,
      vatrate: (json['vatrate'] as num).toDouble(),
      docformatinv: json['docformatinv'] as String,
      docformatesalereturn: json['docformatesalereturn'] as String,
      billheader: (json['billheader'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      billfooter: (json['billfooter'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isvatregister: json['isvatregister'] as bool,
      isejournal: json['isejournal'] as bool,
      devicenumber: json['devicenumber'] as String,
      slips: (json['slips'] as List<dynamic>)
          .map((e) => PosConfigSlipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      logourl: json['logourl'] as String,
      qrcodes: (json['qrcodes'] as List<dynamic>?)
          ?.map(
              (e) => ProfileQrPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      creditcards: (json['creditcards'] as List<dynamic>?)
          ?.map(
              (e) => ProfileCreditCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      transfers: (json['transfers'] as List<dynamic>?)
          ?.map((e) => ProfileTransferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] == null
          ? null
          : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      warehouse: json['warehouse'] == null
          ? null
          : WarehouseModel.fromJson(json['warehouse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PosConfigModelToJson(PosConfigModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'doccode': instance.doccode,
      'vattype': instance.vattype,
      'vatrate': instance.vatrate,
      'docformatinv': instance.docformatinv,
      'docformatesalereturn': instance.docformatesalereturn,
      'billheader': instance.billheader.map((e) => e.toJson()).toList(),
      'billfooter': instance.billfooter.map((e) => e.toJson()).toList(),
      'isejournal': instance.isejournal,
      'devicenumber': instance.devicenumber,
      'isvatregister': instance.isvatregister,
      'slips': instance.slips.map((e) => e.toJson()).toList(),
      'logourl': instance.logourl,
      'qrcodes': instance.qrcodes?.map((e) => e.toJson()).toList(),
      'creditcards': instance.creditcards?.map((e) => e.toJson()).toList(),
      'transfers': instance.transfers?.map((e) => e.toJson()).toList(),
      'location': instance.location.toJson(),
      'warehouse': instance.warehouse.toJson(),
    };

PosInformationModel _$PosInformationModelFromJson(Map<String, dynamic> json) =>
    PosInformationModel(
      shop_id: json['shop_id'] as String,
      shop_name: json['shop_name'] as String,
    );

Map<String, dynamic> _$PosInformationModelToJson(
        PosInformationModel instance) =>
    <String, dynamic>{
      'shop_id': instance.shop_id,
      'shop_name': instance.shop_name,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };

WarehouseModel _$WarehouseModelFromJson(Map<String, dynamic> json) =>
    WarehouseModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      guidfixed: json['guidfixed'] as String,
    );

Map<String, dynamic> _$WarehouseModelToJson(WarehouseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'names': instance.names.map((e) => e.toJson()).toList(),
    };

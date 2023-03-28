import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class PrinterHelper {
  final box = global.objectBoxStore.box<PrinterObjectBoxStruct>();

  List<PrinterObjectBoxStruct> selectAll() {
    return box.getAll();        
  }

  int insert(PrinterObjectBoxStruct value) {
    return box.put(value);
  }

  void insertMany(List<PrinterObjectBoxStruct> values) {
    box.putMany(values);
  }

  bool deleteByGuidFixed(String guidfixed) {
    bool _result = false;
    final _find = box
        .query(PrinterObjectBoxStruct_.guid_fixed.equals(guidfixed))
        .build()
        .findFirst();
    if (_find != null) {
      _result = box.remove(_find.id);
    }
    return _result;
  }

  void deleteByGuidFixedMany(List<String> guidfixed) {
    Condition<PrinterObjectBoxStruct>? _ids;
    guidfixed.forEach((_guid) {
      if (_ids == null)
        _ids = PrinterObjectBoxStruct_.guid_fixed.equals(_guid);
      else
        _ids =
            _ids?.or(PrinterObjectBoxStruct_.guid_fixed.equals(_guid));
    });
    if (_ids != null) {
      final _find = box.query(_ids).build().find();
      box.removeMany(_find.map((_data) => _data.id).toList());
    }
  }

  bool deleteByCode(String code) {
    bool _result = false;
    final _find = box
        .query(PrinterObjectBoxStruct_.code.equals(code))
        .build()
        .findFirst();
    if (_find != null) {
      _result = box.remove(_find.id);
    }
    return _result;
  }

  void deleteAll() {
    box.removeAll();
  }

  int count() {
    return box.count();
  }
}

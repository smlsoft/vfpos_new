import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:collection/collection.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';

enum PrintColumnAlign { left, right, center }

class PrintColumn {
  late String text;
  late PrintColumnAlign align;

  PrintColumn({required this.text, this.align = PrintColumnAlign.left});
}

class PrintProcess {
  int length;
  List<PrintColumn> column = [];
  List<double> columnWidth = [];

  PrintProcess({required this.length});

  Future<int> thaiCount(String word) async {
    int _result = 0;
    await global.thaiEncode(word).then((value) {
      Uint8List _ascii = Uint8List.fromList(value);
      for (int _index = 0; _index < _ascii.length; _index++) {
        int _char = _ascii[_index];
        if (_char != 209 &&
            !(_char >= 212 && _char <= 217) &&
            !(_char >= 231 && _char <= 237)) {
          _result++;
        }
      }
    });
    return _result;
  }

  Future<void> lineFeed(NetworkPrinter printer, PosStyles style) async {
    List<List<PrintColumn>> _rowList = [];
    int _lastChar = 0;
    List<int> _columnPosition = [];
    List<int> _columnWidth = [];

    // Calc Width
    int _sumColumnWidth = columnWidth.sum.toInt();
    int _position = 0;
    for (int _loop = 0; _loop < columnWidth.length; _loop++) {
      _columnPosition.add(_position);
      double _calc = (length * columnWidth[_loop]) / _sumColumnWidth;
      _columnWidth.add(_calc.toInt());
      _position += _columnWidth[_loop];
    }
    if (_columnWidth.length > 1) {
      _columnWidth[_columnWidth.length - 1] +=
          length - _columnWidth.sum.toInt();
    }
    // Build Row
    for (int _loop1 = 0; _loop1 < 10; _loop1++) {
      List<PrintColumn> _column = [];
      for (int _loop2 = 0; _loop2 < columnWidth.length; _loop2++) {
        _column.add(PrintColumn(text: "", align: column[_loop2].align));
      }
      _rowList.add(_column);
    }
    String _firstBreak = "ใโไเแ";
    String _endBreak = "ๆฯะ";
    for (int _columnIndex = 0; _columnIndex < column.length; _columnIndex++) {
      String _word = column[_columnIndex].text.replaceAll(" ", " " + "๛");
      for (int _loop2 = 0; _loop2 < _firstBreak.length; _loop2++) {
        _word =
            _word.replaceAll(_firstBreak[_loop2], " " + _firstBreak[_loop2]);
      }
      for (int _loop2 = 0; _loop2 < _endBreak.length; _loop2++) {
        _word = _word.replaceAll(_endBreak[_loop2], _endBreak[_loop2] + " ");
      }
      List<String> _split = _word.split(" ");
      int _rowNumber = 0;
      int _loop2 = 0;
      while (_loop2 < _split.length) {
        if (await thaiCount(_split[_loop2]) > _columnWidth[_columnIndex] - 1) {
          _rowList[_rowNumber][_columnIndex].text =
              _split[_loop2].substring(0, _columnWidth[_columnIndex] + 1);
          _split[_loop2] = _split[_loop2].substring(_columnWidth[_columnIndex]);
          _rowNumber++;
        } else {
          if (await thaiCount(
                  _rowList[_rowNumber][_columnIndex].text + _split[_loop2]) >
              _columnWidth[_columnIndex] - 1) {
            _rowNumber++;
          }
          _rowList[_rowNumber][_columnIndex].text =
              _rowList[_rowNumber][_columnIndex].text +
                  _split[_loop2].replaceAll("๛", " ");
          _loop2++;
        }
      }
    }
    // Process
    for (int _line = 9; _line > 0; _line--) {
      bool _remove = true;
      for (int _loop = 0; _loop < column.length && _remove; _loop++) {
        while (_rowList[_line][_loop].text.length > 0 &&
            _rowList[_line][_loop].text[0] == " ") {
          _rowList[_line][_loop].text =
              _rowList[_line][_loop].text.substring(1);
        }
        if (_rowList[_line][_loop].text.trim().length != 0) {
          _remove = false;
        }
      }
      if (_remove) {
        _rowList.removeAt(_line);
      }
    }
    for (int _rowIndex = 0; _rowIndex < _rowList.length; _rowIndex++) {
      for (int _columnIndex = 0; _columnIndex < column.length; _columnIndex++) {
        if (column[_columnIndex].align == PrintColumnAlign.right) {
          StringBuffer _space = StringBuffer();
          int _thaiLength =
              await thaiCount(_rowList[_rowIndex][_columnIndex].text);
          for (int _loop = 0;
              _loop < _columnWidth[_columnIndex] - _thaiLength;
              _loop++) {
            _space.write(" ");
          }
          _rowList[_rowIndex][_columnIndex].text =
              _space.toString() + _rowList[_rowIndex][_columnIndex].text;
        }
      }
    }
    for (int _rowIndex = 0; _rowIndex < _rowList.length; _rowIndex++) {
      List<List<int>> _row = [];
      for (int _lineIndex = 0; _lineIndex < 10; _lineIndex++) {
        for (int _loopRow = 0; _loopRow < 4; _loopRow++) {
          List<int> _line = [];
          for (int _loopColumn = 0; _loopColumn < length; _loopColumn++) {
            _line.add((_loopRow == 0) ? 32 : 0);
          }
          _row.add(_line);
        }
      }
      for (int _loop = 0; _loop < column.length; _loop++) {
        String _word = _rowList[_rowIndex][_loop].text;
        int _pos = _columnPosition[_loop] - 1;
        int _columnLength = 0;
        Uint8List _ascii = Uint8List.fromList(await global.thaiEncode(_word));
        for (int _index = 0; _index < _word.length; _index++) {
          int _char = _ascii[_index];
          if (_pos < length - 1 && _columnLength < _columnWidth[_loop]) {
            if (_char == 216 || _char == 217) {
              _row[1][_pos] = _char;
            } else if (_char == 209 ||
                (_char >= 212 && _char <= 215) ||
                (_char >= 231 && _char <= 237)) {
              if (_lastChar == 209 || (_char >= 212 && _char <= 215)) {
                _row[3][_pos] = _char;
              } else {
                _row[2][_pos] = _char;
              }
            } else {
              _pos++;
              _row[0][_pos] = _char;
              _columnLength++;
            }
            _lastChar = _char;
          }
        }
      }
      List<int> _packList = [];
      for (int _loop = 0; _loop < length; _loop++) {
        for (int _loopRow = 0; _loopRow < 4; _loopRow++) {
          if (_row[_loopRow][_loop] != 0) {
            _packList.add(_row[_loopRow][_loop]);
          }
        }
      }
      var _dataPrint = await global.thaiEncode((await CharsetConverter.decode(
              "TIS620", Uint8List.fromList(_packList)))
          .toString());
      printer.textEncoded(_dataPrint, styles: style);
    }
  }

  Future<void> drawLine(NetworkPrinter printer) async {
    StringBuffer _line = StringBuffer();
    for (int _loop = 0; _loop < length; _loop++) {
      _line.write("-");
    }
    printer.text(_line.toString());
  }
}

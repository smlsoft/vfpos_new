import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/global.dart' as global;
import 'package:collection/collection.dart';

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
    int result = 0;
    await global.thaiEncode(word).then((value) {
      Uint8List ascii = Uint8List.fromList(value);
      for (int index = 0; index < ascii.length; index++) {
        int char = ascii[index];
        if (char != 209 &&
            !(char >= 212 && char <= 217) &&
            !(char >= 231 && char <= 237)) {
          result++;
        }
      }
    });
    return result;
  }

  Future<void> lineFeed(NetworkPrinter printer, PosStyles style) async {
    List<List<PrintColumn>> rowList = [];
    int lastChar = 0;
    List<int> columnPositionList = [];
    List<int> columnWidthList = [];

    // Calc Width
    int sumColumnWidth = columnWidth.sum.toInt();
    int position = 0;
    for (int loop = 0; loop < columnWidth.length; loop++) {
      columnPositionList.add(position);
      double calc = (length * columnWidth[loop]) / sumColumnWidth;
      columnWidthList.add(calc.toInt());
      position += columnWidthList[loop];
    }
    if (columnWidthList.length > 1) {
      columnWidthList[columnWidthList.length - 1] +=
          length - columnWidthList.sum.toInt();
    }
    // Build Row
    for (int loop1 = 0; loop1 < 10; loop1++) {
      List<PrintColumn> columnList = [];
      for (int loop2 = 0; loop2 < columnWidth.length; loop2++) {
        columnList.add(PrintColumn(text: "", align: column[loop2].align));
      }
      rowList.add(columnList);
    }
    String firstBreak = "ใโไเแ";
    String endBreak = "ๆฯะ";
    for (int columnIndex = 0; columnIndex < column.length; columnIndex++) {
      String word = column[columnIndex].text.replaceAll(" ", "๛");
      //String word = column[columnIndex].text;
      for (int loop2 = 0; loop2 < firstBreak.length; loop2++) {
        word = word.replaceAll(firstBreak[loop2], " ${firstBreak[loop2]}");
      }
      for (int loop2 = 0; loop2 < endBreak.length; loop2++) {
        word = word.replaceAll(endBreak[loop2], "${endBreak[loop2]} ");
      }
      List<String> splitList = word.split(" ");
      int rowNumber = 0;
      int loopIndex = 0;
      while (loopIndex < splitList.length) {
        if (await thaiCount(splitList[loopIndex]) >
            columnWidthList[columnIndex] - 1) {
          rowList[rowNumber][columnIndex].text = splitList[loopIndex]
              .substring(0, columnWidthList[columnIndex] + 1);
          splitList[loopIndex] =
              splitList[loopIndex].substring(columnWidthList[columnIndex]);
          rowNumber++;
        } else {
          if (await thaiCount(
                  rowList[rowNumber][columnIndex].text + splitList[loopIndex]) >
              columnWidthList[columnIndex] - 1) {
            rowNumber++;
          }
          rowList[rowNumber][columnIndex].text =
              rowList[rowNumber][columnIndex].text +
                  splitList[loopIndex].replaceAll("๛", " ");
          loopIndex++;
        }
      }
    }
    // Process
    for (int line = 9; line > 0; line--) {
      bool remove = true;
      for (int loop = 0; loop < column.length && remove; loop++) {
        while (rowList[line][loop].text.isNotEmpty &&
            rowList[line][loop].text[0] == " ") {
          rowList[line][loop].text = rowList[line][loop].text.substring(1);
        }
        if (rowList[line][loop].text.trim().isNotEmpty) {
          remove = false;
        }
      }
      if (remove) {
        rowList.removeAt(line);
      }
    }
    for (int rowIndex = 0; rowIndex < rowList.length; rowIndex++) {
      for (int columnIndex = 0; columnIndex < column.length; columnIndex++) {
        if (column[columnIndex].align == PrintColumnAlign.right) {
          StringBuffer space = StringBuffer();
          int thaiLength = await thaiCount(rowList[rowIndex][columnIndex].text);
          for (int loop = 0;
              loop < columnWidthList[columnIndex] - thaiLength;
              loop++) {
            space.write(" ");
          }
          rowList[rowIndex][columnIndex].text =
              space.toString() + rowList[rowIndex][columnIndex].text;
        }
      }
    }
    for (int rowIndex = 0; rowIndex < rowList.length; rowIndex++) {
      List<List<int>> row = [];
      for (int lineIndex = 0; lineIndex < 10; lineIndex++) {
        for (int loopRow = 0; loopRow < 4; loopRow++) {
          List<int> lineList = [];
          for (int loopColumn = 0; loopColumn < length; loopColumn++) {
            lineList.add((loopRow == 0) ? 32 : 0);
          }
          row.add(lineList);
        }
      }
      for (int loop = 0; loop < column.length; loop++) {
        String word = rowList[rowIndex][loop].text;
        int pos = columnPositionList[loop] - 1;
        int columnLength = 0;
        Uint8List asciiCode = Uint8List.fromList(await global.thaiEncode(word));
        for (int index = 0; index < word.length; index++) {
          int char = asciiCode[index];
          if (pos < length - 1 && columnLength < columnWidthList[loop]) {
            if (char == 216 || char == 217) {
              row[1][pos] = char;
            } else if (char == 209 ||
                (char >= 212 && char <= 215) ||
                (char >= 231 && char <= 237)) {
              if (lastChar == 209 || (char >= 212 && char <= 215)) {
                row[3][pos] = char;
              } else {
                row[2][pos] = char;
              }
            } else {
              pos++;
              row[0][pos] = char;
              columnLength++;
            }
            lastChar = char;
          }
        }
      }
      List<int> packList = [];
      for (int loop = 0; loop < length; loop++) {
        for (int loopRow = 0; loopRow < 4; loopRow++) {
          if (row[loopRow][loop] != 0) {
            packList.add(row[loopRow][loop]);
          }
        }
      }
      var dataPrint = await global.thaiEncode((await CharsetConverter.decode(
              "TIS620", Uint8List.fromList(packList)))
          .toString());
      printer.textEncoded(dataPrint, styles: style);
    }
    column.clear();
  }

  Future<void> drawLine(NetworkPrinter printer) async {
    StringBuffer line = StringBuffer();
    for (int loop = 0; loop < length; loop++) {
      line.write("-");
    }
    printer.text(line.toString());
  }
}

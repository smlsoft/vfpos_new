import 'dart:convert';
import 'dart:io';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:gsheets/gsheets.dart';

const googleCredentials = r'''
{
  "type": "service_account",
  "project_id": "multilanguage-366800",
  "private_key_id": "fb084ed2a45dedf866a7acab6cd97dd314646a4d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1qYrMMIiZdBl1\n+jGg/KUhyBmuYEiv6dDcJ1ODqCxgnMo5C0xheYMh+3pNmXCuT65UOx7zFhNvUM9k\nS+/7FG1lrFa5Y7WEQb5hQlvFjZM6gKVoeJk++Q0o//lko6BgZc0u/d13dSYVTEUQ\n+oN3cwgk9jqi399I+oaw6e8d4UueTQmqHis7R0guQraKcwpHYaSpvsG+jYOnDBF/\nXfjNbVMAAz498KnwM8exFe1t7NlpZPqUo4QGVse7ic4/Bpc/gqJPMBKCVhU8I447\nRIpiPws4Z2Ug4uxJvKt52a03EfXUVq28HpUtlUoRNc12uWN7gP6zq3vcK29WYpjG\nqwVgC2t/AgMBAAECggEAUGV0M+HW0nL7Qac0h5bITicMlouuH4xPDt+oqj+nRCqf\npJdHemwYiNWOzwD1SW+iK0zu6Y3/k+gjoLOqxWfI8pJO30UtdBbUdp6zlr6NRfrh\nOVcGG0SFenuul8eClqb3I7Debpu9+vcCKf10aUzTceg3ExYY72dQbMNbO9IVcTzP\n/rSzH5SGsi1VhaPO3Yz+25PoCIp8yZeQWhD8OTauqvp2TNZJzr42GysVldzD7Y6U\niSchxKHCUEsKmOKAmhOlY7PnGp07GVp3Ll9qaZ/mbPYII97KiC3vstU1Ft0Afx9G\nXzCPHJJ4Vsy8paIK6+n8xSBZzH4OmzTMqYu243rAgQKBgQDbG15+dydHfXRHULS5\nxeJcVXb8V5AeB5D3bva6vh+kL8d/OmMmfDXCWMnipSlGQarlxbQp+/g+1nAUfpKZ\ndIVrga4UFgghajqpFRY1rfjSESOgcVVtoYgut57WBZxBYPLmj3EPuW2xrVVHdWw9\nOBCcW4b587dYJ7EAhbQ1hJkS0QKBgQDUQB4HvvAt0o7jJHpPyamuSU+u1pF01sQh\ntgJs0fPCyBpoEAu1DFXRbwX0QECTYb83qD470jPTDbmiRjdAuhxkva31ri566USm\nOjYpaRaqlQ+KsoceWlEoDdifF5kEGUrNykp4GSiTZp8SbemeUfEIAWMdEXHEspmo\npm3Ak7oNTwKBgA5KAKWau7ML2XN1LfQXlaWT5UibpUhwEeIxGGIhWArrGsWPVzwB\nSbg89h2Ty9dLHQwTEqbSSeQ/M9wCTSk40iKquGGS9kDHnr+8IlCp4dpBR+OEwJ9/\ns1PoobEveHtDCVRD8oml/CNkPHWGkOKFL4Ai7/CJFmHnZMG19oSu+xShAoGAR31Z\nIA7F4wk6q3ML53frORLkTeVjlNEJurkNVA3bZs3zZv2Qk+iVtzcH8F774ShZOavn\nWkrQvdOvpOK1lY2aJqxkvY1vhmKvhrWwrH4C7m3KkFLVg/mzwCP5xIw0M9c5BNuP\n/aerrQoxpglzWKoM3z9oXNAVW8U0UEPOT8DyN60CgYBC1EM40SX1vcZX12j6l+oV\n0q4bDSG/DFg1eLoHNoT7syE4h6aSjSTvPle6wgGel2J81hBKgotLhmE4OCo8Q1JT\ngyUC/V5hlHt8NqgLKeJKyCLPwFUTk5vC0ytcJqlyUVcFKo8J37zRUUN8lF/ZMs1c\nMoHbQa37ewLFbtWcMFKuFg==\n-----END PRIVATE KEY-----\n",
  "client_email": "sheetservice@multilanguage-366800.iam.gserviceaccount.com",
  "client_id": "114930673930408836190",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sheetservice%40multilanguage-366800.iam.gserviceaccount.com"
}
''';

Future<void> googleMultiLanguageSheetAppendRow(List<String> values) async {
  try {
    bool found = false;
    for (var i = 1; i < global.languageSystemCode.length; i++) {
      if (global.languageSystemCode[i].code == values[1]) {
        found = true;
        break;
      }
    }
    if (found == false) {
      global.languageSystemCode.add(
        LanguageSystemCodeModel(
          code: values[1],
          langs: [],
        ),
      );
      final gsheets = GSheets(googleCredentials);
      final spreadsheet = await gsheets.spreadsheet("1HpttLpbcDTHCBhPWw1tuiLmsoap1LFgPS94JarThNoU");
      Worksheet sheet = spreadsheet.worksheetByTitle("pos_language")!;
      await sheet.values.appendRow(values);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> googleMultiLanguageSheetLoad() async {
  try {
    final gsheets = GSheets(googleCredentials);
    final spreadsheet = await gsheets.spreadsheet("1HpttLpbcDTHCBhPWw1tuiLmsoap1LFgPS94JarThNoU");
    Worksheet sheet = spreadsheet.worksheetByTitle("pos_language")!;
    print('Google Sheet Successfully Load');
    global.languageSystemCode = [];
    final values = await sheet.values.allRows();
    for (var i = 0; i < values.length; i++) {
      global.googleLanguageCode.add(values[i][1]);
      int index = 2;
      String thaiText = (index < values[i].length) ? values[i][index++] : "";
      String laoTextAuto = (index < values[i].length) ? values[i][index++] : "";
      String laoTextManual = (index < values[i].length) ? values[i][index++] : "";
      String engTextAuto = (index < values[i].length) ? values[i][index++] : "";
      String engTextManual = (index < values[i].length) ? values[i][index++] : "";
      String zhTextAuto = (index < values[i].length) ? values[i][index++] : "";
      String zhTextManual = (index < values[i].length) ? values[i][index++] : "";
      List<LanguageSystemModel> languageList = [];
      languageList.add(LanguageSystemModel(
        code: 'th',
        text: thaiText,
      ));
      languageList.add(LanguageSystemModel(
        code: 'lo',
        text: (laoTextManual.trim().isEmpty) ? laoTextAuto : laoTextManual,
      ));
      languageList.add(LanguageSystemModel(
        code: 'en',
        text: (engTextManual.trim().isEmpty) ? engTextAuto : engTextManual,
      ));
      languageList.add(LanguageSystemModel(
        code: 'cn',
        text: (zhTextManual.trim().isEmpty) ? zhTextAuto : zhTextManual,
      ));
      global.languageSystemCode.add(
        LanguageSystemCodeModel(
          code: values[i][1],
          langs: languageList,
        ),
      );
    }
  } catch (e) {
    print(e);
  }
}

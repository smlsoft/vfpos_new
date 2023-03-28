import 'package:dedepos/api/sync/api/api_barcode_model.dart';

abstract class BarcodeRepository {
  Future<List<ApiBarcodeResultModel>> getArticles();
}

class BarcodeRepositoryImpl implements BarcodeRepository {
  @override
  Future<List<ApiBarcodeResultModel>> getArticles() async {
    /*var response = await http.get('AppStrings.cricArticleUrl');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<ApiBarcodeResultModel> articles = ApiBarcodeResultModel.fromJson(data).articles;
      return articles;
    } else {
      throw Exception();
    }*/
    return [];
  }
}

import 'package:dedepos/core/request.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/features/shop/data/datasource/shop_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  late ShopRemoteRepository shopRemoteRepository;
  setUpAll(() {
    String token = fixture('token.txt');
    serviceLocator.registerSingleton<Request>(Request());
    serviceLocator<Request>().updateAuthorization(token);
    shopRemoteRepository = ShopRemoteRepositoryImpl();
  });

  tearDownAll(() async {
    await serviceLocator.reset(dispose: true);
  });

  test('test List shop', () async {
    final response = await shopRemoteRepository.listMyShop();
    expect(response.isRight(), true);
  });

  test('select-shop', () async {
    final response = await shopRemoteRepository.selectShop(
        id: "28xnrybbglb9R6D6bkMadDTSmTz");
    expect(response.isRight(), true);
  });
}

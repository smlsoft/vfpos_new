import 'package:auto_route/auto_route.dart';
import 'package:dedepos/app/app.dart';
import 'package:dedepos/features/dashboard/presentation/widgets/dashboard_menu_item.dart';
import 'package:dedepos/features/dashboard/presentation/widgets/top_bar_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBarShop(height: 250),
            // Center(
            //   child: Text('xxxxxxxx'),
            // ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.point_of_sale,
                        title: 'POS',
                        callBack: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.payments,
                        title: 'รับเงินทอน',
                        callBack: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.monetization_on,
                        title: 'ส่งยอดขาย',
                        callBack: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.text_snippet,
                        title: 'พิมพ์สำเนาใบเสร็จ',
                        callBack: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.add,
                        title: 'ยกเลิกใบเสร็จ',
                        callBack: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.repartition,
                        title: 'คืนสินค้า',
                        callBack: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ItemMenuDashboard(
                        icon: Icons.receipt,
                        title: 'พิมพ์ใบกำกับภาษี (แบบเต็ม)',
                        callBack: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

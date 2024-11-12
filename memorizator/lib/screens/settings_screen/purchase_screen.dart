import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  void handlePurchase(BuildContext context, ProductDetails product) async {
    try {
      // Инициируем процесс покупки
      Provider.of<PurchaseProvider>(context, listen: false).buyProduct(product);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Consumer<PurchaseProvider>(
              builder: (context, provider, child) {
            return AlertDialog(
              content: Row(
                children: [
                  Visibility(
                    visible: Provider.of<PurchaseProvider>(context)
                        .purchaseProcessing,
                    child: const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  Text(Provider.of<PurchaseProvider>(context).purchaseMessage)
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Закрыть'),
                ),
              ],
            );
          });
        },
      );
    } catch (e) {
      Navigator.pop(context); // Закрываем диалог с индикатором
      print('Error initiating purchase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final purchaseProvider = Provider.of<PurchaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).supportTheApp),
        foregroundColor: aWhite,
        backgroundColor: aBlue,
      ),
      key: UniqueKey(),
      backgroundColor: aLightBlue,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                textAlign: TextAlign.center,
                S.of(context).supportUsByRemovingTheAds,
                style: const TextStyle(
                    color: aBlue, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: purchaseProvider.isAvailable
                  ? ListView.builder(
                      itemCount: purchaseProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = purchaseProvider.products[index];
                        return Container(
                          padding: const EdgeInsets.all(20),
                          margin:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          decoration: BoxDecoration(
                              color: aWhite,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(product.title),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(product.price.trim()),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      style: myButtonStyle,
                                      onPressed: () =>
                                          handlePurchase(context, product),
                                      //purchaseProvider.buyProduct(product),
                                      child: const Icon(
                                          Icons.shopping_cart_outlined),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(S
                          .of(context)
                          .theStoreIsUnavailableCheckTheConnection),
                    ),
            ),
            Container(
              color: aWhite,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(8),
              child: const Text(
                textAlign: TextAlign.center,
                'Thank you for supporting our development! Your contribution helps us continue to improve this app.',
                style: TextStyle(color: aBlue, fontWeight: FontWeight.bold),
              ),
            ),
            Text('isPaidUser = ${purchaseProvider.isPaidUser}'),
          ],
        ),
      ),
    );
  }
}

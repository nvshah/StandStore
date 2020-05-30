import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Establish direct communication channel to the provider instance of Product class
    //Infact this will return the instance of that Provider Class mentioned in Generuc type T
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    // Note - It's ok we are still using ProductItem() with params as it is intact & not required unnecessary parameter forwarding
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      //We have different provider for every product item  // & we've create this provider for favorite tracking
      itemBuilder: (ctxt, i) => ChangeNotifierProvider(
        create: (ctxt) => products[i],
        child: ProductItem(
          // id: products[i].id,
          // title: products[i].title,
          // imageUrl: products[i].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

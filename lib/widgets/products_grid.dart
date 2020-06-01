import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavsOnly;

  ProductsGrid(this.showFavsOnly);

  @override
  Widget build(BuildContext context) {
    //Establish direct communication channel to the provider instance of Product class
    //Infact this will return the instance of that Provider Class mentioned in Generuc type T
    final productsData = Provider.of<Products>(context);
    //filtered data source for grid contents
    final products = showFavsOnly ? productsData.favoriteItems : productsData.items;

    // Note - It's ok we are still using ProductItem() with params as it is intact & not required unnecessary parameter forwarding
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      //We have different provider for every product item  // & we've create this provider for is_favorite tracking
      itemBuilder: (ctxt, i) => ChangeNotifierProvider.value(
        //create: (ctxt) => products[i],
        //Here we are using ChangeNotifierProvider.value() as we are not using ctxt passed while attaching provider
        //So using this approach by providing provider instance in value argument & using .value constructor
        //There will no problem of Widget Recycling i.e that happen while using ListView or GridView
        //using ChangeNotifierProvider.value for Provider in List or Grid will ensure that no Recycling happens
        value: products[i],
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

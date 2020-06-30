import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  // this method is used for RefreshIndicator widget, basically meant for fetching the product from server
  Future<void> _refreshProducts(BuildContext context) async {
    //here listen:false is necessary otherwise infinite loop problem will arrived
    //fetch the product belonging to current client
    await Provider.of<Products>(context, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //Inorder to avoid Infinite loop
    // //We wnat to rebuild the state when Products added or removed or edited
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      //As we want to load first the products based on the clients when we reach this screen so We call refreshProducts initially
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctxt, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                  //Till we fetch the client products
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    //this will show spinner when you pull down on the screen, until the products are retrievd from the server
                    onRefresh: () => _refreshProducts(context),
                    //Re-build only the products Listview container
                    child: Consumer<Products>(
                      builder: (ctxt, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UserProductItem(
                                productsData.items[i].id,
                                productsData.items[i].title,
                                productsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

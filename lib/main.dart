import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './screens/product_details_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //This allows to register a class so that we can listen in child widgets; so this make it a Provider
    //Only child widget which are listening will rebuild
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          //Same instance of provider for all child wdgets that are listening
          //NOTE - In earlier version instead of create, builder argument was used to create provider instance
          //create: (ctxt) => Products(),
          //Here we are not using any context so utilising ChangeNotifierProvider.value
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          //As cart is also being used at multiple screen in out app so it's provider is managed at root level here
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          //As Order is used at Cart Screen so it's been attached as provider over here; Now we can listen to Order anyWhere from application
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctxt) => ProductDetailsScreen(),
          CartScreen.routeName: (ctxt) => CartScreen(),
          OrdersScreen.routeName: (ctxt) => OrdersScreen(),
          UserProductsScreen.routeName: (ctxt) => UserProductsScreen(),
        },
      ),
    );
  }
}

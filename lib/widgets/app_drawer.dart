import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Drawer that comes sliding & background color setting automatic
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text('Holla Yo'),
          //back button shouldn't work here, so don't show back button
          automaticallyImplyLeading: false,
        ),
        //Horizontal line
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: (){
            //Home page transition
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: (){
            //Home page transition
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: (){
            //Manage Products page transition
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('logout'),
          onTap: (){
            //close the drawer before logout happens
            Navigator.of(context).pop();
            //always go to auth screen on logout
            Navigator.of(context).pushReplacementNamed('/');
            //logout the user
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],),
    );
  }
}
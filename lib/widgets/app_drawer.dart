import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

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
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: (){
            //Home page transition
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
      ],),
    );
  }
}
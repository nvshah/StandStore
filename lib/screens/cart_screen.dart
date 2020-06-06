import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//As we're only using Cart class of cart.dart
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
//import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    //listening to changes 
    final cart = Provider.of<Cart>(context);

    final cartItemsList = cart.items.values.toList();
    final cartItemsKeyList = cart.items.keys.toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  //This will take as much space it can take
                  //So Text will be on left LHS & total amount & order button on RHS
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(child: Text('Order Now'), onPressed: (){},),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctxt, i) => CartItem(
                id: cartItemsList[i].id,
                title: cartItemsList[i].title,
                price: cartItemsList[i].price,
                quantity: cartItemsList[i].quantity,
                productId: cartItemsKeyList[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    //On Swipe item will disappear so using Dismissible widget
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      //Only when it will be swipe from right to left, item will be deleted
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      //If confirmDismiss is true then only onDismissed will execute
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctxt) => AlertDialog(
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove the item from the cart ?'),
            actions: <Widget>[
              FlatButton(child: Text('No'), onPressed: () => Navigator.of(ctxt).pop(false)),
              FlatButton(child: Text('Yes'), onPressed: () => Navigator.of(ctxt).pop(true))
            ],
          )
        );
      },
      //CARD -> Item details
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          //LIST-TILE <- item details
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Totat: \$${(quantity * price)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}

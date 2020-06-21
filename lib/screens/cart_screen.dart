import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//As we're only using Cart class of cart.dart
//import '../providers/cart.dart' show Cart;
import '../providers/cart.dart' show Cart, CartItem;
import '../widgets/cart_item.dart' as cartwidget;
//import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

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
          //CART OVERVIEW
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //TOTAL PRICE LABEL
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  //This will take as much space it can take
                  //So Text will be on left LHS & total amount & order button on RHS
                  Spacer(),
                  //TOTAL PRICE AMOUNT
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  //ORDER BUTTON
                  OrderButton(cart: cart, cartItemsList: cartItemsList),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //LIST OF ITEMS IN CART
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctxt, i) => cartwidget.CartItem(
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

//As we want to show loading so extracted FlatButton for add order inorder to improve re-build
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.cartItemsList,
  }) : super(key: key);

  final Cart cart;
  final List<CartItem> cartItemsList;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      //disable button on matching either requirements
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              //add the order
              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cartItemsList, widget.cart.totalPrice);

              setState(() {
                _isLoading = false;
              });

              //clear the cart
              widget.cart.clear();
            },
    );
  }
}

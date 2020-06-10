import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  //Mapped productId with CartItem
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  double get totalPrice{
    double total = 0;
    _items.forEach((key, cartItem){
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      //_items[productId].quantity = _items[productId].quantity + 1;
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    //after adding item as this is provider always trigger notifier for listeners
    notifyListeners();
  }

  //Remve the item from the cart item's list
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  //remove the single item from quantities from item list
  void removeSingleItem(String productId){
    //if item is not present in list
    if(!_items.containsKey(productId)){
      return;
    }
    //if more than 1 quantity is present of item
    if(_items[productId].quantity > 1){
      _items.update(productId, (currentItem) => CartItem(
        id: currentItem.id,
        title: currentItem.title,
        price: currentItem.price,
        quantity: currentItem.quantity - 1,
      ));
    }
    else{
      //There is only 1 quantity of item in cart so remove it
      _items.remove(productId);
    }
    notifyListeners();
  }

  //clear the cart
  void clear()
  {
    _items = {};
    notifyListeners();
  }
}

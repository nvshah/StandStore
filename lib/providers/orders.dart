import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    final url = 'https://flutter-demo-e4fa6.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if(extractedData == null){
        return;
      }

      //get all orders in the format according to OrderItem Blueprint
      extractedData.forEach((orderId, orderData) {
        //Re-create Loaded orders
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
        ));
      });
      //newest order first
      _orders = loadedOrders.reversed.toList();
      notifyListeners();

    } catch (error) {}
  }

  //Add the order to the order list
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-demo-e4fa6.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      //add order  at the server
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));

      //Add Most recent order at the beginnig of the list, locally
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {}
  }
}

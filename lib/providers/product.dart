import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//Product as provider for now is jus meant tro track for favorite status of product
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  
  void _setFavValue(bool value){
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken) async {
    final url =
        'https://flutter-demo-e4fa6.firebaseio.com/products/$id.json?auth=$authToken';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      //Inform server to update isFav value
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      //Something went wrong & operation was not perfromed at server side so undo changes
      if(response.statusCode >= 400){
        _setFavValue(oldStatus);
      }
    } catch (error) {
      //If there is any particular error while updating data from server then undo the local value
      _setFavValue(oldStatus);
    }
  }
}

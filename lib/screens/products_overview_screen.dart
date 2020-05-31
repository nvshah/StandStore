import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterOptions{
  Favorites,
  All,
}
class ProductsOverviewScreen extends StatefulWidget {
  
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            //OPTIONS
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
            ],
            //ICON
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue){
              if(selectedValue == FilterOptions.Favorites){
                _showOnlyFavorites = true;
              }
              else{
                _showOnlyFavorites = false;
              }
            },
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}


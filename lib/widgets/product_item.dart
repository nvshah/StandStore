import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    //this will re-build the ProductItem when any of the data of any Product Item (that is listening) Changes
    //Here Provider.of() always trigger the build method so we are not listening for entire widget
    final product = Provider.of<Product>(context, listen: false);
    print("product rebuilds");
    //ClipRRect is used when we want to change the type of corner to circular
    //As GridTile do not have any property to define the circular border, We have to use ClipRRect
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        //We are using gesture detector becuase we do not have onTap property for Image widget
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          //Consumer so that only icon-favorite will be update & re-build
          //Always listens to changes
          leading: Consumer<Product>(
            //(ctxt, product, child) <- here we won't require child for now as
            // there are no part of IconButton which remains constant even when new updates from provider arrives
            builder: (ctxt, product, _) => IconButton(
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
            //child: Text('when we require to pass child argument in builder value')
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

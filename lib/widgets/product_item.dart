import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

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
    //nearest access to object of Product()
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    print("product rebuilds");
    //ClipRRect is used when we want to change the type of corner to circular
    //As GridTile do not have any property to define the circular border, We have to use ClipRRect
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //IMAGE PRODUCT
      child: GridTile(
        //We are using gesture detector becuase we do not have onTap property for Image widget
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
          //Placeholder images before imgages get loaded from network & fit into the position
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          //PRODUCT TITLE
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
              //FAVORITE BUTTON
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
              color: Theme.of(context).accentColor,
            ),
            //child: Text('when we require to pass child argument in builder value')
          ),
          trailing: IconButton(
            //SHOPPING CART BUTTON
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              //to avoid undesired result on simultaneous press,
              Scaffold.of(context).hideCurrentSnackBar();
              //this will establish connection to scaffold of product_overview page
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart !'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

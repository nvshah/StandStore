import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //IMAGE
      leading: CircleAvatar(
        //Here CircleAvatar will manage the size of image to fit
        backgroundImage: NetworkImage(imgUrl),
      ),
      //TITLE
      title: Text(title),
      //OPTIONS (User interactions)
      trailing: Container(
        //As here trailing contains row & row grows as much as it can so there will be problem of size
        //So We need to provide fixed width
        width: 100,
        child: Row(
          children: <Widget>[
            //EDIT PRODUCT
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            //DELETE PRODUCT
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                Provider.of<Products>(context, listen:false).removeProduct(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

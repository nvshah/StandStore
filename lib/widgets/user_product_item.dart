import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imgUrl;

  UserProductItem(this.title, this.imgUrl);

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
            IconButton(icon: Icon(Icons.edit), color: Theme.of(context).primaryColor, onPressed: (){},),
            IconButton(icon: Icon(Icons.delete), color: Theme.of(context).errorColor, onPressed: (){},),
          ],
        ),
      ),
    );
  }
}
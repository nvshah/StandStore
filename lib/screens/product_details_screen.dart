import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    //This runs a listener which hears to provider for change
    //Here on detail page we don't want to rebuild this Wiget whenever any new product is added or deleted
    //So we just want info from global for one time only, & then our listener over here needs to become inactive
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      // body: SingleChildScrollView(
      body: CustomScrollView(
        slivers: <Widget>[
          //This will get hide when SliverList part will be scrolled up
          // This will get seen or started visible when we start dragging SliverList part down
          SliverAppBar(
            expandedHeight: 300,
            //Appbar will always be visible, It will not scroll out of view instead it will change to appbar & stick at a top &
            //rest of the content can scroll beneath that
            pinned: true,
            //This will be flexible
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              //Image will be seen if appbar expanded
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          //Below Widget will be Independently scrollable under CustomScrollableView
          SliverList(
            //So below will be independently scrollable under the CustomScrollView
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                //PRICE
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                //DESCRIPTION
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //     //IMAGE
        //     Container(
        //       height: 300,
        //       width: double.infinity,
        //       child: Hero(
        //         tag: loadedProduct.id,
        //         child: Image.network(
        //           loadedProduct.imageUrl,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

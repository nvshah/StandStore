import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  //var _isLoading = false;

  // //Runs once when screen gets rendered
  // @override
  // void initState() {
  //   // //Kind of hack, here code inside Future.delayed() will get queued up at last
  //   // Future.delayed(Duration.zero).then((_) async {
  //   //   setState(() {
  //   //     _isLoading = true;
  //   //   });
  //   //   //wait till all orders are fetched from server
  //   //   await Provider.of<Orders>(context, listen: false).fetchOrder();
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   // });

  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchOrder().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('building orders ...');
    //Inorder to avoid Infinite loop
    //final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrder(),
        //dataSnapShot is value that will be recieved in future
        builder: (ctxt, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.error != null) {
            return Center(
              child: Text('Something goes Wrong !'),
            );
          } else {
            //Here we are using Consumer Inorder to avoid Infinite loop created by FutureBuilder & Provider.of()
            //Only re-build parts that requires re-building
            return Consumer<Orders>(
              builder: (ctxt, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctxt, i) => OrderItem(orderData.orders[i]),
              ),
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

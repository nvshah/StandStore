import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as pror;

class OrderItem extends StatefulWidget {
  final pror.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            //ORDER AMOUNT
            title: Text('\$${widget.order.amount}'),
            //ORDER DATE
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            //SEE ALL PRODUCTS OVERVIEW
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          //If expanded is click then expand the section to show product overview of that order
          if (_expanded)
            //ALL PRODUCTS GIST of ORDER
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          //PRODUCT NAME on LHS, PRODUCTA QUANTITY & PRICE on RHS 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //PRODUCT TITLE
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //PRICE & QUNATITY
                            Text(
                              '${prod.quantity} x  \$${prod.price}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

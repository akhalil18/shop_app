import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.orderCost.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: Text(
              DateFormat.yMMMd().add_jm().format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              height: min(widget.order.products.length * 20.0 + 10, 100.0),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(color: Colors.red),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '${prod.quantity}',
                                ),
                                TextSpan(
                                  text: '  x  ',
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(text: '\$${prod.price}'),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

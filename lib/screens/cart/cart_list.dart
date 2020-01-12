import 'package:flutter/material.dart';

class CartList extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final Function delItem;
  // final String produtId;
  CartList(
    this.id,
    this.price,
    this.quantity,
    this.title,
    this.delItem,
    // this.produtId,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 30.0),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete_forever,
          size: 50,
          color: Colors.black,
        ),
      ),
      // onDismissed: (direction) => delItem(produtId),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Delet Item !',
              style: TextStyle(
                color: Theme.of(context).errorColor,
              ),
            ),
            content: Text('Are you sure you want to delete this item ?'),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => delItem(id),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).accentColor),
              padding: EdgeInsets.all(8.0),
              child: Text('\$$price'),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            subtitle: Text('Total: \$${(quantity * price).toStringAsFixed(1)}'),
            trailing: Text(
              '$quantity x',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

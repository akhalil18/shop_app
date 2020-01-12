import 'package:flutter/material.dart';
import '../edit_product/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrel;
  final String title;
  UserProductItem(this.imageUrel, this.title, this.id);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrel),
        ),
        trailing: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeId, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (ctx) => ConfirmDialog(),
                  ).then((value) {
                    if (value) {
                      Provider.of<Products>(context, listen: false)
                          .deleteProduct(id)
                          .catchError(
                            (e) => scaffold.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Deleting faild',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Delet Item !',
        style: TextStyle(
          color: Theme.of(context).errorColor,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}

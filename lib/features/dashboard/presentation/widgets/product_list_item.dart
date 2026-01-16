import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../screens/product_form_screen.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductFormScreen(product: product),
            ),
          );
        },
      ),
    );
  }
}

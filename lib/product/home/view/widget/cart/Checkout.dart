import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticaret/Products.dart';
import 'package:eticaret/product/home/cubit/CheckoutCubit.dart';

class Check extends StatefulWidget {
  const Check({Key? key}) : super(key: key);

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  void initState() {
    super.initState();
    context.read<CheckOut>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepet"),
      ),
      body: BlocBuilder<CheckOut, Map<Products, int>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text("Sepet boş"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems.keys.elementAt(index);
                    final quantity = cartItems.values.elementAt(index);

                    return Card(
                      color: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product.images.isNotEmpty
                                  ? Image.network(
                                product.images.first,
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 60,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? "Ürün",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.category?.name ?? "Kategori",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Fiyat: \$${((product.price ?? 0) * quantity).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.black),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  context.read<CheckOut>().removeCart(product);
                                                },
                                                icon: const Icon(Icons.remove, size: 20),
                                                iconSize: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              quantity.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.black),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  context.read<CheckOut>().addCart(product);
                                                },
                                                icon: const Icon(Icons.add, size: 20),
                                                iconSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Toplam:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder<double>(
                          future: context.read<CheckOut>().getTotalPrice(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "\$${snapshot.data!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                            return const Text(
                              "\$0.00",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 327,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          context.read<CheckOut>().clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Satın alındı.")),
                          );
                        },
                        child: const Text("Satın Al"),
                      ),

                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
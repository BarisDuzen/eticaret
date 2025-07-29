import 'package:eticaret/product/home/cubits/CheckoutCubit.dart';
import 'package:eticaret/product/home/views/Checkout.dart';
import 'package:flutter/material.dart';
import 'package:eticaret/Products.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticaret/product/home/cubits/FavouriteCubit.dart';

class Detail extends StatefulWidget {
  final Products product;

  const Detail({Key? key, required this.product}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int number = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.product.images.first,
                        height: 360,
                        fit: BoxFit.cover,
                        width: 320,
                      ),
                    ),
                    // Geri dönme butonu
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    // Kalp butonu
                    Positioned(
                      top: 10,
                      left: 260,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {
                            context.read<FavouriteCubit>().addFavourite(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Favorilere eklendi")));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.title ?? "Başlık Yok",
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: "EncodeSans"),
              ),
              const SizedBox(height: 8),
              Text(
                (widget.product.description != null &&
                    widget.product.description!.isNotEmpty)
                    ? widget.product.description!
                    : "Açıklama yok",
                style: const TextStyle(
                    color: Colors.black, fontFamily: "EncodeSans", fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                "\$ ${widget.product.price}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (number > 1) {
                            --number;
                          }
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    number.toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          ++number;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: 320,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.black,
                ),
                child: TextButton(
                  onPressed: () {
                    for (int i = 0; i < number; i++) {
                      context.read<CheckOut>().addMultipleToCart(widget.product, number);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Check()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 29,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Add To Cart | \$ ${(widget.product.price!) * number}",
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

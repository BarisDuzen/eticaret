import 'package:eticaret/Products.dart';
import 'package:eticaret/product/home/cubits/FavouriteCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Detail.dart';

class Favourites extends StatefulWidget {
      const Favourites({super.key});

      @override
      State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

      void initState() {
            super.initState();

            context.read<FavouriteCubit>().loadFavourites();
      }

      @override
      Widget build(BuildContext context) {
            return Scaffold(
                  appBar: AppBar(title: Center(child: Text("Favoriler",)),),
                  body: BlocBuilder<FavouriteCubit, List<Products>>(
                        builder: (context, sonuc) {
                              if (sonuc.isEmpty) {
                                    return const Center(child: Text("Hiç favoriniz yok"));
                              }

                              return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ListView.builder(
                                          itemCount: sonuc.length,
                                          itemBuilder: (context, index) {
                                                final product = sonuc[index];
                                                return GestureDetector(
                                                      onTap: () {
                                                            Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                        builder: (context) => Detail(product: product),
                                                                  ),
                                                            );
                                                      },
                                                      child: Card(
                                                            color: Colors.transparent,
                                                            elevation: 0,
                                                            margin: const EdgeInsets.only(bottom: 16),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                            child: Container(
                                                                  height: 120,
                                                                  child: Row(
                                                                        children: [
                                                                              ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                    child: Image.network(
                                                                                          product.images.first,
                                                                                          height: 120,
                                                                                          width: 120,
                                                                                          fit: BoxFit.cover,
                                                                                    ),
                                                                              ),
                                                                              const SizedBox(width: 16),

                                                                              Expanded(
                                                                                    child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                          child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                      Column(
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                                  Text(
                                                                                                                        product.title ?? "Başlık Yok",
                                                                                                                        maxLines: 2,
                                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                                        style: const TextStyle(
                                                                                                                              fontSize: 18,
                                                                                                                              fontWeight: FontWeight.bold,
                                                                                                                              fontFamily: "EncodeSans",
                                                                                                                        ),
                                                                                                                  ),
                                                                                                                  const SizedBox(height: 4),
                                                                                                                  Text(
                                                                                                                        product.category?.name ?? "Kategori Yok",
                                                                                                                        style: TextStyle(
                                                                                                                              fontSize: 14,
                                                                                                                              color: Colors.grey[600],
                                                                                                                              fontFamily: "EncodeSans",
                                                                                                                        ),
                                                                                                                  ),
                                                                                                            ],
                                                                                                      ),
                                                                                                      Text(
                                                                                                            '\$ ${product.price}',
                                                                                                            style: const TextStyle(
                                                                                                                  fontSize: 16,
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  fontFamily: "EncodeSans",
                                                                                                            ),
                                                                                                      ),
                                                                                                ],
                                                                                          ),
                                                                                    ),
                                                                              ),
                                                                        ],
                                                                  ),
                                                            ),
                                                      ),
                                                );
                                          },
                                    ),
                              );
                        },
                  ),
            );
      }
}
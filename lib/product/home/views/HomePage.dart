import 'package:eticaret/data/repo/Auth.dart';
import 'package:eticaret/product/home/cubits/FavouriteCubit.dart';
import 'package:eticaret/product/home/cubits/HomepageCubit.dart';
import 'package:eticaret/product/home/views/Detail.dart';
import 'package:eticaret/product/home/views/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticaret/Products.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username = '';

  @override
  void initState() {
    super.initState();

    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    username = email.split('@').first;

    context.read<HomeCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Merhaba,Hoşgeldin"),
                      Text("$username",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                IconButton(onPressed: (){
                  Auth().singOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );

                }, icon: Icon(Icons.output,size: 40,color: Colors.blue,)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 263,height: 48,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Ürün Ara',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white,width: 2),

                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        prefixIcon: Icon(Icons.search,color: Colors.grey,),
                      ),
                      onChanged: (value) {
                        context.read<HomeCubit>().searchProducts(value);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                IconButton(onPressed: (){

                }, icon: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color:Colors.black,),child: SizedBox(width:48,height:48,child: Padding(

                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('icons/ccc.png',color: Colors.white,width: 24,height: 24,),
                ))),)
              ],
            ),

            Expanded(
              child: BlocBuilder<HomeCubit, List<Products>>(
                builder: (context, sonuc) {
                  return GridView.builder(
                    itemCount: sonuc.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.4,
                    ),
                    itemBuilder: (context, index) {
                      final product = sonuc[index];
                      return GestureDetector(
                        onTap: (){
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                                    child: Image.network(
                                      product.images.first,
                                      height: 230,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(10),
                                        backgroundColor: Colors.black54,
                                        elevation: 5,
                                      ),
                                      onPressed: () {
                                        context.read<FavouriteCubit>().addFavourite(product);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Favorilere eklendi")));
                                      },
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title ?? "Başlık Yok",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "EncodeSans"),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category?.name ?? "Kategori Yok",
                                      style: TextStyle(fontSize: 15, color: Colors.grey[600], fontFamily: "EncodeSans"),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$ ${product.price}',
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontFamily: "EncodeSans"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      );
                    },
                  );
                },
              ),
            )


          ],
        ),
      ),

    );
  }
}
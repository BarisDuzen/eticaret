import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:eticaret/Products.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetRepo{
  bool isLoading = false;
  final Dio _dio = Dio();
  List<Products> products=[];
  Map<Products, int> _cartItems = {};
  List<Products> favourite=[];

  Future<List<Products>> fetchProducts() async {
    try {
      final response = await _dio.get('https://api.escuelajs.co/api/v1/products');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<Products> products = jsonData.map((json) => Products.fromJson(json)).toList();
        return products;
      } else {
        print('Hata: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('API Hatası: $e');
      return [];
    }
  }

  Future<List<Products>> searchProducts(String query) async {
    try {
      final response = await _dio.get('https://api.escuelajs.co/api/v1/products');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        List<Products> allProducts = jsonData.map((json) => Products.fromJson(json)).toList();
        final filtered = allProducts.where((p) =>
        p.title != null && p.title!.toLowerCase().contains(query.toLowerCase())
        ).toList();

        return filtered;
      } else {
        return [];
      }
    } catch (e) {
      print('Search API Hatası: $e');
      return [];
    }
  }

  // Sepete ekleme - Firestore
  Future<void> addToCart(Products product) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString());

      final doc = await cartRef.get();

      if (doc.exists) {
        // Ürün zaten sepette varsa miktarını artır
        final currentQuantity = doc.data()?['quantity'] ?? 1;
        await cartRef.update({
          'quantity': currentQuantity + 1,
        });
      } else {
        // Ürün sepette yoksa ekle
        final cartItem = product.toMap();
        cartItem['quantity'] = 1;
        await cartRef.set(cartItem);
      }
    } catch (e) {
      print('Sepete eklenirken hata: $e');
    }
  }

  // Sepetten çıkarma - Firestore
  Future<void> removeFromCart(Products product) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id.toString());

      final doc = await cartRef.get();

      if (doc.exists) {
        final currentQuantity = doc.data()?['quantity'] ?? 1;

        if (currentQuantity > 1) {
          // Miktar 1'den fazlaysa azalt
          await cartRef.update({
            'quantity': currentQuantity - 1,
          });
        } else {
          // Miktar 1'se ürünü sepetten tamamen çıkar
          await cartRef.delete();
        }
      }
    } catch (e) {
      print('Sepetten çıkarılırken hata: $e');
    }
  }

  // Sepet içeriğini getir - Firestore
  Future<Map<Products, int>> getCartItems() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      Map<Products, int> cartItems = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final product = Products.fromMap(data);
        final quantity = data['quantity'] ?? 1;
        cartItems[product] = quantity;
      }

      return cartItems;
    } catch (e) {
      print('Sepet yüklenirken hata: $e');
      return {};
    }
  }

  // Sepeti temizle - Firestore
  Future<void> clearCart() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final batch = FirebaseFirestore.instance.batch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Sepet temizlenirken hata: $e');
    }
  }

  Future<double> getTotalPrice() async {
    try {
      final cartItems = await getCartItems();
      double total = 0.0;

      for (var entry in cartItems.entries) {
        final price = entry.key.price ?? 0;
        total += price.toDouble() * entry.value;
      }

      return total;
    } catch (e) {
      print('Toplam fiyat hesaplanırken hata: $e');
      return 0.0;
    }
  }

  // Favoriler
  Future<void> addFavourite(Products product) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(product.id.toString())
        .set(product.toMap());
  }

  Future<void> removeFavourite(Products product) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(product.id.toString())
        .delete();
  }

  Future<List<Products>> getFavourites() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .get();

      List<Products> favourites = [];
      for (var doc in querySnapshot.docs) {
        favourites.add(Products.fromMap(doc.data()));
      }

      return favourites;
    } catch (e) {
      print('Favoriler yüklenirken hata: $e');
      return [];
    }
  }

  Future<void> addToCartWithQuantity(Products product, int quantityToAdd) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(product.id.toString());

    final doc = await cartRef.get();

    if (doc.exists) {
      final currentQuantity = doc.data()?['quantity'] ?? 1;
      await cartRef.update({
        'quantity': currentQuantity + quantityToAdd,
      });
    } else {
      final cartItem = product.toMap();
      cartItem['quantity'] = quantityToAdd;
      await cartRef.set(cartItem);
    }
  }

}
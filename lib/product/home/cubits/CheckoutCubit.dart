import 'package:eticaret/Products.dart';
import 'package:eticaret/data/repo/GetRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOut extends Cubit<Map<Products, int>> {
  final GetRepo repo = GetRepo();

  CheckOut() : super({});


  void loadCart() async {
    try {
      final cartItems = await repo.getCartItems();
      emit(cartItems);
    } catch (e) {
      print('Sepet yüklenirken hata: $e');
      emit({});
    }
  }

  // Sepete ekle
  void addCart(Products product) async {
    try {
      await repo.addToCart(product);
      final cartItems = await repo.getCartItems();
      emit(Map<Products, int>.from(cartItems));
    } catch (e) {
      print('Sepete eklenirken hata: $e');
    }
  }

  // Sepetten çıkar
  void removeCart(Products product) async {
    try {
      await repo.removeFromCart(product);
      final cartItems = await repo.getCartItems();
      emit(Map<Products, int>.from(cartItems));
    } catch (e) {
      print('Sepetten çıkarılırken hata: $e');
    }
  }

  // Sepeti temizle
  void clearCart() async {
    try {
      await repo.clearCart();
      emit({});
    } catch (e) {
      print('Sepet temizlenirken hata: $e');
    }
  }

  // Toplam fiyatı getir
  Future<double> getTotalPrice() async {
    try {
      return await repo.getTotalPrice();
    } catch (e) {
      print('Toplam fiyat hesaplanırken hata: $e');
      return 0.0;
    }
  }

  Future<void> addMultipleToCart(Products product, int quantity) async {
    try {
      await repo.addToCartWithQuantity(product, quantity);
      final cartItems = await repo.getCartItems();
      emit(cartItems);
    } catch (e) {
      print('Toplu ekleme hatası: $e');
    }
  }

}
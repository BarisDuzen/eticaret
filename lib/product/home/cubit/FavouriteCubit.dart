import 'package:eticaret/Products.dart';
import 'package:eticaret/data/repo/GetRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteCubit extends Cubit<List<Products>>{

  FavouriteCubit():super([]);
  GetRepo repo = GetRepo();


  void loadFavourites() async {
    try {
      final favourites = await repo.getFavourites();
      emit(favourites);
    } catch (e) {
      print('Favoriler yüklenirken hata: $e');
      emit([]);
    }
  }

  void addFavourite(Products product) async {
    try {
      await repo.addFavourite(product);

      final favourites = await repo.getFavourites();
      emit(favourites);
    } catch (e) {
      print('Favoriye eklenirken hata: $e');
    }
  }


}
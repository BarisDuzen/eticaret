import 'package:eticaret/product/home/view/widget/cart/Checkout.dart';
import 'package:eticaret/product/home/view/widget/favourites/Favourites.dart';
import 'package:eticaret/product/home/view/widget/homepage/HomePage.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  var Sayfalar = [HomePage(), Check(),Favourites()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Sayfalar[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (sayi) {
          setState(() {
            index = sayi;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset("assets/icons/Main.png", width: 24, height: 24),
                const SizedBox(height: 4),
                if (index == 0)
                  const Icon(Icons.circle, size: 6, color: Colors.red)
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Image.asset("assets/icons/shop.png", width: 24, height: 24),
                const SizedBox(height: 4),
                if (index == 1)
                  const Icon(Icons.circle, size: 6, color: Colors.red)
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.favorite,
                    color: index == 2 ? Colors.red : Colors.white),
                const SizedBox(height: 4),
                if (index == 2)
                  const Icon(Icons.circle, size: 6, color: Colors.red)
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

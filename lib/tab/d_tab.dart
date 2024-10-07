// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class DessertTab extends StatelessWidget {
  final List dessert = [
    ["Cookies", "assets/images/cookies.png", Colors.red],
    ["Cake", "assets/images/cake.png", Colors.blue],
    ["Chocolate", "assets/images/chocolate-bar.png", Colors.purple],
    ["Icecream", "assets/images/ice-cream.png", Colors.brown],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.75,
      ),
      itemCount: dessert.length,
      itemBuilder: (context, index) {
        return DessertTitle(
          ditems: dessert[index][0],
          imageName: dessert[index][1],
          additem: dessert[index][2],
        );
      },
    );
  }
}

class DessertTitle extends StatefulWidget {
  final String ditems;
  final String imageName;
  final Color additem;

  const DessertTitle({
    super.key,
    required this.ditems,
    required this.imageName,
    required this.additem,
  });

  @override
  _DessertTitleState createState() => _DessertTitleState();
}

class _DessertTitleState extends State<DessertTitle> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.additem.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.additem),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imageName,
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 10),
            Text(
              widget.ditems,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set the font color to black
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (itemCount > 0) itemCount--;
                    });
                  },
                ),
                Text(
                  itemCount.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      itemCount++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

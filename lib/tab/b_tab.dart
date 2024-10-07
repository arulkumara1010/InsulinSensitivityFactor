// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class BreakfastTab extends StatelessWidget {
  final List breakfast = [
    ["Dosa", "assets/images/masala-dosa.png", Colors.red],
    ["Idli", "assets/images/food.png", Colors.blue],
    ["Poori", "assets/images/poori.png", Colors.purple],
    ["Vada", "assets/images/vada.png", Colors.brown],
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
      itemCount: breakfast.length,
      itemBuilder: (context, index) {
        return BreakfastTitle(
          bitems: breakfast[index][0],
          imageName: breakfast[index][1],
          additem: breakfast[index][2],
        );
      },
    );
  }
}

class BreakfastTitle extends StatefulWidget {
  final String bitems;
  final String imageName;
  final Color additem;

  const BreakfastTitle({
    super.key,
    required this.bitems,
    required this.imageName,
    required this.additem,
  });

  @override
  _BreakfastTitleState createState() => _BreakfastTitleState();
}

class _BreakfastTitleState extends State<BreakfastTitle> {
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
              widget.bitems,
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

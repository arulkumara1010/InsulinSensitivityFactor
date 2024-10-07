// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class RiceTab extends StatelessWidget {
  final List Rice = [
    ["White Rice", "assets/images/rice-bowl.png", Colors.red],
    ["Black Rice", "assets/images/rice (1).png", Colors.blue],
    ["Biriyani", "assets/images/food (1).png", Colors.purple],
    ["Fried Rice", "assets/images/fried-rice.png", Colors.brown],
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
      itemCount: Rice.length,
      itemBuilder: (context, index) {
        return RiceTitle(
          ritems: Rice[index][0],
          imageName: Rice[index][1],
          additem: Rice[index][2],
        );
      },
    );
  }
}

class RiceTitle extends StatefulWidget {
  final String ritems;
  final String imageName;
  final Color additem;

  const RiceTitle({
    super.key,
    required this.ritems,
    required this.imageName,
    required this.additem,
  });

  @override
  _RiceTitleState createState() => _RiceTitleState();
}

class _RiceTitleState extends State<RiceTitle> {
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
              widget.ritems,
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

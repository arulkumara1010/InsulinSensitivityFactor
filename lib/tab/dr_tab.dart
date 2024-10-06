import 'package:flutter/material.dart';

class DrinkTab extends StatelessWidget {
  final List drink = [
    ["Juices", "assets/images/juices.png", Colors.red],
    ["Coffee", "assets/images/coffee-cup.png", Colors.blue],
    ["Tea", "assets/images/tea.png", Colors.purple],
    ["Softdrink", "assets/images/soft-drinks.png", Colors.brown],
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
      itemCount: drink.length,
      itemBuilder: (context, index) {
        return drinkTitle(
          dritems: drink[index][0],
          imageName: drink[index][1],
          additem: drink[index][2],
        );
      },
    );
  }
}

class drinkTitle extends StatefulWidget {
  final String dritems;
  final String imageName;
  final Color additem;

  const drinkTitle({
    super.key,
    required this.dritems,
    required this.imageName,
    required this.additem,
  });

  @override
  _drinkTitleState createState() => _drinkTitleState();
}

class _drinkTitleState extends State<drinkTitle> {
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
              widget.dritems,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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

import 'package:flutter/material.dart';
import 'package:cafevibe/cafelogin.dart';
import 'package:cafevibe/billscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CafeDash extends StatefulWidget {
  const CafeDash({super.key});

  @override
  State<CafeDash> createState() => _CafeDashState();
}

class _CafeDashState extends State<CafeDash> {
  late SharedPreferences sharedPreferences;
  String? email;

  // Quantities instead of booleans
  int qtyPizza = 0;
  int qtyBurger = 0;
  int qtyCoffee = 0;
  int qtyTea = 0;

  // Prices
  final double pricePizza = 100;
  final double priceBurger = 70;
  final double priceCoffee = 120;
  final double priceTea = 50;

  @override
  void initState() {
    super.initState();
    checklogin();
  }

  Future<void> checklogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = sharedPreferences.getString("t1");
    });
  }

  void placeorder() {
    double totalAmount = 0;
    String orderData = "";

    if (qtyPizza > 0) {
      totalAmount += (pricePizza * qtyPizza);
      orderData += "Pizza (x$qtyPizza) \n   Rs.${(pricePizza * qtyPizza).toInt()}\n\n";
    }
    if (qtyBurger > 0) {
      totalAmount += (priceBurger * qtyBurger);
      orderData += "Burger (x$qtyBurger) \n   Rs.${(priceBurger * qtyBurger).toInt()}\n\n";
    }
    if (qtyCoffee > 0) {
      totalAmount += (priceCoffee * qtyCoffee);
      orderData += "Coffee (x$qtyCoffee) \n   Rs.${(priceCoffee * qtyCoffee).toInt()}\n\n";
    }
    if (qtyTea > 0) {
      totalAmount += (priceTea * qtyTea);
      orderData += "Tea (x$qtyTea) \n   Rs.${(priceTea * qtyTea).toInt()}\n\n";
    }

    if (totalAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Navigate to Bill Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Billscreen(amount: totalAmount, data: orderData),
      ),
    );
  }

  void resetMenu() {
    setState(() {
      qtyPizza = 0;
      qtyBurger = 0;
      qtyCoffee = 0;
      qtyTea = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate total to show on the dashboard button
    double liveTotal = (qtyPizza * pricePizza) +
        (qtyBurger * priceBurger) +
        (qtyCoffee * priceCoffee) +
        (qtyTea * priceTea);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Warm cream background
      appBar: AppBar(
        title: Text(
          "Welcome ${email ?? 'Guest'}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: resetMenu,
            icon: const Icon(Icons.refresh),
            tooltip: "Clear Order",
          ),
          IconButton(
            onPressed: () {
              sharedPreferences.setBool("tops", true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CafeLogin()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
        backgroundColor: const Color(0xFF4E342E),
        centerTitle: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Our Menu",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E342E),
              ),
            ),
            const SizedBox(height: 20),
            
            // Reusable Quantity Items
            _buildQtyItem(
              title: "Pizza",
              price: pricePizza,
              icon: Icons.local_pizza,
              quantity: qtyPizza,
              onAdd: () => setState(() => qtyPizza++),
              onRemove: () => setState(() {
                if (qtyPizza > 0) qtyPizza--;
              }),
            ),
            const SizedBox(height: 15),
            _buildQtyItem(
              title: "Burger",
              price: priceBurger,
              icon: Icons.lunch_dining,
              quantity: qtyBurger,
              onAdd: () => setState(() => qtyBurger++),
              onRemove: () => setState(() {
                if (qtyBurger > 0) qtyBurger--;
              }),
            ),
            const SizedBox(height: 15),
            _buildQtyItem(
              title: "Coffee",
              price: priceCoffee,
              icon: Icons.coffee,
              quantity: qtyCoffee,
              onAdd: () => setState(() => qtyCoffee++),
              onRemove: () => setState(() {
                if (qtyCoffee > 0) qtyCoffee--;
              }),
            ),
            const SizedBox(height: 15),
            _buildQtyItem(
              title: "Tea",
              price: priceTea,
              icon: Icons.emoji_food_beverage,
              quantity: qtyTea,
              onAdd: () => setState(() => qtyTea++),
              onRemove: () => setState(() {
                if (qtyTea > 0) qtyTea--;
              }),
            ),
            
            const Spacer(),
            
            // Order Button with live total
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E342E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: placeorder,
                child: Text(
                  liveTotal > 0
                      ? "ORDER (Rs. ${liveTotal.toInt()})"
                      : "PLACE ORDER",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Custom Widget for Quantity Selector
  Widget _buildQtyItem({
    required String title,
    required double price,
    required IconData icon,
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Item Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFAF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF795548), size: 28),
          ),
          const SizedBox(width: 15),
          // Item Name & Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rs. ${price.toInt()}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Plus / Minus Quantity Buttons
          Row(
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline),
                color: quantity > 0 ? const Color(0xFF4E342E) : Colors.grey,
              ),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E),
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle),
                color: const Color(0xFF4E342E),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

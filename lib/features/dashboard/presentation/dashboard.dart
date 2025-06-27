import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.child});
  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.purple,
        unselectedItemColor: Colors.blueGrey,
        onTap: (index) {
          child.goBranch(index);
        },
        currentIndex: child.currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Todo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_form),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.api),
            label: 'Method Channel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Product',
          ),
        ],
      ),
    );
  }
}

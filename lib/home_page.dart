import 'package:flutter/material.dart';
import 'widgets/shopping_cart.dart';
import 'widgets/user_registration_form.dart';
import 'widgets/weather_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Tab> _tabs = [
    const Tab(icon: Icon(Icons.person_add), text: 'Registration'),
    const Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping Cart'),
    const Tab(icon: Icon(Icons.wb_sunny), text: 'Weather'),
  ];

  final List<Widget> _tabViews = [
    const UserRegistrationForm(),
    const ShoppingCart(),
    const WeatherDisplay(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Testing Lab',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border(
                  bottom: BorderSide(color: Colors.green.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.gpp_good_outlined,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Current Widget: ${_getWidgetName(_currentIndex)} - not Contains bugs all fixing!',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabViews.map((widget) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border(top: BorderSide(color: Colors.blue.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center),
            const SizedBox(height: 4),
            Text(
              'Switch between tabs to test different widgets',
              style: TextStyle(color: Colors.blue.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _getWidgetName(int index) {
    switch (index) {
      case 0:
        return 'User Registration Form';
      case 1:
        return 'Shopping Cart';
      case 2:
        return 'Weather Display';
      default:
        return 'Unknown Widget';
    }
  }
}

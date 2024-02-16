// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:Baixar_Xml/screen_config/home_page.dart';
import 'package:Baixar_Xml/screen_config/monofasico_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _screens = const [
    HomePage(),
    MonofasicoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return SizedBox(
                width: _controller.value * 250, // Largura máxima do Drawer
                child: Drawer(
                  backgroundColor: Colors.blue.shade800,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          'XML',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _onItemTapped(0);
                        },
                      ),
                      ListTile(
                        title: const Text(
                          'Monofásico',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          _onItemTapped(1);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Xmls e Monofásicos',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _controller.isDismissed
                ? _controller.forward()
                : _controller.reverse();
          },
        ),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }
}

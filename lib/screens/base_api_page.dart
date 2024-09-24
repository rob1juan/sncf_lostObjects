import 'package:flutter/material.dart';
import 'package:myapp/colors.dart';
import 'package:myapp/screens/search.dart';
import 'package:myapp/screens/about.dart';
import 'package:myapp/screens/settings.dart';

class BaseApiPage extends StatefulWidget {
  @override
  _BaseApiPageState createState() => _BaseApiPageState();
}

class _BaseApiPageState extends State<BaseApiPage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    AboutPage(),
    SearchPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'A propos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Chercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
        selectedItemColor: AppColors.selectedNavbarColor,
        unselectedItemColor: AppColors.unselectedNavbarColor,
        backgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color backgroundColor;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 16.0), // Réduire la valeur de padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              int index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (item.icon as Icon).icon as IconData,
                        color: currentIndex == index
                            ? selectedItemColor
                            : unselectedItemColor,
                      ),
                      Text(
                        item.label ?? '',
                        style: TextStyle(
                          color: currentIndex == index
                              ? selectedItemColor
                              : unselectedItemColor,
                        ),
                      ),
                      if (currentIndex == index)
                        Container(
                          margin: EdgeInsets.only(top: 4.0),
                          height: 2.0,
                          width: 24.0,
                          color: selectedItemColor,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

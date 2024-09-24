import 'package:flutter/material.dart';
import 'package:myapp/colors.dart';
import 'base_api_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70.0),
            Image.asset(
              'assets/images/lost_found.png',
              height: 200.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'by',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 8.0),
            Image.asset(
              'assets/images/sncf.png',
              height: 30.0,
            ),
            SizedBox(height: 48.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaseApiPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35.0,
                  vertical: 12.0,
                ),
                child: Text(
                  'Commencer',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: AppColors.textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Spacer(),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}

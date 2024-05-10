import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/configs/config.dart';
import 'package:flutter_app_demo_kho/routes/routes.dart';



class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Demo Nhập Xuất Kho',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MenuButton(
              title: 'Nhập Kho',
              iconData: Icons.download,
              onTap: () {
                Navigator.pushNamed(context, Routes.inputInventory);
              },
            ),
            SizedBox(height: 32),
            MenuButton(
              title: 'Xuất Kho',
              iconData: Icons.upload,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  const MenuButton({
    required this.title,
    required this.iconData,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(iconData),
      label: Text(
        title,
        style: TextStyle(fontSize: 32),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: lightColorScheme.onPrimary,
        backgroundColor: lightColorScheme.primary, 
        shadowColor: lightColorScheme.inversePrimary,
        elevation: 10, // Độ cao của shadow
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(cornerLarge), 
          side: BorderSide(
              color: lightColorScheme.scrim), 
        ),
        minimumSize: Size(300, 100), 
      ),
    );
  }
}

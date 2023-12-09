import 'package:flutter/material.dart';
import 'package:futa_noise_app/settings_page.dart';

enum BottomIcon { home, search, list, setting }

class BottomAppBarWidget extends StatefulWidget {
  const BottomAppBarWidget({
    super.key,
  });

  @override
  State<BottomAppBarWidget> createState() => _BottomAppBarWidgetState();
}

class _BottomAppBarWidgetState extends State<BottomAppBarWidget> {
  BottomIcon? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0XFF1E319D),
      height: 70,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIcon = BottomIcon.home;
                  });
                },
                icon: const Icon(Icons.home),
                iconSize: 40,
                color: selectedIcon == BottomIcon.home
                    ? Colors.white
                    : const Color.fromARGB(179, 165, 162, 162),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIcon = BottomIcon.search;
                  });
                },
                icon: const Icon(Icons.search),
                iconSize: 40,
                color: selectedIcon == BottomIcon.search
                    ? Colors.white
                    : const Color.fromARGB(179, 165, 162, 162),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIcon = BottomIcon.list;
                  });
                },
                icon: const Icon(Icons.list),
                iconSize: 40,
                color: selectedIcon == BottomIcon.list
                    ? Colors.white
                    : const Color.fromARGB(179, 165, 162, 162),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIcon = BottomIcon.setting;
                    Navigator.pushNamed(context, SettingPage.id);
                  });
                },
                icon: const Icon(Icons.settings),
                iconSize: 40,
                color: selectedIcon == BottomIcon.setting
                    ? Colors.white
                    : const Color.fromARGB(179, 165, 162, 162),
              ),
            ]),
      ),
    );
  }
}

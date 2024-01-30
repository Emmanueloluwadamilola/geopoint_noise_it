import 'package:flutter/material.dart';
import 'package:futa_noise_app/constants.dart';
import 'package:futa_noise_app/screens/home_screen.dart';
import 'package:futa_noise_app/screens/list_page.dart';
import 'package:futa_noise_app/screens/map_screen.dart';

enum BottomIcon { home, search, list, setting, map }

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
      color: kPrimaryColour,
      height: 70,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15,
        ),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, ListPage.id);
                  setState(() {
                    selectedIcon = BottomIcon.list;
                  });
                },
                icon: const Icon(Icons.list),
                iconSize: 40,
                color: Colors.white30,
              ),

              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Home.id);
                  setState(() {
                    selectedIcon = BottomIcon.home;
                  });
                },
                icon: const Icon(Icons.home),
                iconSize: 40,
                color: Colors.white,
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, SearchPage.id);
              //     setState(() {
              //       selectedIcon = BottomIcon.search;
              //     });
              //   },
              //   icon: const Icon(Icons.search),
              //   iconSize: 40,
              //   color: Colors.white,
              // ),

              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, MapScreen.id);
                  setState(() {
                    selectedIcon = BottomIcon.map;
                  });
                },
                icon: const Icon(Icons.map),
                iconSize: 40,
                color: Colors.white30,
              ),
            ]),
      ),
    );
  }
}

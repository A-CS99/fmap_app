import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function setShowBottomBar;
  const MyAppBar(this.setShowBottomBar, {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text( '数据结构课程设计——地图导航', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
      bottom: TabBar(
        onTap: (index) {
          setShowBottomBar(index == 0);
        },
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        overlayColor: MaterialStateProperty.all(Colors.pink),
        tabs: const [
          Tab(text: '地图',),
          Tab(text: '列表',),
        ]
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final bool showBottomBar;
  final Function switchShowPointType;
  const BottomBar(this.showBottomBar, this.switchShowPointType, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!showBottomBar) {
      return const SizedBox();
    }
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.route_outlined), onPressed: () {  },),
          const SizedBox(),
          IconButton(icon: const Icon(Icons.place), onPressed: () { switchShowPointType(); },),
        ],
      ),
    );
  }
}
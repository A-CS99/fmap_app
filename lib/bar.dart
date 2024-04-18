import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function setShowBottomBar;
  const MyAppBar(this.setShowBottomBar, {super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

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
        labelStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 16),
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
  final Function searchTSP;
  const BottomBar(this.showBottomBar, this.switchShowPointType, this.searchTSP, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!showBottomBar) {
      return const SizedBox();
    }
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(icon: const Icon(Icons.route_outlined, size: 32,), onPressed: () { searchTSP(); },),
              const Text('TSP', style: TextStyle(fontSize: 14),),
            ],
          ),
          const SizedBox(),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.place, size: 32,), onPressed: () { switchShowPointType(); },),
              const Text('点位', style: TextStyle(fontSize: 14),),
            ],
          ),
        ],
      ),
    );
  }
}
// lib/app/app_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watnow_autumn_team3_front/pages/home/insight/insight_page.dart';

class Todo {
  final String title;
  bool isDone;
  Todo(this.title, {this.isDone = false});
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  int _currentIndex = 1;

  final List<Todo> _todos = [
    Todo('レポートを1つ終わらせる'),
    Todo('30分勉強する'),
    Todo('課題を1つ提出する'),
  ];

  int get _rawPercent {
    if (_todos.isEmpty) return 0;
    final done = _todos.where((t) => t.isDone).length;
    return ((done / _todos.length) * 100).round();
  }

  int get _cactusPercent {
    const levels = [0, 5, 10, 20, 30, 50, 90, 100];
    int closest = levels.first;
    int minDiff = (levels.first - _rawPercent).abs();

    for (final level in levels) {
      final diff = (level - _rawPercent).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = level;
      }
    }
    return closest;
  }

  String get _cactusImagePath => 'assets/images/${_cactusPercent}per.png';

  void _toggleTodo(int index, bool? value) {
    setState(() {
      _todos[index].isDone = value ?? false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const GroupPage();
      case 1:
        return HomePage(
          percent: _cactusPercent,
          imagePath: _cactusImagePath,
        );
      case 2:
        return TodoPage(
          todos: _todos,
          onToggle: _toggleTodo,
        );
      case 3:
        return const InsightPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: const Color(0xA8006400),
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_group.svg',
                activeAssetPath: 'assets/icons/active_group.svg',
                isActive: _currentIndex == 0,
                onTap: () => _onTabTapped(0),
              ),
              const SizedBox(width: 34),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_home.svg',
                activeAssetPath: 'assets/icons/active_home.svg',
                isActive: _currentIndex == 1,
                onTap: () => _onTabTapped(1),
              ),
              const SizedBox(width: 34),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_list.svg',
                activeAssetPath: 'assets/icons/active_list.svg',
                isActive: _currentIndex == 2,
                onTap: () => _onTabTapped(2),
              ),
              const SizedBox(width: 34),
              _BottomNavIcon(
                assetPath: 'assets/icons/icon_insight.svg',
                activeAssetPath: 'assets/icons/active_insight.svg',
                isActive: _currentIndex == 3,
                onTap: () => _onTabTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final String assetPath;
  final String activeAssetPath;
  final bool isActive;
  final VoidCallback onTap;
  final double size;

  const _BottomNavIcon({
    super.key,
    required this.assetPath,
    required this.activeAssetPath,
    required this.isActive,
    required this.onTap,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final pathToUse = isActive ? activeAssetPath : assetPath;
    final Color iconColor = isActive
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(217, 255, 255, 255);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          child: SvgPicture.asset(pathToUse, width: size, height: size),
        ),
      ),
    );
  }
}

// ===== 仮ページ（このままでもOK） =====

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Group Page'));
  }
}

class HomePage extends StatelessWidget {
  final int percent;
  final String imagePath;

  const HomePage({super.key, required this.percent, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('サボテン成長度：$percent%'),
          const SizedBox(height: 16),
          Image.asset(imagePath, width: 180, height: 180),
        ],
      ),
    );
  }
}

class TodoPage extends StatelessWidget {
  final List<Todo> todos;
  final void Function(int, bool?) onToggle;

  const TodoPage({super.key, required this.todos, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return CheckboxListTile(
          title: Text(todo.title),
          value: todo.isDone,
          onChanged: (v) => onToggle(index, v),
        );
      },
    );
  }
}

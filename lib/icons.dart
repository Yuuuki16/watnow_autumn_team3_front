import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class IconGrid extends StatelessWidget {
  final List<String> paths;

  const IconGrid({super.key, required this.paths});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16),
      children: paths
          .map((path) => SvgPicture.asset(path, width: 60, height: 60))
          .toList(),
    );
  }
}

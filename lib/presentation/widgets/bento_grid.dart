import 'package:flutter/material.dart';

class BentoGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;

  const BentoGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: 1.0, // Square cells by default
      children: children,
    );
  }
}

class BentoItem extends StatelessWidget {
  final Widget child;
  final int flex; // Not used in GridView but useful if we move to Flex logic
  
  const BentoItem({
    super.key,
    required this.child,
    this.flex = 1,
  });
  
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

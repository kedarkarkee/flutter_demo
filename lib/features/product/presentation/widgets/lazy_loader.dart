import 'package:flutter/material.dart';

class LazyLoader extends StatelessWidget {
  const LazyLoader({required this.onLazyLoad, required this.child, super.key});

  final VoidCallback onLazyLoad;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double? maxScrollExtent;
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (!metrics.atEdge) return true;
        if (metrics.pixels == 0) return true;
        if (maxScrollExtent == metrics.maxScrollExtent &&
            !metrics.maxScrollExtent.isInfinite) {
          return true;
        }
        onLazyLoad();
        maxScrollExtent = metrics.maxScrollExtent;
        return true;
      },
      child: child,
    );
  }
}

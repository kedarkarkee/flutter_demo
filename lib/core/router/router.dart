import 'package:demo/features/dashboard/presentation/dashboard.dart';
import 'package:demo/features/form/presentation/form_page.dart';
import 'package:demo/features/method_channel/presentation/method_channel.dart';
import 'package:demo/features/product/presentation/pages/product_page.dart';
import 'package:demo/features/product/presentation/pages/product_detail.dart';
import 'package:demo/features/todo/presentation/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: _navigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return DashboardPage(child: shell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const TodoPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/form',
              builder: (context, state) => const FormPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/method_channel',
              builder: (context, state) => const MethodChannelPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/product',
              builder: (context, state) => const ProductPage(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) => const ProductDetailPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

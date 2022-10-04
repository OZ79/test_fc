import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_fc/data/model.dart';

import '../constants.dart';
import '../data/repository.dart';
import '../view/screens.dart';

final repositoryProvider = Provider<RepositoryApi>(
  (ref) => RepositoryImp(),
);

final imagesProvider = FutureProvider<List<Img>>(
  (ref) async {
    const url =
        'https://api.storyblok.com/v2/cdn/stories/marketfood?version=draft&token=YX1dC80Z9U5IupBCCIbiRgtt&cv=1664543171';
    return ref
        .read(repositoryProvider)
        .fetchImages(Uri.parse(url))
        .catchError((error) => <Img>[]);
  },
);

final barItemsProvider = Provider<List<CustomBottomNavigationBarItem>>(
  (ref) {
    return [
      const CustomBottomNavigationBarItem(
        location: Location.Home,
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const CustomBottomNavigationBarItem(
        location: Location.Cart,
        icon: Icon(Icons.card_travel),
        label: 'Cart',
      ),
    ];
  },
);

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: Location.Home,
      navigatorKey: GlobalKey<NavigatorState>(),
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          navigatorKey: GlobalKey<NavigatorState>(),
          builder: (context, state, child) {
            return ScaffoldWithBottomNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: Location.Home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: Location.Details,
                  builder: (context, state) => const CPage(title: 'View Page'),
                ),
              ],
            ),
            GoRoute(
                path: Location.Cart,
                builder: (context, state) => const CPage(
                      title: 'Card Page',
                    )),
          ],
        ),
      ],
    );
    ;
  },
);

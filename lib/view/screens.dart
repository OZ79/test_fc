import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_fc/data/model.dart';
import 'package:test_fc/providers/providers.dart';

import '../constants.dart';

class ScaffoldWithBottomNavBar extends HookConsumerWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  int _locationToTabIndex(String location, WidgetRef ref) {
    final barItems = ref.read(barItemsProvider);
    final index =
        barItems.indexWhere((item) => location.startsWith(item.location));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barItems = ref.read(barItemsProvider);
    final currentIndex =
        _locationToTabIndex(GoRouter.of(context).location, ref);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF1D1D27),
        title: const AppBarTitle(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.search),
          )
        ],
        centerTitle: false,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: barItems,
        onTap: (index) {
          if (index != currentIndex) {
            context.go(barItems[index].location);
          }
        },
      ),
    );
  }
}

class AppBarTitle extends HookConsumerWidget {
  const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useListenable(GoRouter.of(context).routeInformationProvider);

    return Row(
      children: [
        if (GoRouter.of(context).location != Location.Home)
          InkWell(
            child: const Icon(Icons.arrow_back),
            onTap: () => context.go(Location.Home),
          ),
        if (GoRouter.of(context).location == Location.Home)
          const Icon(Icons.car_rental),
        const SizedBox(
          width: 10,
        ),
        const Text('Test App'),
        const SizedBox(
          width: 10,
        ),
        const Icon(Icons.arrow_drop_down),
      ],
    );
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  final String location;
  const CustomBottomNavigationBarItem(
      {required this.location, required Widget icon, String? label})
      : super(icon: icon, label: label);
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        const HomePageView(),
        Positioned(
          left: 30,
          bottom: 240,
          child: ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Text('View Detail'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () => context.go(Location.Home + '/' + Location.Details),
          ),
        ),
      ],
    );
  }
}

class HomePageView extends HookConsumerWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imagesProvider).value;
    final pageController = usePageController();

    if (images == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return PageViewItem(
              image: images[index],
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Indicator(controller: pageController, length: images.length),
          ),
        ),
      ],
    );
  }
}

class Indicator extends HookConsumerWidget {
  final PageController controller;
  final int length;
  const Indicator({Key? key, required this.length, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useListenable(controller);

    return DotsIndicator(
      decorator: DotsDecorator(
        size: const Size.square(17.0),
        activeSize: const Size.square(17.0),
        color: Colors.white, // Inactive color
        activeColor: Colors.white.withOpacity(0.4),
      ),
      dotsCount: length,
      position: controller.page ?? 0,
    );
  }
}

class PageViewItem extends StatelessWidget {
  final Img image;
  const PageViewItem({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          image: NetworkImage(image.filename),
        ),
        Positioned(
          left: 30,
          top: 200,
          child: Text(
            image.title,
            style: const TextStyle(color: Colors.white, fontSize: 50),
          ),
        ),
      ],
    );
  }
}

class CPage extends StatelessWidget {
  final String title;
  const CPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
          title,
          style: const TextStyle(fontSize: 50),
        ));
  }
}

import 'package:flutter/material.dart';

import 'sources.dart';
import '../components.dart';
import '../constants.dart';
import '../elevation_screen.dart';
import '../typography_screen.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final bool useLightMode;
  final ColorSeed colorSelected;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  bool showLargeSizeLayout = false;
  int screenIndex = ScreenSelected.home.value;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
      if (width > largeWidthBreakpoint) {
        showLargeSizeLayout = true;
      } else {
        showLargeSizeLayout = false;
      }
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        controller.forward();
      }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > largeWidthBreakpoint ? 1 : 0;
    }
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  Widget createScreenFor(ScreenSelected screenSelected,) => switch (screenSelected) {
    ScreenSelected.home => const Expanded(
      child: Center(
        child: Text("Home screen"),
      ),
    ),
    ScreenSelected.sources => const DatasourceScreen(),
    ScreenSelected.records => const TypographyScreen(),
    ScreenSelected.helps => const ElevationScreen(),
  };

  Widget _trailingActions() => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Flexible(
        child: BrightnessButton(
          handleBrightnessChange: widget.handleBrightnessChange,
          showTooltipBelow: false,
        ),
      ),
      Flexible(
        child: ColorSeedButton(
          handleColorSelect: widget.handleColorSelect,
          colorSelected: widget.colorSelected,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          railAnimation: railAnimation,
          body: createScreenFor(ScreenSelected.values[screenIndex]),
          navigationRail: NavigationRail(
            extended: showLargeSizeLayout,
            destinations: appBarDestinations.map(
              (destination) => NavigationRailDestination(
                  icon: Tooltip(
                    message: destination.label,
                    child: destination.icon,
                  ),
                  selectedIcon: Tooltip(
                    message: destination.label,
                    child: destination.selectedIcon,
                  ),
                  label: Text(destination.label),
                ),
              ).toList(),
            selectedIndex: screenIndex,
            onDestinationSelected: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
            trailing: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: showLargeSizeLayout
                  ? ExpandedTrailingActions(
                      useLightMode: widget.useLightMode,
                      handleBrightnessChange: widget.handleBrightnessChange,
                      useMaterial3: true,
                      handleColorSelect: widget.handleColorSelect,
                      colorSelected: widget.colorSelected,
                    )
                  : _trailingActions(),
              ),
            ),
          ),
        );
      },
    );
  }
}

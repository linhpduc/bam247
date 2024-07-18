import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'constants.dart';
import 'utils/network.dart';


// Navigation
const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.home_outlined),
    label: 'Home',
    selectedIcon: Icon(Icons.home),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.dataset_outlined),
    label: 'Sources',
    selectedIcon: Icon(Icons.dataset),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.checklist_rtl_outlined),
    label: 'Records',
    selectedIcon: Icon(Icons.checklist_rtl),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.info_outline),
    label: 'FAQ',
    selectedIcon: Icon(Icons.info),
  )
];

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.2,
            0.8,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.4,
            1.0,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class RailTransition extends StatefulWidget {
  const RailTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<RailTransition> createState() => _RailTransition();
}

class _RailTransition extends State<RailTransition> {
  late Animation<Offset> offsetAnimation;
  late Animation<double> widthAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The animations are only rebuilt by this method when the text
    // direction changes because this widget only depends on Directionality.
    final bool ltr = Directionality.of(context) == TextDirection.ltr;

    widthAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));

    offsetAnimation = Tween<Offset>(
      begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: widthAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class NavigationTransition extends StatefulWidget {
  const NavigationTransition(
      {super.key,
      required this.scaffoldKey,
      required this.animationController,
      required this.railAnimation,
      required this.navigationRail,
      required this.body});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  final CurvedAnimation railAnimation;
  final Widget navigationRail;
  final Widget body;

  @override
  State<NavigationTransition> createState() => _NavigationTransitionState();
}

class _NavigationTransitionState extends State<NavigationTransition> {
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  final NetworkBloc _networkBloc = NetworkBloc();

  bool controllerInitialized = false;
  bool showDivider = false;
  
  void handleNetworkChecking(timer) async {
    _networkBloc.eventSink.add(ConnectingNetworkEvent());
    bool status = await isInternetConnected();
    if (status) {
      _networkBloc.eventSink.add(ConnectedNetworkEvent());
    } else {
      _networkBloc.eventSink.add(DisconnectedNetworkEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    controller = widget.animationController;
    railAnimation = widget.railAnimation;
    _networkBloc.eventSink.add(ConnectingNetworkEvent());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 10), handleNetworkChecking);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _networkBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: colorScheme.onSecondary,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Build version: 202407.171014", style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(width: 20,),
            StreamBuilder<NetworkState>(
              stream: _networkBloc.currentStatus,
              initialData: NetworkState.initial(),
              builder: (BuildContext context, AsyncSnapshot<NetworkState> snapshot) {
                if (snapshot.data?.currentStatus == "connected") {
                  return const Tooltip(
                    message: "Network connected", 
                    child: Icon(Icons.wifi, size: 16, color: Colors.green,),
                  );
                  
                } else if (snapshot.data?.currentStatus == "disconnected") {
                  return const Tooltip(
                    message: "No internet access", 
                    child: Icon(Icons.wifi_off, size: 16, color: Colors.grey,),
                  );
                } else {
                  return SizedBox(
                    width: 10, height: 10, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  );     
                }
              }
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RailTransition(
              animation: railAnimation,
              backgroundColor: colorScheme.onPrimaryContainer,
              child: widget.navigationRail,
            ),
            widget.body,
          ],
        ),
      ),
    );
  }
}
// End navigation

// ==========================

// Display settings
class BrightnessButton extends StatelessWidget {
  const BrightnessButton({
    super.key,
    required this.handleBrightnessChange,
    this.showTooltipBelow = true,
  });

  final Function handleBrightnessChange;
  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle darkmode',
      child: IconButton(
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () => handleBrightnessChange(!isBright),
      ),
    );
  }
}

class ColorSeedButton extends StatelessWidget {
  const ColorSeedButton({
    super.key,
    required this.handleColorSelect,
    required this.colorSelected,
  });

  final void Function(int) handleColorSelect;
  final ColorSeed colorSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.palette_outlined,
      ),
      tooltip: 'Select theme color',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(ColorSeed.values.length, (index) {
          ColorSeed currentColor = ColorSeed.values[index];
          return PopupMenuItem(
            value: index,
            enabled: currentColor != colorSelected,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    currentColor == colorSelected
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: currentColor.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(currentColor.label),
                ),
              ],
            ),
          );
        });
      },
      onSelected: handleColorSelect,
    );
  }
}

class ExpandedTrailingActions extends StatelessWidget {
  const ExpandedTrailingActions({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
    required this.useMaterial3,
    required this.handleColorSelect,
    required this.colorSelected,
  });

  final void Function(bool) handleBrightnessChange;
  final void Function(int) handleColorSelect;

  final bool useLightMode;
  final bool useMaterial3;

  final ColorSeed colorSelected;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final trailingActionsBody = Container(
      constraints: const BoxConstraints.tightFor(width: 250),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          Row(
            children: [
              const Text('Darkmode'),
              Expanded(child: Container()),
              Switch(
                  value: useLightMode,
                  onChanged: (value) {
                    handleBrightnessChange(value);
                  })
            ],
          ),
          _ExpandedColorSeedAction(
            handleColorSelect: handleColorSelect,
            colorSelected: colorSelected,
          ),
        ],
      ),
    );
    return screenHeight > 740
        ? trailingActionsBody
        : SingleChildScrollView(child: trailingActionsBody);
  }
}

class _ExpandedColorSeedAction extends StatelessWidget {
  const _ExpandedColorSeedAction({
    required this.handleColorSelect,
    required this.colorSelected,
  });

  final void Function(int) handleColorSelect;
  final ColorSeed colorSelected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          ColorSeed.values.length,
          (i) => IconButton(
            icon: const Icon(Icons.radio_button_unchecked),
            color: ColorSeed.values[i].color,
            isSelected: colorSelected.color == ColorSeed.values[i].color,
            selectedIcon: const Icon(Icons.circle),
            onPressed: () {
              handleColorSelect(i);
            },
            tooltip: ColorSeed.values[i].label,
          ),
        ),
      ),
    );
  }
}
// End display settings


const Widget divider = SizedBox(height: 20);
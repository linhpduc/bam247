import 'package:batt247/core/components/image/image_viewer.dart';
import 'package:batt247/core/resource/images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BadgeStatus extends StatelessWidget {
  final bool isConnected;
  const BadgeStatus({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    Color colors = Colors.green;

    if (!isConnected) colors = Colors.red;
    return Container(
      width: 120,
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 3),
      decoration: BoxDecoration(
        border: Border.all(color: colors, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageViewer(isConnected
              ? ImageResource.checkin_done
              : ImageResource.checkin_fail),
          const SizedBox(width: 5),
          Text(
            isConnected
                ? AppLocalizations.of(context)!.connected
                : AppLocalizations.of(context)!.dis_connected,
            style: TextStyle(color: colors),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:user/controllers/theme_controller.dart';

class AppMenuListTile extends StatefulWidget {
  final Function()? onPressed;
  final String? label;
  final String? leadingIconUrl;
  final IconData? icon;
  final bool isSwitchTile;

  AppMenuListTile({
    required this.label,
    this.leadingIconUrl,
    required this.onPressed,
    this.icon,
    this.isSwitchTile = false, // New property to identify switch tile
  }) : super();

  @override
  _AppMenuListTileState createState() => _AppMenuListTileState(
        label: label,
        leadingIconUrl: leadingIconUrl,
        onPressed: onPressed,
        icon: icon,
        isSwitchTile: isSwitchTile,
      );
}

class _AppMenuListTileState extends State<AppMenuListTile> {
  final Function()? onPressed;
  final String? label;
  final String? leadingIconUrl;
  final IconData? icon;
  final bool isSwitchTile;
  final ThemeController _themeController = Get.find(); // GetX Controller

  _AppMenuListTileState({
    this.label,
    this.leadingIconUrl,
    this.onPressed,
    this.icon,
    required this.isSwitchTile,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      onPressed:
          isSwitchTile ? null : onPressed, // Disable button if it's a switch
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : SvgPicture.asset(
                    leadingIconUrl!,
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            SizedBox(width: 16),
            Text(
              label!,
              style: textTheme.titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Spacer(),
            if (isSwitchTile)
              Obx(() {
                return Switch(
                  value: _themeController.isDarkMode.value,
                  onChanged: (value) {
                    _themeController.toggleTheme();
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}

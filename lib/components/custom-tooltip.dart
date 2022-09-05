import 'package:flutter/material.dart';

class CustomTooltip extends StatelessWidget {
  final String message;
  final GlobalKey<TooltipState> stateKey;

  const CustomTooltip({Key? key, required this.message, required this.stateKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Tooltip(
        key: stateKey,
        message: message,
        // child: const Text('Hover over the text to show a tooltip.'),
      ),
    );
  }
}

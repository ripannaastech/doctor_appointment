import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final double thickness;
  final double spacing;
  final Color? color;
  final TextStyle? textStyle;

  const OrDivider({
    super.key,
    this.text = 'OR',
    this.thickness = .5,
    this.spacing = 12,
    this.color,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor =
        color ?? Colors.grey.withOpacity(.5);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Text(
            text,
            style: textStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: thickness,
          ),
        ),
      ],
    );
  }
}

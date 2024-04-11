import 'package:englishtogujarati/controllers/styles.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class TLIconButton extends StatefulWidget {
  final String image;
  final void Function()? onTap;
  const TLIconButton({required this.image, required this.onTap,Key? key}) : super(key: key);

  @override
  State<TLIconButton> createState() => _TLIconButtonState();
}

class _TLIconButtonState extends State<TLIconButton> {
  @override
  Widget build(BuildContext context) {
    return GFIconButton(
      onPressed: widget.onTap,
      icon: Image.asset(widget.image,),

      size: GFSize.SMALL,
      color: Styles.btnBgColorWhite,
      shape: GFIconButtonShape.circle,

    );
  }
}

class TLIconButtonBlack extends StatefulWidget {
  final String image;
  final void Function()? onTap;
  const TLIconButtonBlack({required this.image, required this.onTap,Key? key}) : super(key: key);

  @override
  State<TLIconButtonBlack> createState() => _TLIconButtonBlackState();
}

class _TLIconButtonBlackState extends State<TLIconButtonBlack> {
  @override
  Widget build(BuildContext context) {
    return GFIconButton(
      onPressed: widget.onTap,
      icon: Image.asset(widget.image),
      size: GFSize.SMALL,
      color: Styles.btnBgColor,
      shape: GFIconButtonShape.circle,
    );
  }
}


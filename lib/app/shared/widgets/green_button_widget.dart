import 'package:flutter/material.dart';

class GreenButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final Function onPressed;

  const GreenButtonWidget(
      {Key key,
      @required this.width,
      @required this.height,
      this.child,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      width: this.width,
      height: this.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF34CB79),
      ),
      child: InkWell(
        onTap: onPressed ?? () {},
        child: child,
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const StandardButton(
  {Key key, this.buttonText, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style,
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: Theme.of(context).primaryTextTheme.headline5,
        )
    );
  }
}
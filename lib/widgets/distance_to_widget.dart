import 'package:flutter/material.dart';
import 'package:maoyi/entities/listing.dart';

class DistanceToWidget extends StatefulWidget {
  final OfferListing cardListing;

  const DistanceToWidget({Key key, this.cardListing}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DistanceToWidgetState();
}

class _DistanceToWidgetState extends State<DistanceToWidget> {
  var _distance = 0.0;

  @override
  void initState() {
    super.initState();
    widget.cardListing.getDistanceTo().then((value) {
      setState(() {
        _distance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on),
        Text(
          _distance.toString() + "Km",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ],
    );
  }
}

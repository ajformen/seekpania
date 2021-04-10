import 'package:flutter/material.dart';

class PointsItem extends StatefulWidget {
  final String id;
  final int rate;

  PointsItem(this.id, this.rate);

  @override
  _PointsItemState createState() => _PointsItemState();
}

class _PointsItemState extends State<PointsItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'You have earned ',
                  ),
                  TextSpan(
                    text: widget.rate.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' points',
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            print(widget.id);
          },
        ),
        Divider(color: Color(0xff9933ff)),
      ],
    );
  }
}

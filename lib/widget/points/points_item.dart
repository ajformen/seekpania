import 'package:flutter/material.dart';

class PointsItem extends StatefulWidget {
  final String id;
  final double rate;
  final String feedback;

  PointsItem(this.id, this.rate, this.feedback);

  @override
  _PointsItemState createState() => _PointsItemState();
}

class _PointsItemState extends State<PointsItem> {
  String? formatDate;
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
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              widget.feedback,
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

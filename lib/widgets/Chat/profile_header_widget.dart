import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;

  const ProfileHeaderWidget({
    required this.name,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          height: 80,
          padding: EdgeInsets.all(16).copyWith(left: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Color(0xff03564C)),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildIcon(Icons.call),
                      SizedBox(width: 12),
                      buildIcon(Icons.videocam),
                    ],
                  ),
                  SizedBox(width: 4),
                ],
              )
            ],
          ),
        ),
      );

  Widget buildIcon(IconData icon) => Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff03564C),
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
}

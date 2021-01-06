import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyScreen extends StatefulWidget {
  @override
  _BodyScreenState createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  bool gender = false;

  bool rotation = true;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Guardian'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              (!gender && rotation)
                  ? 'assets/icons/front_man.svg'
                  : (!gender && !rotation)
                      ? 'assets/icons/back_man.svg'
                      : (gender && rotation)
                          ? 'assets/icons/front_women.svg'
                          : 'assets/icons/back_woman.svg',
                
              color: Colors.blue,
              height: 550,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      gender = !gender;
                    });
                  },
                  child: Text('Change Gender'),
                  textColor: Colors.blue,
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      rotation = !rotation;
                    });
                  },
                  child: Text('Change Rotation'),
                  textColor: Colors.blue,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

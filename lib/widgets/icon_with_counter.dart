import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconWithCounter extends StatelessWidget {
  const IconWithCounter({
    Key key, this.icon, this.numOfItem, this.press,
  }) : super(key: key);

  final IconData icon;
  final int numOfItem;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: press,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(icon),
            ),
            if (numOfItem != 0)
              Positioned(
                top: -3,
                right: 0,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4848),
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.5, color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      '$numOfItem',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

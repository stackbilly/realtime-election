import 'package:flutter/material.dart';

enum User { admin, normal }

class ProjectUtilities {
  Widget adminContainers(double x, double y, String text1, String text2,
      Color color, IconData icon) {
    return SizedBox(
        width: x,
        height: y,
        child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20.0,
                left: 20.0,
                child: Text(
                  text1,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              Positioned(
                top: 70.0,
                right: 20.0,
                child: Text(
                  text2,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              Positioned(
                  top: 70.0,
                  left: 20.0,
                  child: Icon(
                    icon,
                    color: Colors.white,
                  )),
            ],
          ),
        ));
  }

  ListTile listTiles(String title, IconData icon, VoidCallback callback) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white60),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      onTap: callback,
    );
  }
}

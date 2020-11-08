import 'package:adda/HelperClass/Resources.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(appYellow),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
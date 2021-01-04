import 'package:flutter/material.dart';

class CircularLetterTile extends StatelessWidget{
  final String letter;
  final double size;
  final Color color;
  final double textSize;
  CircularLetterTile(this.letter,this.size,this.color,this.textSize);

  @override
  Widget build(BuildContext conetxt){
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(letter.toUpperCase(),style: TextStyle(fontSize: textSize),textAlign: TextAlign.center,),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(width: 4.0,color: Colors.black),
      ),
    );
  }
}
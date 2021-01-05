import 'package:flutter/material.dart';
import 'dart:math';

class CircularLetterTile extends StatelessWidget{
  final String letter;
  final double size;
  final double textSize;
  CircularLetterTile(this.letter,this.size,this.textSize);

  Color getRandomColor(){
    List<Color> colors = [Colors.red, Colors.yellow, Colors.blue, Colors.pink, Colors.purple, Colors.orange, Colors.cyan, Colors.lightGreen];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(letter[0].toUpperCase(),style: TextStyle(fontSize: textSize),textAlign: TextAlign.center,),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getRandomColor(),
        border: Border.all(width: 2.5,color: Colors.black),
      ),
    );
  }
}
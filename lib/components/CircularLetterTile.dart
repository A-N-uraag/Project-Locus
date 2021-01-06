import 'package:flutter/material.dart';

class CircularLetterTile extends StatelessWidget{
  final String letter;
  final double size;
  final double textSize;
  CircularLetterTile(this.letter,this.size,this.textSize);

  Color getColor(String letter){
    switch(letter[0]){
      case "A" "H" "O" "U": {
        return Colors.red;
      }
      case "B" "I" "P" "W": {
        return Colors.blue;
      }
      case "C" "J" "Q" "X":{
        return Colors.pink;
      }
      case "D" "K" "R" "Y":{
        return Colors.purple;
      }
      case "E" "L" "S" "Z":{
        return Colors.orange;
      }
      case "F" "M" "T":{
        return Colors.lightGreen;
      }
    }
    return Colors.cyan;
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
        color: getColor(letter[0].toUpperCase()),
        border: Border.all(width: 2.5,color: Colors.black),
      ),
    );
  }
}
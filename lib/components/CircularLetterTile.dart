import 'package:flutter/material.dart';

class CircularLetterTile extends StatelessWidget{
  final String letter;
  final double size;
  final double textSize;
  CircularLetterTile(this.letter,this.size,this.textSize);

  Color getColor(String letter){
    switch(letter[0].toUpperCase()){
      case "A": case "H": case "O": case "U": {
        return Colors.red;
      }
      case "B": case "I": case "P": case "W": {
        return Colors.blue;
      }
      case "C": case "J": case "Q": case "X":{
        return Colors.pink;
      }
      case "D": case "K": case "R": case "Y":{
        return Colors.purple;
      }
      case "E": case "L": case "S": case "Z":{
        return Colors.orange;
      }
      case "F": case "M": case "T":{
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
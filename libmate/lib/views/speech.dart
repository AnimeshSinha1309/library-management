import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:libmate/views/drawer.dart';

class Speech extends StatefulWidget {
  @override
  _SpeechState createState() => _SpeechState();
}


class _SpeechState extends State<Speech> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to text'),
      ),
        drawer: new AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic: Icons.mic_none),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            child: Text(_text),
          )
        )
    );

  }

  void _listen() async{
    if(!_isListening){
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if(available){
        setState(() => _isListening= true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if(val.hasConfidenceRating && val.confidence>0){
              _confidence = val.confidence;
            }
          }),
        );
      }
    }
    else{
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

}
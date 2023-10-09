

import 'dart:async';

class CartCounter{
  StreamController<int> controller;

  CartCounter() {
    controller = StreamController();
  } // StreamSink<int> get addCounter => controller.sink;
  // Stream<int> get getCounter => controller.stream;
  dismiss(){
    controller.close();
  }
}
import 'package:epson_usb_printer/src/epson_style.dart';

class EpsonColumn{

  String text;
  int width;
  EpsonStyle styles;

  EpsonColumn(
      {
        this.text = '',
        this.width = 2,
        this.styles = const EpsonStyle.defaults()
      }){
    if (width < 1 || width > 12) {
      throw Exception('Column width must be between 1..12');
    }
  }
}
import 'package:epson_usb_printer/src/enums.dart';

class EpsonStyle{
  final bool bold;
  final bool underline;
  final bool italic;
  final EpsonAlign align;

  EpsonStyle({this.bold = false, this.underline = false, this.italic = false, this.align = EpsonAlign.left});

  const EpsonStyle.defaults({
    this.bold = false,
    this.underline = false,
    this.italic = false,
    this.align = EpsonAlign.left,
  });

  EpsonStyle copyWith({
    bool? bold,
    bool? underline,
    bool? italic,
    bool? condense,
    EpsonCPI? cpi,
    EpsonAlign? align,
  }) {
    return EpsonStyle(
        bold: bold ?? this.bold,
        underline: bold ?? this.underline,
        italic: italic ?? this.italic,
        align: align ?? this.align,
    );
  }
}
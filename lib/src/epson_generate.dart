import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:epson_usb_printer/src/constans.dart' as cons;
import 'package:epson_usb_printer/model/Paper.dart';
import 'package:epson_usb_printer/epson_usb_printer.dart';

class EpsonGenerate{
  late Paper paper;
  late String printerName;
  late EpsonCPI cpi;
  late bool condense;

  int? maxLine;

  List<String> args = [];

  EpsonGenerate(this.printerName, this.paper, {this.cpi = EpsonCPI.cpi10, this.condense = true, this.maxLine});

  String? printText() {
    final printerNamePtr = printerName.toNativeUtf16();
    final docInfo = calloc<DOC_INFO_1>()
      ..ref.pDocName = 'Flutter Print Job'.toNativeUtf16()
      ..ref.pOutputFile = nullptr
      ..ref.pDatatype = 'RAW'.toNativeUtf16();

    Pointer<PRINTER_DEFAULTS> pDefaults = nullptr;
    Pointer<DEVMODE> devMode = nullptr;

    devMode = calloc<DEVMODE>();
    devMode.ref.dmSize = sizeOf<DEVMODE>();
    devMode.ref.dmFields = DM_PAPERSIZE | DM_PAPERLENGTH | DM_PAPERWIDTH;
    devMode.ref.dmPaperSize = paper.id;
    devMode.ref.dmPaperWidth = (paper.width * 100).round();    // dalam 0.1mm
    devMode.ref.dmPaperLength = (paper.height * 100).round();  // dalam 0.1mm

    pDefaults = calloc<PRINTER_DEFAULTS>()
      ..ref.pDatatype = nullptr
      ..ref.pDevMode = devMode.cast()
      ..ref.DesiredAccess = cons.STANDARD_RIGHTS_REQUIRED | PRINTER_ACCESS_USE | PRINTER_ACCESS_ADMINISTER;

    final phPrinter = calloc<IntPtr>();
    final successOpen = OpenPrinter(printerNamePtr, phPrinter, pDefaults);
    if (successOpen == 0) {
      if (devMode != nullptr) calloc.free(devMode);
      if (pDefaults != nullptr) calloc.free(pDefaults);
      calloc.free(printerNamePtr);
      calloc.free(phPrinter);
      return "Failed to open printer: \$printerName";
    }

    final hPrinter = phPrinter.value;
    StartDocPrinter(hPrinter, 1, docInfo.cast());
    StartPagePrinter(hPrinter);

    final byteList = <int>[];
    for(final line in args){
      byteList.addAll(line.codeUnits);
    }

    final dataPtr = calloc<Uint8>(byteList.length);
    for (int i = 0; i < byteList.length; i++) {
      dataPtr[i] = byteList[i];
    }

    final bytesWritten = calloc<Uint32>();
    final successWrite = WritePrinter(hPrinter, dataPtr, byteList.length, bytesWritten);

    EndPagePrinter(hPrinter);
    EndDocPrinter(hPrinter);
    ClosePrinter(hPrinter);

    calloc.free(dataPtr);
    calloc.free(bytesWritten);
    calloc.free(phPrinter);
    calloc.free(printerNamePtr);
    calloc.free(docInfo.ref.pDocName);
    calloc.free(docInfo.ref.pDatatype);
    calloc.free(docInfo);
    if (devMode != nullptr) calloc.free(devMode);
    if (pDefaults != nullptr) calloc.free(pDefaults);

    return (successWrite != 0 ? null : "Failed must check the reason");
  }

  StringBuffer? text(String text, {
    EpsonStyle style = const EpsonStyle.defaults(),
    bool useRow = false
  }) {
    final buffer = StringBuffer();
    if(!useRow) buffer.write('\x1B@'); // Reset printer

    // CPI selection
    if (cpi == EpsonCPI.cpi12) {
      buffer.write('\x1BM'); // 12 cpi
    } else {
      buffer.write('\x1BP'); // 10 cpi
    }

    // Styles
    if (style.bold) buffer.write('\x1BE');
    if (style.italic) buffer.write('\x1B4');
    if (condense) buffer.write('\x0F');

    var lineWidth = getCharsPerLine();
    String finalText = text;
    int padLength = lineWidth - text.length;
    if (!useRow && padLength > 0) {
      switch (style.align) {
        case EpsonAlign.center:
          int padLeft = (padLength / 2).floor();
          int padRight = padLength - padLeft;
          finalText = ' ' * padLeft + text + ' ' * padRight;
          break;
        case EpsonAlign.right:
          finalText = ' ' * padLength + text;
          break;
        default:
          break;
      }
    }
    buffer.write(finalText);

    if (condense) buffer.write('\x12');
    if (style.italic) buffer.write('\x1B5');
    if (style.bold) buffer.write('\x1BF');

    if(useRow){
      return buffer;
    }
    buffer.write('\n');
    args.add(buffer.toString());
    return null;
  }

  int getCharsPerLine() {
    final widthInch = paper.width / 2.54;
    double effectiveCpi;

    if (condense) {
      effectiveCpi = (cpi == EpsonCPI.cpi12) ? 17.1 : 16.6;
    } else {
      effectiveCpi = (cpi == EpsonCPI.cpi12) ? 12.0 : 10.0;
    }

    return (widthInch * effectiveCpi).floor();
  }

  void feed(int i){
    args.addAll(List.generate(i, (_) => '\n'));
  }

  void hr({String char = '-'}) {
    var maxCharPerLine = getCharsPerLine();
    if(maxLine != null && maxLine! > 0){
      maxCharPerLine = maxLine!;
    }
    var line = '${List<String>.filled(maxCharPerLine, char).join()}\r\n';
    args.add(line);
  }

  void calibrateActualMaxLine({int step = 20}) {
    var line = '${List<String>.filled(step, "-").join()}\r\n';
    args.add(line);
  }

  void row(List<EpsonColumn> cols){
    final isSumValid = cols.fold(0, (int sum, col) => sum + col.width) == 12;
    if (!isSumValid) {
      throw Exception('Total columns width must be equal to ${12}');
    }

    StringBuffer finalText = StringBuffer();
    var maxCharPerLine = getCharsPerLine() - 5;

    for (int i = 0; i < cols.length; ++i) {
      int maxCharCol = ((maxCharPerLine / 12) * cols[i].width).floor();
      if(cols[i].text.length > maxCharCol){
        var tmp = cols[i].text.substring(0, maxCharCol);
        finalText.write(text(tmp, style: cols[i].styles, useRow: true)!);
      }else{
        if(cols[i].styles.align == EpsonAlign.left || cols[i].styles.align == EpsonAlign.center){
          int restStr = maxCharCol - cols[i].text.length;
          var tmp = cols[i].text;
          for(int j = 0; j < restStr; j++){
            tmp += " ";
          }
          finalText.write(text(tmp, style: cols[i].styles, useRow: true)!);
        }else if(cols[i].styles.align == EpsonAlign.right){
          int restStr = maxCharCol - cols[i].text.length;
          var tmp = "";
          for(int j = 0; j < restStr; j++){
            tmp += " ";
          }
          tmp += cols[i].text;
          finalText.write(text(tmp, style: cols[i].styles, useRow: true)!);
        }
      }
    }

    finalText.write('\n');
    args.add(finalText.toString());
  }

}
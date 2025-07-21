import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class PrinterDevice{
  static List<String> getInstalledPrinters() {
    const flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS;
    final pcbNeeded = calloc<Uint32>();
    final pcReturned = calloc<Uint32>();

    EnumPrinters(flags, nullptr, 2, nullptr, 0, pcbNeeded, pcReturned);
    final cbBuf = pcbNeeded.value;
    final pPrinterEnum = calloc<Uint8>(cbBuf);

    final success = EnumPrinters(flags, nullptr, 2, pPrinterEnum, cbBuf, pcbNeeded, pcReturned);
    final printers = <String>[];

    if (success != 0) {
      final count = pcReturned.value;
      final structSize = sizeOf<PRINTER_INFO_2>();
      for (var i = 0; i < count; i++) {
        final structPtr = pPrinterEnum.elementAt(i * structSize).cast<PRINTER_INFO_2>();
        final name = structPtr.ref.pPrinterName.cast<Utf16>().toDartString();
        printers.add(name);
      }
    }

    calloc.free(pcbNeeded);
    calloc.free(pcReturned);
    calloc.free(pPrinterEnum);

    return printers;
  }
}
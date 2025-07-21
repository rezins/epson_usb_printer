import 'dart:ffi';
import 'package:epson_usb_printer/model/Paper.dart';
import 'package:ffi/ffi.dart';

final _winspool = DynamicLibrary.open('winspool.drv');

// Buat typedef untuk deviceCapabilitiesW
typedef DeviceCapabilitiesWNative = Int32 Function(
    Pointer<Utf16> pDevice,
    Pointer<Utf16> pPort,
    Uint16 fwCapability,
    Pointer pOutput,
    Pointer pDevMode,
    );
typedef DeviceCapabilitiesWDart = int Function(
    Pointer<Utf16> pDevice,
    Pointer<Utf16> pPort,
    int fwCapability,
    Pointer pOutput,
    Pointer pDevMode,
    );

final deviceCapabilitiesW = _winspool
    .lookupFunction<DeviceCapabilitiesWNative, DeviceCapabilitiesWDart>(
    'DeviceCapabilitiesW');

// Define struct POINT
class POINT extends Struct {
  @Int32()
  external int x;

  @Int32()
  external int y;
}

class PrinterPaper{
  static List<Paper> getAvailablePaperNames(String printerName) {
    final pDevice = printerName.toNativeUtf16();
    final pPort = nullptr;

    const DC_PAPERNAMES = 16;
    const DC_PAPERS = 2;
    const DC_PAPERSIZE = 3;
    const PAPER_NAME_LEN = 64;
    const MAX_PAPERS = 2000;

    final namePtr = calloc<Uint16>(PAPER_NAME_LEN * MAX_PAPERS);
    final idPtr = calloc<Uint16>(MAX_PAPERS);
    final sizePtr = calloc<POINT>(MAX_PAPERS * 2);

    final count = deviceCapabilitiesW(pDevice, pPort, DC_PAPERNAMES, namePtr, nullptr);
    deviceCapabilitiesW(pDevice, pPort, DC_PAPERS, idPtr, nullptr);
    deviceCapabilitiesW(pDevice, pPort, DC_PAPERSIZE, sizePtr, nullptr);

    final List<Paper> papers = [];
    for (int i = 0; i < count; i++) {
      final nameUtf16 = namePtr.elementAt(i * PAPER_NAME_LEN).cast<Utf16>();
      final name = nameUtf16.toDartString().trim();
      final id = idPtr[i];
      final point = sizePtr.elementAt(i).ref;
      final widthCm = point.x / 100.0; // 0.1mm → cm
      final heightCm = point.y / 100.0;
      papers.add(Paper(id, name, widthCm, heightCm));
    }

    calloc.free(pDevice);
    calloc.free(namePtr);
    calloc.free(idPtr);

    return papers;
  }


}
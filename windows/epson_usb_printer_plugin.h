#ifndef FLUTTER_PLUGIN_EPSON_USB_PRINTER_PLUGIN_H_
#define FLUTTER_PLUGIN_EPSON_USB_PRINTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace epson_usb_printer {

class EpsonUsbPrinterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EpsonUsbPrinterPlugin();

  virtual ~EpsonUsbPrinterPlugin();

  // Disallow copy and assign.
  EpsonUsbPrinterPlugin(const EpsonUsbPrinterPlugin&) = delete;
  EpsonUsbPrinterPlugin& operator=(const EpsonUsbPrinterPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace epson_usb_printer

#endif  // FLUTTER_PLUGIN_EPSON_USB_PRINTER_PLUGIN_H_

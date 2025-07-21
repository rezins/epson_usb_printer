#include "include/epson_usb_printer/epson_usb_printer_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "epson_usb_printer_plugin.h"

void EpsonUsbPrinterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  epson_usb_printer::EpsonUsbPrinterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

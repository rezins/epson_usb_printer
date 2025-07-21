# epson_usb_printer
Flutter Epson USB Printer Bridge

[![Pub Version](https://img.shields.io/pub/v/epson_usb_printer)](https://pub.dev/packages/epson_usb_printer)

* First thing first, this plugin I made only for Windows.
* Second, I also create printer utils that can make easier to use.
* Third, PRs are welcome.

### Reported Working Printer Models
<sub>(if you notice another model please let us know by opening a issue and reporting)</sub>

- Epson LX-310


## Use simple receipt
```dart
_testPrint({bool withImage = false}){
    final generate = EpsonGenerate(_selectedPrinterName!, _selectedPaper!);

    generate.feed(2);
    generate.text("Demo Shop", style: EpsonStyle(
      bold: false,
      italic: false,
      underline: false,
      align: EpsonAlign.center,
    ),);
    generate.text(
        "Komplek Permata, Jl. R. E. Martadinata No.28 Blok K, RT.11/RW.11, Ancol, Jakarta Utara, Jkt Utara, Daerah Khusus Ibukota Jakarta 14420",
        style: EpsonStyle(align: EpsonAlign.center,bold: false,
          italic: false,
          underline: false,));
    generate.text('(021) 6456633',
        style: EpsonStyle(align: EpsonAlign.center,bold: false,
          italic: false,
          underline: false,));

    generate.hr();
    generate.row([
      EpsonColumn(
          text: 'No',
          width: 1,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: 'Item',
          width: 5,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: 'Price',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: 'Qty',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: 'Total',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),

    ]);
    generate.hr();
    generate.row([
      EpsonColumn(
          text: '1',
          width: 1,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: 'Teh Pucuk',
          width: 5,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: '5000',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: '2',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: '10000',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),

    ]);
    generate.row([
      EpsonColumn(
          text: '2',
          width: 1,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: 'Ramen',
          width: 5,
          styles: EpsonStyle(align: EpsonAlign.left, bold: true)
      ),
      EpsonColumn(
          text: '80000',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: '1',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),
      EpsonColumn(
          text: '80000',
          width: 2,
          styles: EpsonStyle(align: EpsonAlign.right, bold: true)
      ),

    ]);
    generate.hr();
    generate.printText();
  }
```

## Print a receipt
```dart
final generate = EpsonGenerate(_selectedPrinterName!, _selectedPaper!);
generate.printText();
```
For a complete example, check the demo project inside examplem forder

# Test Print
<img src="https://github.com/rezins/epson_usb_printer/blob/main/example/assets/test_print.jpg?raw=true" alt="test receipt" height="1600" width="537"/>

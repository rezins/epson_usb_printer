import 'package:epson_usb_printer/epson_usb_printer.dart';
import 'package:epson_usb_printer/model/Paper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> printerNames = [];
  String? _selectedPrinterName;

  List<Paper> papers = [];
  Paper? _selectedPaper;

  TextEditingController controller = TextEditingController(text: "80");

  @override
  void initState() {
    super.initState();
  }

  _getListPrinter(){
    printerNames = PrinterDevice.getInstalledPrinters();
    setState(() {

    });
  }

  _getListPaper(){
    if(_selectedPrinterName != null){
      papers = PrinterPaper.getAvailablePaperNames(_selectedPrinterName!);
      setState(() {

      });
    }
  }

  List<DropdownMenuItem<Paper>> _getPaperItems() {
    List<DropdownMenuItem<Paper>> items = [];
    if (papers.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in papers) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name, overflow: TextOverflow.ellipsis),
        ));
      }
    }

    return items;
  }

  List<DropdownMenuItem<String>> _getDeviceItems() {
    List<DropdownMenuItem<String>> items = [];
    if (printerNames.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in printerNames) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device, overflow: TextOverflow.ellipsis),
        ));
      }
    }

    return items;
  }

  _testPrint({bool withImage = false}){
    final generate = EpsonGenerate(_selectedPrinterName!, _selectedPaper!, maxLine: int.parse(controller.text));

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

  _calibrateMaxChars(){
    final generate = EpsonGenerate(_selectedPrinterName!, _selectedPaper!,);
    generate.calibrateActualMaxLine(step: int.parse(controller.text));
    generate.printText();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin Datecs app'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        items: _getDeviceItems(),
                        onChanged: (value) async {
                          _selectedPrinterName = value;
                          _getListPaper();
                          setState(() {

                          });
                        }, //_disconnect
                        value: _selectedPrinterName,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        _getListPrinter();
                      },
                    ),

                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Paper:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        items: _getPaperItems(),
                        onChanged: (value) async {
                          _selectedPaper = value as Paper;
                          setState(() {

                          });
                        }, //_disconnect
                        value: _selectedPaper,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Actual Maxline Calibrate:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                      )
                    ),
                    const SizedBox(width: 10,),
                    RawMaterialButton(
                        fillColor: Colors.blue,
                        onPressed: () async{
                          _calibrateMaxChars();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Calibrate Max Line ', style: TextStyle(
                              color: Colors.white
                          ),
                          ),
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: () async{
                      _testPrint();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Test Print ', style: TextStyle(
                          color: Colors.white
                      ),
                      ),
                    )
                ),

                const SizedBox(height: 20,),
                RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: () async{

                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Test Print with Image', style: TextStyle(
                          color: Colors.white
                      ),
                      ),
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}

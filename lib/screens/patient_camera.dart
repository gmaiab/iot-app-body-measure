import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:coap/coap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:first_project/variables/patients_data.dart';

import 'package:first_project/screens/patient_menu.dart';

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();
//
//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;
//
//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePicturePage(
//         // Pass the appropriate camera to the TakePicturePage widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// A screen that allows users to take a picture using a given camera.
class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  final String token;
  final CoapClient client;
  final String partialInput;


  const TakePicturePage(
      {Key key,
      @required this.camera,
      @required this.token,
      @required this.client,
        @required this.partialInput})
      : super(key: key);

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  String _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Tirar foto')),
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "Galeria",
            child: Icon(Icons.photo),
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await getImage();

                if (_image != null){
                  // If the picture was taken, display it on a new screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        imagePath: _image,
                        token: widget.token,
                        client: widget.client,
                        partialInput: widget.partialInput,
                      ),
                    ),
                  );
                }

              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),
          SizedBox(height: 15.0),
          FloatingActionButton(
            heroTag: "Camera",
            child: Icon(Icons.camera_alt),

            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Construct the path where the image should be saved using the
                // pattern package.
                final path = join(
                  // Store the picture in the temp directory.
                  // Find the temp directory using the `path_provider` plugin.
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );

                // Attempt to take a picture and log where it's been saved.
                await _controller.takePicture(path);

                // If the picture was taken, display it on a new screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      imagePath: path,
                      token: widget.token,
                      client: widget.client,
                      partialInput: widget.partialInput,
                    ),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),
        ]));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String token;
  final String partialInput;
  final CoapClient client;

  const DisplayPictureScreen(
      {Key key, this.imagePath, @required this.token, @required this.client,  @required this.partialInput})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String _imgBase64;
  String _data;
  String _message = "";
  String _title = "";

  @override
  void initState() {
    super.initState();
    File file = File(widget.imagePath);
    List<int> imageBytes = file.readAsBytesSync();
    _imgBase64 = base64Encode(imageBytes);
    print(widget.imagePath);
    print(imageBytes);
    print(imageBytes.length);
    print(_imgBase64);
    print(_imgBase64);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          Random random = new Random();
          int randomNumber = random.nextInt(20) + 8;
          //PatientsData().addMeasurement(cpf, randomNumber);
          return AlertDialog(
            title: Text(_title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(_message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 5);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PatientMenuPage(cpf: cpf),
                  //   ),
                  // );
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _getData() async {
      try {
        // Create the request for the get request
        // payload = b"{\"token\": \"bjvhwtzriqjdpeqrrafa\", \"inputData\": \"sexo=0;idade=34;altura=1.5;peso=80.2;imagem=\", \"dataStatus\": \"create\"}"
        // //'{"dataId": "1"}'
        // payload = b"{\"token\": \"bjvhwtzriqjdpeqrrafa\", \"inputData\": \"X2\", \"dataStatus\": \"update\", \"dataId\": \"1\"}"
        // //'{"dataId": "1"}'
        // payload = b"{\"token\": \"bjvhwtzriqjdpeqrrafa\", \"inputData\": \"imagemX64\", \"dataStatus\": \"end\", \"dataId\": \"1\"}"
        // //'{"value": "26.46419197575254"}'

        var _request = CoapRequest.newPut();
        _request.addUriPath('procdata');
        _request.maxRetransmit = 10;
        widget.client.request = _request;

        int max = 60000;
        int len = _imgBase64.length;
        int times = len ~/ max;
        int remainder = len % max;

        print("ANTES DO REQUEST cam");

        var response0 = await widget.client.put(
            "{\"token\": \"${widget.token}\", \"inputData\": \"${widget.partialInput}imagem=${_imgBase64.substring(0, max)}\", \"dataStatus\": \"create\"}");

        Map firstResponse = jsonDecode(response0.payloadString);
        var dataId = firstResponse["dataId"];
        for (int i = 1; i < times; i++) {
          var _request1 = CoapRequest.newPut();
          _request1.addUriPath('procdata');
          _request1.maxRetransmit = 10;
          widget.client.request = _request1;
          var response1 = await widget.client.put(
              "{\"token\": \"${widget.token}\", \"inputData\": \"${_imgBase64.substring(i * max, (i + 1) * max)}\", \"dataStatus\": \"update\", \"dataId\": \"$dataId\"}");
        }

        var _request2 = CoapRequest.newPut();
        _request2.addUriPath('procdata');
        _request2.maxRetransmit = 10;
        widget.client.request = _request2;
        var response = await widget.client.put(
            "{\"token\": \"${widget.token}\", \"inputData\": \"${_imgBase64.substring(len - remainder)}\", \"dataStatus\": \"end\", \"dataId\": \"$dataId\"}");

        print("DEPOIS DO REQUEST cam");

        // widget.client.cancelRequest();

        setState(() {
          if (response == null) {
            _message = "Erro de conexão!";
            _title = "ERRO!";
          } else {
            _data = response.payloadString ?? 'No Data';
            print(_data);
            Map _dataJson = jsonDecode(_data);
            if (_dataJson.containsKey("value")) {
              _title = 'Resultado da Medição';
              _message = '${_dataJson["value"].substring(0,4).replaceAll('.', ',')}% de percentual de gordura. ${_dataJson["message"]}';
            } else {
              _title = "ERRO!";
              _message = "Sessão expirada! Faça o login novamente.";
            }
          }
        });
        _showMyDialog();
      } catch (e) {
        print(e);
      }
    }

    void _onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Carregando..."),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
              ],
            ),
          );
        },
      );
      _getData();
    }

    return Scaffold(
        appBar: AppBar(title: Text('Enviar foto')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SizedBox.expand(
          child: FittedBox(
            child: Image.file(File(widget.imagePath)),
            fit: BoxFit.cover,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_rounded),
          onPressed: () {
            _onLoading();
          },
        ));
  }
}

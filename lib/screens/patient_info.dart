import 'package:flutter/material.dart';
import 'package:first_project/variables/patients_data.dart';
import 'package:first_project/screens/patient_camera.dart';
import 'package:coap/coap.dart';
import 'package:camera/camera.dart';

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

class PatientInfoPage extends StatefulWidget {
  final String token;
  final CoapClient client;

  PatientInfoPage({Key key, @required this.token, @required this.client})
      : super(key: key);

  @override
  _PatientInfoPageState createState() => _PatientInfoPageState();
}

enum SingingCharacter { fem, mas }

class _PatientInfoPageState extends State<PatientInfoPage> {
  SingingCharacter _character = SingingCharacter.fem;
  var patientData = PatientsData().completeHistory;
  TextEditingController _controllerAge;
  TextEditingController _controllerHeight;
  TextEditingController _controllerWeight;

  bool _validateAge = true;
  bool _validateHeight = true;
  bool _validateWeight = true;


  TextStyle warningStyle =
      TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.red);

  void initState() {
    super.initState();
    _controllerAge = TextEditingController();
    _controllerHeight = TextEditingController();
    _controllerWeight = TextEditingController();
    _validateAge = true;
     _validateHeight = true;
     _validateWeight = true;
  }

  void dispose() {
    _controllerAge.dispose();
    _controllerHeight.dispose();
    _controllerWeight.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _node = FocusScope.of(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    final ageField = TextField(
      controller: _controllerAge,
      onEditingComplete: () => _node.nextFocus(),
      // Move focus to next
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Idade (Anos)",
          errorText: _validateAge ? null : 'Preencha com um valor válido!',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final heightField = TextField(
      controller: _controllerHeight,
      onEditingComplete: () => _node.nextFocus(),
      // Move focus to next
      obscureText: false,
      style: style,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Altura (cm)",
          errorText: _validateHeight ? null : 'Preencha com um valor válido!',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final weightField = TextField(
      controller: _controllerWeight,
      onSubmitted: (_) => _node.unfocus(),
      // Submit and hide keyboard
      keyboardType: TextInputType.number,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Peso (kg)",
          errorText: _validateWeight ? null : 'Preencha com um valor válido!',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      // The validator receives the text that the user has entered.
    );


    void _showCamera() async {
      //Form validation
      String _age = _controllerAge.text.replaceAll(',', '.');
      String _height = _controllerHeight.text.replaceAll(',', '.');
      String _weight = _controllerWeight.text.replaceAll(',', '.');
      String _sex = _character == SingingCharacter.fem ? "0" : "1";
      String _partialInput = "sexo=$_sex;idade=$_age;altura=$_height;peso=$_weight;";

      if (_age.isEmpty || !isNumeric(_age)){
        setState(() {_validateAge = false;});
      } else {
        setState(() {_validateAge = true;});
      }
      if (_height.isEmpty || !isNumeric(_height)){
      setState(() {_validateHeight = false;});
      } else {
      setState(() {_validateHeight = true;});
      }
      if (_weight.isEmpty || !isNumeric(_weight)){
      setState(() {_validateWeight = false;});
      } else {
      setState(() {_validateWeight = true;});
      }

      if (_validateAge && _validateHeight && _validateWeight){
        final cameras = await availableCameras();
        final camera = cameras.first;

        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TakePicturePage(
                  camera: camera,
                  token: widget.token,
                  client: widget.client,
                  partialInput: _partialInput,
                )));
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dados do paciente"), //${}
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                            child: Text(
                              "Idade:",
                              style: style,
                            )),
                        Spacer()
                      ],
                    ),
                    ageField,
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              "Altura:",
                              style: style,
                            )),
                        Spacer()
                      ],
                    ),
                    heightField,
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              "Peso:",
                              style: style,
                            )),
                        Spacer()
                      ],
                    ),
                    weightField,
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              "Sexo:",
                              style: style,
                            )),
                        Spacer()
                      ],
                    ),
                    ListTile(
                      title: const Text('Feminino'),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Radio(
                        value: SingingCharacter.fem,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Masculino'),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      leading: Radio(
                        value: SingingCharacter.mas,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.teal,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          _showCamera();
                        },
                        child: Text("Continuar",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

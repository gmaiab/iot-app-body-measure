import 'package:flutter/material.dart';
import 'package:first_project/screens/patient_history.dart';
import 'package:first_project/screens/patient_info.dart';
import 'package:coap/coap.dart';


TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);



class PatientMenuPage extends StatefulWidget {
  final String token;
  final CoapClient client;

  PatientMenuPage({Key key, @required this.token, @required this.client}) : super(key: key);


  @override
  _PatientMenuPageState createState() => _PatientMenuPageState();
}

class _PatientMenuPageState extends State<PatientMenuPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"), //${}
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.teal,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PatientHistoryPage(token: widget.token, client: widget.client,)),
                        );
                      },
                      child: Text("Histórico",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.teal,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PatientInfoPage(token: widget.token, client: widget.client,)),
                        );
                      },
                      child: Text("Nova medição",
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
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:coap/coap.dart';
import 'dart:convert';

class PatientHistoryPage extends StatefulWidget {
  final String token;
  final CoapClient client;

  PatientHistoryPage({Key key, @required this.token, @required this.client}) : super(key: key);

  @override
  _PatientHistoryPageState createState() => _PatientHistoryPageState();
}

class _PatientHistoryPageState extends State<PatientHistoryPage> {
  String _data;
  String _case;
  List _history;
  bool _isLoading = true;

  TextStyle heading = TextStyle(
      fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.bold);
  TextStyle title = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic);
  TextStyle subtitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
  );

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkToken(widget.token);
  }

  Future<void> _checkToken(String token) async {
      try {
        var _request = CoapRequest.newPut();
        _request.addUriPath('histuser');
        _request.maxRetransmit = 3;
        widget.client.request = _request;

        setState(() => _isLoading = true);

        print("ANTES DO REQUEST hist");
        var response = await  widget.client.put("{\"token\": \"$token\"}");
        print("DEPOIS DO REQUEST hist");

        setState(() {
          _isLoading = false;
          print(_data);
          if (response == null) {
            _case = "Bad connection";
          } else {
            _data = response.payloadString ?? 'No Data';
            if (_data[0] == "["){
              _history = json.decode(_data);
              _history = _history.reversed.toList();
              if (_history.length == 0){
                _case = "Empty";
              } else {
                _case = "Success";
              }
            } else {
              _case = "Bad token";
            }
          }
        });

      } catch (e) {
        print(e);
      }
    }

    Widget getWidget(){
      if (_isLoading) {
        return CircularProgressIndicator();
      } else if (_case == "Bad connection"){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Text(
          'Erro de conexão! Tente novamente mais tarde.',
          style: heading,
        ),
      ]
        );
      } else if (_case == "Bad token"){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sessão expirada! Faça o login novamente.',
                style: heading,
              ),
            ]
        );
      } else if (_case == "Empty") {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Não há medições realizadas!',
                style: heading,
              ),
            ]
        );
      } else if (_case == "Success"){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Medições de Percentual de Gordura',
                style: heading,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(2),
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        '${_history[index]['value'].substring(0,4).replaceAll('.', ',')}% de gordura',
                        style: title,
                      ),
                      trailing: Text(
                        '${_history[index]['date'].replaceAll('-', '/')}',
                        style: subtitle,
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                ),
              ),
            ]);
      } else {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Erro!',
                style: heading,
              ),
            ]
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    //String patientName = widget.patientInfo['name'];
    //List patientHistory = widget.patientInfo['history'];



    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico"), //${}
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: getWidget()
          ),
        ),
      ),
    );
  }
}

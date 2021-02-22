// import 'package:first_project/variables/patients_data.dart';
// import 'package:flutter/material.dart';
// import 'package:first_project/screens/patient_menu.dart';
// import 'package:first_project/screens/patient_new.dart';
//
//
// TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
//
// class PatientLoginPage extends StatefulWidget {
//   PatientLoginPage({Key key}) : super(key: key);
//
//   @override
//   _PatientLoginPageState createState() => _PatientLoginPageState();
// }
//
// class _PatientLoginPageState extends State<PatientLoginPage> {
//   TextEditingController _controller;
//
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }
//
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _node = FocusScope.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Informar paciente"),
//       ),
//       body: Center(
//         child: Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(36.0),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   TextField(
//                     controller: _controller,
//                     onSubmitted: (_) => _node.unfocus(),
//                     // Submit and hide keyboard
//                     obscureText: false,
//                     style: style,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                         hintText: "CPF do Paciente",
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(32.0))),
//                   ),
//                   SizedBox(height: 25.0),
//                   Material(
//                     elevation: 5.0,
//                     borderRadius: BorderRadius.circular(30.0),
//                     color: Colors.teal,
//                     child: MaterialButton(
//                       minWidth: MediaQuery.of(context).size.width,
//                       padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                       onPressed: () {
//                         if (PatientsData().isNewPatient(_controller.text)){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     PatientRegisterPage(cpf: _controller.text)),
//                           );
//                         } else {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     PatientMenuPage(cpf: _controller.text)),
//                           );
//                         }
//                       },
//                       child: Text("Ok",
//                           textAlign: TextAlign.center,
//                           style: style.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold)),
//                     ),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

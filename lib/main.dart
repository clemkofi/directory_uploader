import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'First Timers Uploader',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(title: 'First Timers Uploader Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // variables for form values
  String _name;
  String _tel_number;
  String _email;
  String _valueDOB = 'No Date Selected!';
  String _valueDOA = 'No Date Selected!';
  String _occupation;
  String _place_of_work;
  String _inviter_name;

  // variable for membership
  String _member = "Yes";

  // variable for student
  String _student = "Yes";

  // variables for student info
  String _school;
  String _programme;
  String _hall_hostel;
  String _room_number;
  String _area;

  // varibles for non_student info
  String _residence;
  String _house_num;
  String _landmark;

  int year = DateTime.now().year + 1;

  // key form the form to help validation
  final formKey = new GlobalKey<FormState>();

  //varible to keep the position of the inviter
  String _inviter_position = "Brother";

  // list array to keep the positions of the inviters
  List<String> inviter_position = ["Brother", "Leader", "Deacon", "Bishop", "Pastor"];

  // function for the date picker for the date of birth
  Future _selectDateofBirth() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime(1999, 1, 1),
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2006));
    if (picked != null)
      setState(() => _valueDOB = picked.toString().substring(0, 10));
  }

  // function for the date picker for the date of attendance
  Future _selectDateofAttendance() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2014),
        lastDate: new DateTime(year)
    );
    if (picked != null)
      setState(() => _valueDOA = picked.toString().substring(0, 10));
  }

  // function to change the value of the inviter position
  void _setInviterPosition(String position){
    setState(() => _inviter_position = position);
  }

  // function to set the membership status of first timer
  void _setMemberStatus(String value){
    setState(() => _member = value);
  }

  // function to set the student status of first timer
  void _setStudentStatus(String value){
    if (value == "Yes"){
      _studentRadioChanged(true, "student");
    } else if (value == "No") {
      _studentRadioChanged(true, "non_student");
    }
    setState(() => _student = value);
  }

  // visibility status of student or non-student info form
  bool visibility_student = true;
  bool visibility_non_student = false;

  void _studentRadioChanged(bool visibility, String radio_chosen) {
    setState(() {
      if (radio_chosen == "student"){
        visibility_student = visibility;
        visibility_non_student = !visibility;
      }
      if (radio_chosen == "non_student"){
        visibility_non_student = visibility;
        visibility_student = !visibility;
      }
    });
  }

  void _submit() {
    final formState = formKey.currentState;

    if(formState.validate()){
      formState.save();

      // _performLogin();
    }
  }

  void _reset(){
    final formState = formKey.currentState;

    formState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            leading: Icon(Icons.list),
            title: new Text(widget.title),
            backgroundColor: Colors.teal
            ),
        body: new LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: new ConstrainedBox(
            constraints:
                new BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: new Container(
              padding: new EdgeInsets.all(20.0),
              child: new Form(
                  key: formKey,
                  child: new Column(
                  children: <Widget>[
                    // full name entry
                    new TextFormField(
                      initialValue: _name,
                      decoration: new InputDecoration(
                          hintText: "Full Name",
                          labelText: "Full Name",
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      validator: (val) => val.trim().length < 3 ? 'Invalid Name' : null,
                      onSaved: (val) => _name = val.trim(),
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // telephone number entry
                    new TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                          hintText: "Tel Number",
                          labelText: "Tel Number",
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      validator: (val) => val.trim().length < 10 ? 'Invalid Number' : null,
                      onSaved: (val) => _tel_number = val.trim(),
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // email entry
                    new TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                          hintText: "email",
                          labelText: "email",
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      validator: (val) => !val.contains('@')||!val.contains('.') ? 'Invalid Email' : null,
                      onSaved: (val) => _email = val
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // Date of Birth Entry
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                              new Text(
                               "Date of Birth",
                               style: new TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18.0
                                 ),
                                ),

                              new Text(_valueDOB),       
                           ],
                        ),
                        
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: _selectDateofBirth,
                              child: new Text("Select Date"),
                              textColor: Colors.white,
                              color: Colors.blue,
                            ),
                          ],
                        )
                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // Date of Attendace Entry
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,                        
                           children: <Widget>[
                              new Text(
                               "Date of Attendace",
                               style: new TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18.0
                                 ),
                                ),

                              new Text(_valueDOA),       
                           ],
                        ),
                        
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new RaisedButton(
                              onPressed: _selectDateofAttendance,
                              child: new Text("Select Date"),
                              textColor: Colors.white,
                              color: Colors.blue,
                            ),
                          ],
                        )
                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // occupation entry
                    new TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Occupation",
                          labelText: "Occupation",
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onSaved: (val) => _occupation = val.trim(),
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // Place of Work entry
                    new TextFormField(
                      maxLines: 2,
                      decoration: new InputDecoration(
                          hintText: "Place of Work",
                          labelText: "Place of Work",
                          border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onSaved: (val) => _place_of_work = val.trim(),
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Who Invited you?",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              child: // Position of Inviter
                                new DropdownButton(
                                    onChanged: (String position){
                                      _setInviterPosition(position);
                                    },
                                    value: _inviter_position,
                                    items: inviter_position.map((String position){
                                      return new DropdownMenuItem(
                                        value: position,
                                        child: new Text(position),
                                      );
                                    }).toList(),
                                  ),
                            ),

                            new Flexible(
                              child: // Name of Inviter
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      hintText: "Name",
                                      border: new OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0)
                                        )
                                      ),
                                    validator: (val) => val.trim().length < 3 ? 'Invalid Name' : null,
                                    onSaved: (val) => _inviter_name = val.trim(),
                                  ), 
                            )
                          ],
                        )
                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Member?",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: new RadioListTile(
                                value: "Yes",
                                title: new Text("Yes"),
                                groupValue: _member,
                                onChanged: (String value){
                                  _setMemberStatus(value);
                                },
                              ),
                            ),

                            new Flexible(
                              child: new RadioListTile(
                                value: "No",
                                title: new Text("No"),
                                groupValue: _member,
                                onChanged: (String value){
                                  _setMemberStatus(value);
                                },
                              ),
                            )

                          ],
                        )
                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Student?",
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),

                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: new RadioListTile(
                                value: "Yes",
                                title: new Text("Yes"),
                                groupValue: _student,
                                onChanged: (String value){
                                  _setStudentStatus(value);
                                },
                              ),
                            ),

                            new Flexible(
                              child: new RadioListTile(
                                value: "No",
                                title: new Text("No"),
                                groupValue: _student,
                                onChanged: (String value){
                                  _setStudentStatus(value);
                                },
                              ),
                            )

                          ],
                        )
                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    // Student/Non-student details
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                          // show if the person is a student
                          visibility_student ? new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Student Info",
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                                ),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // School Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "School",
                                    labelText: "School",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                validator: (val) => val.trim().length < 2 ? 'Invalid Name' : null,
                                onSaved: (val) => _school = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Programme Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Programme",
                                    labelText: "Programme",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _programme = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Hall/Hostel Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Hall/Hostel",
                                    labelText: "Hall/Hostel",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _hall_hostel = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Room Number Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Room Number",
                                    labelText: "Room Number",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _room_number = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Area Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Area",
                                    labelText: "Area",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _area = val.trim(),
                              ),

                            ],
                          ) : new Container(),

                          // show if the person is not a student
                          visibility_non_student ? new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Non Student Info",
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                                ),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Residence Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Residence",
                                    labelText: "Residence",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                validator: (val) => val.trim().length < 3 ? 'Invalid Residence' : null,
                                onSaved: (val) => _residence = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // House No. Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "House No.",
                                    labelText: "House No.",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _house_num = val.trim(),
                              ),

                              new Padding(padding: const EdgeInsets.only(top: 8.0)),

                              // Landmark Entry
                              new TextFormField(
                                decoration: new InputDecoration(
                                    hintText: "Landmark",
                                    labelText: "Landmark",
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0)
                                      )
                                  ),
                                onSaved: (val) => _landmark = val.trim(),
                              ),

                            ],
                          ) : new Container(),

                      ],
                    ),

                    new Padding(padding: const EdgeInsets.only(top: 20.0)),

                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                  
                        new MaterialButton( 
                          height: 50.0, 
                          minWidth: 150.0, 
                          color: Colors.blue, 
                          textColor: Colors.white, 
                          child: new Text("Submit"), 
                          onPressed: _submit, 
                          splashColor: Colors.white24,
                        ),

                        new MaterialButton( 
                          height: 50.0, 
                          minWidth: 150.0, 
                          color: Colors.red, 
                          textColor: Colors.white, 
                          child: new Text("Reset"), 
                          onPressed: _reset, 
                          splashColor: Colors.white24,
                        ),

                      ],
                    )

                  ],
                ),
              ),
            ),
          ));
          })
    );
  }
}

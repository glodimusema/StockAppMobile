import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';

import '../MyClasses/cls_glossaire.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();

  TextEditingController passController = TextEditingController();
  late AutovalidateMode _autoValidate1 = AutovalidateMode.disabled;
  void _validateInputsLog(BuildContext ctx) async {
    setState(() {
      checking = true;
    });

    if (_formKey1.currentState!.validate()) {
      //    If all data are correct then save data to out variables
      _formKey1.currentState?.save();
      //login
      await Glossaire.mylogin(
          _scaffoldKey, context, userController.text, passController.text);
      setState(() {
        userController.text = "";
        passController.text = "";
        checking = false;
      });
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate1 = AutovalidateMode.always;
      });
    }
  }

  bool checking = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: MyColors.backgroundColor,
        ),
        child: Form(
          key: _formKey1,
          autovalidateMode: _autoValidate1,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  // decoration: BoxDecoration(
                  //   image: new DecorationImage(
                  //     image: AssetImage(background),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 5,
                      bottom: MediaQuery.of(context).size.width / 8),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 0.0),
                        child: Opacity(
                          opacity: 0.9,
                          child: Image.asset(
                            'assets/logo.png',
                            colorBlendMode: BlendMode.color,
                            height: 70.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "Email.",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.grey.withOpacity(0.5),
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: userController,
                        cursorColor: MyColors.primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your Email.',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Enter your email.!!!';
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: Text(
                  "Secret Code",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Icon(
                        Icons.lock_open,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.grey.withOpacity(0.5),
                      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passController,
                        cursorColor: MyColors.primaryColor,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Enter your password!!!';
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              checking
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: MyColors.primaryColor,
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton(
                              style: ButtonStyle(
                                  minimumSize:
                                      MaterialStateProperty.all(Size(130, 40)),
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      MyColors.primaryColor)),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(30.0)),
                              // //splashColor: MyColors.primaryColor,
                              // color: MyColors.primaryColor,

                              child: Row(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(15.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: FilledButton(
                                        // shape:  RoundedRectangleBorder(
                                        //     borderRadius:
                                        //          BorderRadius.circular(28.0)),
                                        // splashColor: Colors.white,
                                        // color: Colors.white,
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: MyColors.primaryColor,
                                        ),
                                        onPressed: () {
                                          _validateInputsLog(context);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                _validateInputsLog(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton(
                        // shape:  RoundedRectangleBorder(
                        //     borderRadius:  BorderRadius.circular(30.0)),
                        // color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Password already forgotten?",
                            style: TextStyle(color: MyColors.primaryColor),
                          ),
                        ),
                        onPressed: () => {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // This trailing comma make
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

import 'package:fishapp/config/routes/route_data.dart';
import 'package:fishapp/config/routes/routes.dart' as routes;
import 'package:fishapp/generated/l10n.dart';
import 'package:fishapp/utils/form/form_validators.dart';
import 'package:fishapp/utils/services/auth_service.dart';
import 'package:fishapp/utils/services/fishapp_rest_client.dart';
import 'package:fishapp/widgets/form/formfield_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entities/user.dart';

class RegisterUserForm extends StatefulWidget {
  RegisterUserForm({Key key, this.returnRoute}) : super(key: key);
  final authService = AuthService();
  final LoginReturnRouteData returnRoute;

  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = false;
  UserNewData _newUserFormData;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _newUserFormData = UserNewData();
  }

  void _handleRegister(BuildContext context) async {
    final FormState formState = _formKey.currentState;
    setState(() {
      _errorMessage = "";
    });
    formState.save();
    if (formState.validate()) {
      try {
        await widget.authService.createUser(_newUserFormData);
        var suc = await widget.authService.loginUser(UserLoginData(
            userName: _newUserFormData.userName,
            password: _newUserFormData.password));
        if (suc) {
          Navigator.removeRouteBelow(context, ModalRoute.of(context));
          Navigator.popAndPushNamed(
              context, widget.returnRoute?.path ?? routes.HOME,
              arguments: widget.returnRoute?.pathParams);
        }
      } on ApiException catch (e) {
        setState(() {
          //TODO: om bruker allerede eksisterer burde man få beskjed om det
          _errorMessage = S.of(context).msgErrorServerFail;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FormFieldAuth(
              initialValue: "testb",
              title: S.of(context).name,
              hint: S.of(context).fullName,
              keyboardType: TextInputType.name,
              onSaved: (newValue) => {_newUserFormData.name = newValue},
              validator: (value) {
                return validateNotEmptyInput(value, context);
              },
            ),
            FormFieldAuth(
              initialValue: "testb@example.com",
              title: capitalize(S.of(context).email),
              hint: S.of(context).emailHint,
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) => {_newUserFormData.userName = newValue},
              validator: (value) {
                return validateEmail(value, context);
              },
            ),
            FormFieldAuth(
              initialValue: "12345678",
              title: capitalize(S.of(context).password),
              hint: S.of(context).passwordHint,
              keyboardType: TextInputType.text,
              onSaved: (newValue) => {_newUserFormData.password = newValue},
              validator: (value) {
                return validateLength(value, context, min: 8);
              },
              isObscured: true,
            ),
            FormFieldAuth(
              initialValue: "12345678",
              title: S.of(context).confirmPassword,
              hint: S.of(context).confirmPasswordHint,
              keyboardType: TextInputType.text,
              validator: (value) {
                return validateEquality(value, _newUserFormData.password,
                    S.of(context).password, context);
              },
              isObscured: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Checkbox(value: _agreedToTOS, onChanged: _setAgreedToTOS),
                  GestureDetector(
                      onTap: () => _setAgreedToTOS(!_agreedToTOS),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: S.of(context).tos1,
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                              text: S.of(context).tos2,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).accentColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(
                                      "https://www.maoyi.no/info/terms-of-service.pdf");
                                })
                        ]),
                      ))
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style.copyWith(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10))),
                  onPressed: () {
                    if (_agreedToTOS) {
                      _handleRegister(context);
                    }
                  },
                  child: Text(
                    S.of(context).createUser.toUpperCase(),
                    style: Theme.of(context).primaryTextTheme.headline5,
                  )),
            ),
            Center(
              child: Text(
                _errorMessage,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            )
          ]),
        ));
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}

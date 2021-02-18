import 'dart:io';

import 'package:flutter/material.dart';
import 'package:***REMOVED***/config/routes/route_data.dart';
import 'package:***REMOVED***/config/routes/routes.dart' as routes;
import 'package:***REMOVED***/generated/l10n.dart';
import 'package:***REMOVED***/pages/register/new_user_form_data.dart';
import 'package:***REMOVED***/utils/form/form_validators.dart';
import 'package:***REMOVED***/utils/services/auth_service.dart';
import 'package:***REMOVED***/widgets/form/formfield_auth.dart';
import 'package:strings/strings.dart';

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
  NewUserFormData _newUserFormData;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _newUserFormData = NewUserFormData();
  }

  void _handleRegister(BuildContext context) async {
    print(widget.returnRoute?.path);
    final FormState formState = _formKey.currentState;
    setState(() {
      _errorMessage = "";
    });
    formState.save();
    if (formState.validate()) {
      try {
        await widget.authService.createUser(context, _newUserFormData);
        bool suc =
            await widget.authService.loginUser(context, _newUserFormData);
        if (suc) {
          Navigator.removeRouteBelow(context, ModalRoute.of(context));
          Navigator.popAndPushNamed(
              context, widget.returnRoute?.path ?? routes.Home,
              arguments: widget.returnRoute?.pathParams);
        }
      } on CreateUserException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } on HttpException catch (e) {
        setState(() {
          _errorMessage = e.message;
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
              title: S.of(context).name,
              hint: S.of(context).fullName,
              keyboardType: TextInputType.name,
              onSaved: (newValue) => {_newUserFormData.name = newValue},
              validator: (value) {
                return validateNotEmptyInput(value, context);
              },
            ),
            FormFieldAuth(
              title: capitalize(S.of(context).email),
              hint: S.of(context).emailHint,
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) => {_newUserFormData.email = newValue},
              validator: (value) {
                return validateEmail(value, context);
              },
            ),
            FormFieldAuth(
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
                    child: Text(
                      S.of(context).tos,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
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
            Text(
              _errorMessage,
              style: TextStyle(color: Theme.of(context).errorColor),
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

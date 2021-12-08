import "package:form_field_validator/form_field_validator.dart";

class MobileNoValidator extends TextFieldValidator {
  @override
  bool get ignoreEmptyValues => true;

  MobileNoValidator({String errorText}) : super(errorText);

  @override
  bool isValid(String value) {
    final pattern = RegExp(r'^(09\d{9})$');

    return pattern.hasMatch(value);
  }
}
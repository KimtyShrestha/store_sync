import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email){
  return email.contains("@");
}

void main(){

  test("valid email returns true", (){
    expect(isValidEmail("user@mail.com"), true);
  });

  test("invalid email returns false", (){
    expect(isValidEmail("usermail.com"), false);
  });

}
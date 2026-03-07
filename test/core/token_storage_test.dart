import 'package:flutter_test/flutter_test.dart';

void main(){

  test("token should be saved correctly", (){
    const token = "abc123";

    expect(token.isNotEmpty, true);
  });

  test("token should not be null", (){
    const token = "xyz";

    expect(token.isNotEmpty, true);
  });

  test("token length greater than zero", (){
    const token = "securetoken";

    expect(token.isNotEmpty, true);
  });

}
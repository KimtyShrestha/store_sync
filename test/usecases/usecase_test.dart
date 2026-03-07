import 'package:flutter_test/flutter_test.dart';

bool loginLogic(String email, String password) {
  return email.contains("@") &&
         email.contains(".") &&
         password.length >= 6;
}

void main() {

  test("login success with valid credentials", () {
    expect(loginLogic("user@mail.com", "123456"), true);
  });

  test("login fails with empty email", () {
    expect(loginLogic("", "123456"), false);
  });

  test("login fails with short password", () {
    expect(loginLogic("user@mail.com", "123"), false);
  });

  test("login success with strong password", () {
    expect(loginLogic("admin@mail.com", "password123"), true);
  });

  test("login fails when both fields empty", () {
    expect(loginLogic("", ""), false);
  });

  test("email with domain works", () {
    expect(loginLogic("store@sync.com", "123456"), true);
  });

  test("password minimum length", () {
    expect(loginLogic("a@b.com", "123456"), true);
  });

  test("password less than six fails", () {
    expect(loginLogic("a@b.com", "12345"), false);
  });
  

  test("random credentials valid", () {
    expect(loginLogic("demo@test.com", "abcdef"), true);
  });

  test("invalid credentials rejected", () {
    expect(loginLogic("", "abc"), false);
  });

  test("login accepts uppercase email", () {
  expect(loginLogic("USER@MAIL.COM", "123456"), true);
});

test("login accepts mixed case password", () {
  expect(loginLogic("user@mail.com", "Pass123"), true);
});

test("login fails when password empty", () {
  expect(loginLogic("user@mail.com", ""), false);
});

test("login fails when email missing domain", () {
  expect(loginLogic("user@mail", "123456"), false);
});

test("login fails when spaces only", () {
  expect(loginLogic(" ", " "), false);
});

}
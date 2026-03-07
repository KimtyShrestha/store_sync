class ApiEndpoints {
  static const baseUrl = "http://10.0.2.2:5050/api";

  // Auth
  static const register = "/auth/register";
  static const login = "/auth/login";
  static const logout = "/auth/logout";
  static const changePassword = "/auth/change-password";


  // Records
  static const dailyRecordBase = "/daily-record";
  static const todayRecord = "/daily-record/today";
  static const historyRecord = "/daily-record/history";
}


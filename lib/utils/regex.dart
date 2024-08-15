class RegexProvider {
  // Email
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Password
  static final RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');

  // Udyam Number
  static final RegExp udyamRegex = RegExp(r'^UDYAM-[A-Z]{2}-\d{2}-\d{7}$');

  // UUID
  static final RegExp uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');

  // GST Number
  static final RegExp gstRegex = RegExp(
      r'^[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[CZ]{1}[0-9a-zA-Z]{1}$|^[0-9]{4}[a-zA-Z]{3}[0-9]{5}[uUnN]{2}[0-9a-zA-Z]{1}$');

  // OTP
  static final RegExp otpRegex = RegExp(r'^[0-9]{6}$');

  // Phone Number
  static final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');

  // Pan Number
  static final RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
}

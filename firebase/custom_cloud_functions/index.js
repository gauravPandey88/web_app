const admin = require("firebase-admin/app");
admin.initializeApp();

const sendPhoneNumberFunction = require("./send_phone_number_function.js");
exports.sendPhoneNumberFunction =
  sendPhoneNumberFunction.sendPhoneNumberFunction;

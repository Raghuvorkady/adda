import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//colours
final Color appYellow = HexColor("#FDDB3A");
final Color appBlack = HexColor("#444444");
final Color appLightBlack = HexColor("#52575D");
final Color appBackground = HexColor("#F6F4E6");
final Color appLightGrey = HexColor("#F4F4F4");
final Color contactChatBubbleColor = HexColor("#F4F4F4");
final Color appChatOrange = HexColor("#EEBB4D");
final Color myChatBubbleColor = HexColor("#DEE8FE");
final Color appChatGreen = HexColor("#96BB7C");
final Color appMessageBarColor = HexColor("#949694");
final Color buttonEnabledColor = HexColor("#7998DF");
final Color attachButtonDisabledColor =HexColor("#999999");
final Color sendButtonDisabledColor = HexColor("#999999");
//images
//TODO make strings final
final String logoWithName = "assets/logos/logo-with-name.png";
final String logoCircle = "assets/logos/logo-circle.png";
final String logoSquare = "assets/logos/logo-square.png";
final String eyeOn = "assets/icons/eye-off.png";
final String eyeOff = "assets/icons/eye-on.png";
final String noImage = "assets/images/img_not_available.jpeg";

final String defaultProfile = "https://firebasestorage.googleapis.com/v0/b/adda-12929.appspot.com/o/Default%20user%20config%2Fbaseline_account_circle_white_48dp.png?alt=media&token=69ab803d-e78c-45e1-8441-22690506283b";

//icons
final String galleryIcon = "assets/icons/gallery.png";
final IconData gallery = Image.asset(galleryIcon) as IconData;
//strings
final String email = "email";
final String pwd = "password";
final String cnfPwd = "confirm password";
final String newPwd = "new password";
final String signIn = "Sign in";
final String signUp = "Sign up";
final String forgotPwd = "Forgot password?";
final String noAccount = "Don’t have an account?";
final String yesAccount = "Already having an account?";
final String otpSent = "OTP has been sent to your registered mail id: ";
final String big =
    "Simple chat bubble consist of two parts: Text and time label. In simple case, they are almost positioned on the same baseline. Even when the text is multiline (baseline with last line). But in some cases, when there is no free space and the texts are trying to intersect, an indent is added at the bottom of bubble.";
final String enterOtp = "Enter OTP within 1min 59s:";
final String otpResend = "Did not receive OTP?";
final String enterRegisteredMail = "Enter your registered mail id:";
final String otpToMail = "OTP will be sent to the mail";
final String accountVerify = "Verify your account";
final String proceed = "Proceed";
final String search = "Search";
final String messageBoxHint = "Type your message here";

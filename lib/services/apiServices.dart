import 'package:astro_app/services/servicesManeger.dart';

class APIData {
  //Auth profile Api
  static const String baseURL = 'https://thecityofjoy.in/anjan/';

  static const String login = '${baseURL}api/login';
   static const String registration = '${baseURL}api/register';

  static const String userDetails = '${baseURL}api/user-info';

  static const String updateUser = '${baseURL}api/update-profile';
  static const String getUserList = '${baseURL}api/get_user_list';
  static const String getStateAndDistrict='${baseURL}api/state-list';

  static const String sendForgotPassOtp = '${baseURL}api/send-otp';

  static const String verifyOtpForgotPass = '${baseURL}api/verify-otp';
  static const String chnagePassword = '${baseURL}api/forgot-password';


  //Appointment Api
  static const String createAppointment = '${baseURL}api/appointment-info';
  static const String getAvailableSlot = '${baseURL}api/booking-schedule';
   static const String bookSlot = '${baseURL}api/booked-appointment';

   static const String myAppointments = '${baseURL}api/my-appointments';

   static const String appointmentDetail = '${baseURL}api/appointments';

   //chat
   static const String getChatData = '${baseURL}api/chats';
   static const String sendMessage = '${baseURL}api/send-message';

   //gallery
   static const String getGalleyData='${baseURL}api/galleries';

   //chembers
   static const String chembersData='${baseURL}api/chambers';
   //achievements
   static const String achievements='${baseURL}api/achievements';


   //rsahifal
   static const String rashiFals='${baseURL}api/rashifals';

   static const String rashiDetails='${baseURL}api/rashifal-info';

   //contact us
   static const String contactUs='${baseURL}api/contact-request';












  //Header
    static Map<String, String> kHeader = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${ServiceManager.tokenID}',
  };
}

import '../../models/bookings.dart';
import '../../repository/web_services.dart';
import '../models/chatWithAttachments.dart';

class BookingRepository {
  final WebServices webServices;
  BookingRepository(this.webServices);

  Future<String> bookingService(String token, String appointmentId, String lawyerId, String subId, String mainId,
      String date, String courtQuestion, String wayToCommunicate, String courtId, String pay, List answers) async {
    final bookingMessage = await webServices.bookingServiceWeb(
        token, appointmentId, lawyerId, subId, mainId, date, courtQuestion, wayToCommunicate, courtId, pay, answers);
    print('Booking Message from Repo==========> ' + bookingMessage);
    return bookingMessage;
  }

  Future<List<Bookings>> getBookings(String token) async {
    final bookingsList = await webServices.getBookings(token);
    // print('Booking List from Repo =========>' + bookingsList.toString());
    return bookingsList.map((bookings) => Bookings.fromJson(bookings)).toList();
  }

  Future<String> bookingServiceWithoutLawyers(
      String token, String mainId, String courtId, String subId, String courtAnswer, List answers) async {
    final bookingMessage =
        await webServices.bookingServiceWithoutLawyer(token, mainId, courtId, subId, courtAnswer, answers);
    print('Booking Message from Repo==========> ' + bookingMessage);
    return bookingMessage;
  }

  Future<List<Bookings>> getBookingsWithoutLawyers(String token) async {
    final bookingsList = await webServices.getBookingsWithoutLawyers(token);
    // print('Booking List from Repo =========>' + bookingsList.toString());
    return bookingsList.map((bookings) => Bookings.fromJson(bookings)).toList();
  }

  Future<bool> verifyPayment(String token, String bookingId, String paymentId) async {
    final statusOfVerifyPayment = await webServices.verifyPayment(token, bookingId, paymentId);
    return statusOfVerifyPayment;
  }

  Future<bool> verifyServicePayment(String token, String bookingId, String paymentId) async {
    final statusOfVerifyPayment = await webServices.verifyServicePayment(token, bookingId, paymentId);
    return statusOfVerifyPayment;
  }

  Future<String> updateBookingService(String token, String bookingId, String appointmentId, String date,
      String lawyerId, String wayToCommunicate) async {
    final updateBookingMessage =
        await webServices.updateBookingService(token, bookingId, appointmentId, date, lawyerId, wayToCommunicate);
    print('Update Booking Message from Repo==========> ' + updateBookingMessage);
    return updateBookingMessage;
  }

  Future<bool> startQuickChat(String token) async {
    final statusOfStartQuickChat = await webServices.startQuickChat(token);
    print('status of StartQuickChat ' + statusOfStartQuickChat.toString());
    return statusOfStartQuickChat;
  }

  Future<bool> checkQuickChat(String token) async {
    final statusOfCheckQuickChat = await webServices.checkQuickChat(token);
    print('status of checkQuickChat ' + statusOfCheckQuickChat.toString());
    return statusOfCheckQuickChat;
  }

  Future<List<ChatWithAttachments>> getChatWithAttachments(String token, String bookingId) async {
    final chatsList = await webServices.getChatWithAttachments(token, bookingId);
    // print('chatsWithAttachments=====> ' + chatsList.toString());
    return chatsList.map((chats) => ChatWithAttachments.fromJson(chats)).toList();
  }
}

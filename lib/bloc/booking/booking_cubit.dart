import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/bookings.dart';
import '../../models/chatWithAttachments.dart';
import '../../repository/booking_repository.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository bookingRepo;
  String? bookingMessage;
  String? updateBookingMessage;
  bool statusOfStartingQuickChat = false;
  bool statusOfCheckQuickChat = false;
  bool statusOfVerifyingPayment = false;
  bool statusOfVerifyingServicePayment = false;
  List<Bookings> bookingsList = [];
  List<ChatWithAttachments> chatsWithAttachmentList = [];
  BookingCubit(this.bookingRepo) : super(BookingInitial());

  Future<String> bookingService(String token, String appointmentId, String lawyerId, String subId, String mainId,
      String date, String courtQuestion, String wayToCommunicate, String courtId, String pay, List answers) async {
    await bookingRepo
        .bookingService(
            token, appointmentId, lawyerId, subId, mainId, date, courtQuestion, wayToCommunicate, courtId, pay, answers)
        .then((message) {
      emit(BookingServiceState(message));
      this.bookingMessage = message;
    });
    return bookingMessage!;
  }

  Future<List<Bookings>> getBookings(String token) async {
    await bookingRepo.getBookings(token).then((bookings) {
      emit(GetBookingsState(bookings));
      this.bookingsList = bookings;
    });
    return bookingsList;
  }

  Future<String> bookingServiceWithoutLawyers(
      String token, String mainId, String courtId, String subId, String courtAnswer, List answers) async {
    await bookingRepo.bookingServiceWithoutLawyers(token, mainId, courtId, subId, courtAnswer, answers).then((message) {
      emit(BookingServiceWithoutLawyersState(message));
      this.bookingMessage = message;
    });
    return bookingMessage!;
  }

  Future<List<Bookings>> getBookingsWithoutLawyers(String token) async {
    await bookingRepo.getBookingsWithoutLawyers(token).then((bookings) {
      emit(GetBookingsWithoutLawyersState(bookings));
      this.bookingsList = bookings;
    });
    return bookingsList;
  }

  Future<bool> verifyPayment(String token, String bookingId, String paymentId) async {
    await bookingRepo.verifyPayment(token, bookingId, paymentId).then((statusOfVerifyingPayment) {
      emit(VerifyPaymentState(statusOfVerifyingPayment));
      this.statusOfVerifyingPayment = statusOfVerifyingPayment;
    });
    return statusOfVerifyingPayment;
  }

  Future<bool> verifyServicePayment(String token, String bookingId, String paymentId) async {
    await bookingRepo.verifyServicePayment(token, bookingId, paymentId).then((statusOfVerifyingPayment) {
      emit(VerifyServicePaymentState(statusOfVerifyingPayment));
      this.statusOfVerifyingServicePayment = statusOfVerifyingPayment;
    });
    return statusOfVerifyingServicePayment;
  }

  Future<String> updateBookingService(String token, String bookingId, String appointmentId, String date,
      String lawyerId, String wayToCommunicate) async {
    await bookingRepo
        .updateBookingService(token, bookingId, appointmentId, date, lawyerId, wayToCommunicate)
        .then((message) {
      emit(BookingServiceState(message));
      this.updateBookingMessage = message;
    });
    return updateBookingMessage!;
  }

  Future<bool> startQucikChat(String token) async {
    await bookingRepo.startQuickChat(token).then((statusOfStartingQuickChat) {
      emit(StartQuickChatState(statusOfStartingQuickChat));
      this.statusOfStartingQuickChat = statusOfStartingQuickChat;
    });
    return statusOfStartingQuickChat;
  }

  Future<bool> checkQucikChat(String token) async {
    await bookingRepo.checkQuickChat(token).then((statusOfCheckQuickChat) {
      emit(CheckQuickChatState(statusOfCheckQuickChat));
      this.statusOfCheckQuickChat = statusOfCheckQuickChat;
    });
    return statusOfCheckQuickChat;
  }

  Future<List<ChatWithAttachments>> getChatWithAttachments(String token, String bookingId) async {
    await bookingRepo.getChatWithAttachments(token, bookingId).then((chatsList) {
      emit(GetChatWithAttachments(chatsList));
      this.chatsWithAttachmentList = chatsList;
    });
    return chatsWithAttachmentList;
  }
}

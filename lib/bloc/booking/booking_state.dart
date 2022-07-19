part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingServiceState extends BookingState {
  final String bookingMessage;
  BookingServiceState(this.bookingMessage);
}

class GetBookingsState extends BookingState {
  final List<Bookings> bookingsList;
  GetBookingsState(this.bookingsList);
}

class BookingServiceWithoutLawyersState extends BookingState {
  final String bookingMessage;
  BookingServiceWithoutLawyersState(this.bookingMessage);
}

class GetBookingsWithoutLawyersState extends BookingState {
  final List<Bookings> bookingsList;
  GetBookingsWithoutLawyersState(this.bookingsList);
}

class VerifyPaymentState extends BookingState {
  final bool statusOfVerifyingPayment;
  VerifyPaymentState(this.statusOfVerifyingPayment);
}

class VerifyServicePaymentState extends BookingState {
  final bool statusOfVerifyingPayment;
  VerifyServicePaymentState(this.statusOfVerifyingPayment);
}

class UpdateBookingServiceState extends BookingState {
  final String updateBookingMessage;
  UpdateBookingServiceState(this.updateBookingMessage);
}

class StartQuickChatState extends BookingState {
  final bool statusOfStartQuickChat;
  StartQuickChatState(this.statusOfStartQuickChat);
}

class CheckQuickChatState extends BookingState {
  final bool statusOfCheckQuickChat;
  CheckQuickChatState(this.statusOfCheckQuickChat);
}

class GetChatWithAttachments extends BookingState {
  final List<ChatWithAttachments> chatsList;
  GetChatWithAttachments(this.chatsList);
}

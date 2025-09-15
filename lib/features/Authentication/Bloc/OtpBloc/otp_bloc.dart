import 'dart:async';
import 'package:bloc/bloc.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  Timer? _timer;

  OtpBloc() : super(const OtpState(remaining: 60, canResend: false)) {
    on<OtpTimerStarted>(_onTimerStarted);
    on<OtpTick>(_onTick);
  }

  Future<void> _onTimerStarted(
    OtpTimerStarted event,
    Emitter<OtpState> emit,
  ) async {
    // Cancel old timer if exists
    _timer?.cancel();

    emit(OtpState(remaining: event.duration, canResend: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newRemaining = state.remaining - 1;

      if (newRemaining > 0) {
        add(OtpTick(newRemaining)); // ✅ dispatch event instead of emit
      } else {
        timer.cancel();
        add(const OtpTick(0));
      }
    });
  }

  void _onTick(OtpTick event, Emitter<OtpState> emit) {
    emit(OtpState(remaining: event.remaining, canResend: event.remaining == 0));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

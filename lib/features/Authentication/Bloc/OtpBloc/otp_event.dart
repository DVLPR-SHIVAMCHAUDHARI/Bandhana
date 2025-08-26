abstract class OtpEvent {
  const OtpEvent();
}

class OtpTimerStarted extends OtpEvent {
  final int duration;
  const OtpTimerStarted(this.duration);
}

class OtpTick extends OtpEvent {
  final int remaining;
  const OtpTick(this.remaining);
}

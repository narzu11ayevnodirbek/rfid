/// Progress of a one-off action such as "send to server".
///
/// Pages react to the change of this value in a `BlocListener` (close the
/// page on success, show a dialog on failure); the bloc never navigates.
enum SubmitStatus {
  idle,
  submitting,
  succeeded,
  failed;

  bool get isSubmitting => this == submitting;
}

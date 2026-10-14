enum SubmitStatus {
  idle,
  submitting,
  succeeded,
  failed;

  bool get isSubmitting => this == submitting;
}

part of 'package:rfid/feature/auth/presentation/login/login_page.dart';

mixin LoginMixin on State<LoginPage> {
  late final AuthBloc _bloc;

  late final TextEditingController _loginController;
  final FocusNode _loginFocusNode = FocusNode();
  final ValueNotifier<String?> _loginHasError = ValueNotifier<String?>(null);

  late final TextEditingController _passwordController;
  final FocusNode _passwordFocusNode = FocusNode();
  final ValueNotifier<String?> _passwordHasError = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _isObscured = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AuthBloc>();
    _loginController = TextEditingController();

    _loginController.addListener(() {
      _loginHasError.value = _loginController.text.trim().isEmpty ? 'This field required' : '';
    });
    _passwordController = TextEditingController();

    _passwordController.addListener(() {
      final text = _passwordController.text.trim();
      if (text.isNotEmpty) {
        _passwordHasError.value = text.length < 8 ? 'Password must be at least 8 characters' : '';
      } else {
        _passwordHasError.value = text.isEmpty ? 'This field required' : '';
      }
    });
  }

  @override
  void dispose() {
    _loginController.dispose();
    _loginFocusNode.dispose();
    _loginHasError.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _passwordHasError.dispose();
    super.dispose();
  }
}

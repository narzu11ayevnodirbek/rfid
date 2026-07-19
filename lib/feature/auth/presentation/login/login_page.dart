import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:rfid/infrastructure/enums/status_enums.dart';
import 'package:rfid/core/extension/extension.dart';
import 'package:rfid/feature/auth/domain/repository/auth_params.dart';
import 'package:rfid/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:rfid/presentation/components/custom_app_bar.dart';
import 'package:rfid/presentation/components/custom_text_field.dart';
import 'package:rfid/presentation/components/loading_view.dart';
import 'package:rfid/presentation/router/route_names.dart';

part 'mixin/login_mixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (oldState, newState) {
                            if (oldState.status.isLoading &&
                                newState.status.isError) {
                              EasyLoading.showError(newState.message);
                            } else if (oldState.status.isLoading &&
                                newState.status.isSuccess) {
                              EasyLoading.showSuccess(
                                'Добро пожаловать, ${newState.message}',
                                duration: const Duration(seconds: 1),
                              );
                              Future.delayed(
                                const Duration(seconds: 1),
                                () {
                                  if (!context.mounted) return;
                                  context.pushNamed(Routes.home);
                                },
                              );
                            }
                            return true;
                          },
                          builder: (context, state) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login',
                                  style: context.textStyle.regularCallout),
                              80.kBoxHeight,
                              Padding(
                                padding: 32.kPaddingHorizontal,
                                child: AnimatedBuilder(
                                  animation: Listenable.merge(
                                      [_loginFocusNode, _loginHasError]),
                                  builder: (_, __) => CustomTextField(
                                    controller: _loginController,
                                    focusNode: _loginFocusNode,
                                    errorText: _loginHasError.value,
                                    title: 'Login',
                                  ),
                                ),
                              ),
                              12.kBoxHeight,
                              AnimatedBuilder(
                                animation: Listenable.merge([
                                  _isObscured,
                                  _passwordFocusNode,
                                  _passwordHasError,
                                ]),
                                builder: (_, __) => Padding(
                                  padding: 32.kPaddingHorizontal,
                                  child: CustomTextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    errorText: _passwordHasError.value,
                                    title: 'Password',
                                    obscureText: _isObscured.value,
                                    suffixIcon: IconButton(
                                      onPressed: () => _isObscured.value =
                                          !_isObscured.value,
                                      icon: Icon(
                                        _isObscured.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: context.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              24.kBoxHeight,
                              AnimatedBuilder(
                                animation: Listenable.merge(
                                    [_loginHasError, _passwordHasError]),
                                builder: (_, __) => SizedBox(
                                  width: context.sizeOf.width,
                                  child: Padding(
                                    padding: 32.kPaddingHorizontal,
                                    child: ElevatedButton(
                                      onPressed: (_loginHasError.value ??
                                                      'hasError')
                                                  .isNotEmpty ||
                                              (_passwordHasError.value ??
                                                      'hasError')
                                                  .isNotEmpty
                                          ? null
                                          : () {
                                              if (state.status.isLoading) {
                                                return;
                                              }
                                              context.unfocus();
                                              _bloc.add(OnAuthenticateEvent(
                                                AuthParams(
                                                  action: 'login',
                                                  login: _loginController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                ),
                                              ));
                                            },
                                      child: state.status.isLoading
                                          ? const LoadingIndicator()
                                          : const Text('Kirish'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12 + context.padding.bottom),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
        ),
      );
}

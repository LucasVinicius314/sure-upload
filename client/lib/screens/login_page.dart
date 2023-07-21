import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/blocs/user_bloc.dart';
import 'package:sure_upload/repositories/local_repository.dart';
import 'package:sure_upload/screens/home_page.dart';
import 'package:sure_upload/utils/utils.dart';
import 'package:sure_upload/widgets/base_page_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyFocusNode = FocusNode();

  final _keyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget _getContent(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is LoginErrorState) {
          _keyFocusNode.requestFocus();

          Utils.showSnackBar(context, 'Invalid key.');
        } else if (state is LoginDoneState) {
          await Utils.replaceRoute(context, HomePage.route);
        }
      },
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Key'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _keyFocusNode,
                        controller: _keyController,
                        validator: (value) {
                          value ??= '';

                          if (value.trim().length <= 3) {
                            _keyFocusNode.requestFocus();

                            return 'Invalid key.';
                          }

                          return null;
                        },
                        onFieldSubmitted: (value) {
                          _login();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      tooltip: 'Login',
                      onPressed: _login,
                      icon: const Icon(Icons.navigate_next_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final key = _keyController.text.trim();

    context.read<UserBloc>().add(LoginEvent(key: key));
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      final userBloc = context.read<UserBloc>();

      final state = userBloc.state;

      if (state is LoginLoadingState) {
        return;
      }

      if (state is LoginDoneState) {
        Utils.replaceAllRoutes(context, HomePage.route);
      }

      final token = await context.read<LocalRepository>().getToken();

      if (token == null) {
        return;
      }

      userBloc.add(LoginWithTokenEvent(token: token));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      child: DynMouseScroll(
        builder: (context, controller, scrollPhysics) {
          return SingleChildScrollView(
            controller: controller,
            physics: scrollPhysics,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Form(
                      key: _formKey,
                      child: _getContent(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

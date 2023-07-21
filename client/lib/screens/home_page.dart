import 'package:desktop_drop/desktop_drop.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/blocs/file_bloc.dart';
import 'package:sure_upload/blocs/user_bloc.dart';
import 'package:sure_upload/screens/login_page.dart';
import 'package:sure_upload/utils/env.dart';
import 'package:sure_upload/utils/utils.dart';
import 'package:sure_upload/widgets/base_page_layout.dart';
import 'package:sure_upload/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isDragging = false;

  Widget _getContent() {
    return DropTarget(
      onDragDone: (detail) {
        final file = detail.files[0];

        context.read<FileBloc>().add(CreateFileEvent(file: file));
      },
      onDragEntered: (detail) {
        setState(() {
          _isDragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _isDragging = false;
        });
      },
      child: Stack(
        children: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              return BlocBuilder<FileBloc, FileState>(
                builder: (context, fileState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      const Card(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Drop files here to upload them.'),
                        ),
                      ),
                      if (userState is LoginDoneState &&
                          fileState is ListFilesDoneState) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Files - ${fileState.files.length.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _getFileList(
                            listFilesDoneState: fileState,
                            loginDoneState: userState,
                          ),
                        ),
                      ] else
                        const Expanded(child: LoadingIndicator()),
                    ],
                  );
                },
              );
            },
          ),
          if (_isDragging)
            Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: const Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Release to upload selected files.'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getFileList({
    required ListFilesDoneState listFilesDoneState,
    required LoginDoneState loginDoneState,
  }) {
    final bucket = loginDoneState.user.bucket ?? '';

    final files = listFilesDoneState.files;

    return DynMouseScroll(
      builder: (context, controller, scrollPhysics) {
        return ListView.separated(
          controller: controller,
          physics: scrollPhysics,
          itemCount: files.length,
          clipBehavior: Clip.antiAlias,
          separatorBuilder: (context, index) {
            return const Divider(height: 0);
          },
          itemBuilder: (context, index) {
            final file = files[index];

            final baseUrl = 'https://${Env.apiAuthority}/content/$bucket/$file';

            final downloadUrl = '$baseUrl?mode=download';

            return ListTile(
              title: Text(file),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              tileColor: index % 2 == 0 ? Colors.grey.shade100 : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Open',
                    onPressed: () async {
                      await Utils.launchUrl(downloadUrl);
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Copy download URL',
                    onPressed: () async {
                      Utils.showSnackBar(
                        context,
                        'Download URL copied to clipboard.',
                      );

                      await Utils.copyToClipboard(downloadUrl);
                    },
                    icon: const Icon(Icons.download_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Copy embed URL',
                    onPressed: () async {
                      Utils.showSnackBar(
                        context,
                        'Embed URL copied to clipboard.',
                      );

                      await Utils.copyToClipboard('$baseUrl?mode=embed');
                    },
                    icon: const Icon(Icons.fit_screen_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: () {
                      context
                          .read<FileBloc>()
                          .add(DeleteFileEvent(fileName: file));
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getSideBar() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is LoginDoneState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Bucket',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(state.user.bucket ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _logout,
                  child: const Text('LOGOUT'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        return Container();
      },
    );
  }

  Widget _getWrapper({required Widget child}) {
    return BlocListener<FileBloc, FileState>(
      listener: (context, state) {
        if (state is CreateFileErrorState) {
          Utils.showSnackBar(context, 'Something went wrong.');

          context.read<FileBloc>().add(ListFilesEvent());
        } else if (state is CreateFileDoneState) {
          Utils.showSnackBar(context, 'File uploaded successfully.');

          context.read<FileBloc>().add(ListFilesEvent());
        } else if (state is DeleteFileErrorState) {
          Utils.showSnackBar(context, 'Something went wrong.');

          context.read<FileBloc>().add(ListFilesEvent());
        } else if (state is DeleteFileDoneState) {
          Utils.showSnackBar(context, 'File deleted successfully.');

          context.read<FileBloc>().add(ListFilesEvent());
        }
      },
      child: child,
    );
  }

  void _logout() {
    context.read<UserBloc>().add(LogoutEvent());
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      final fileBloc = context.read<FileBloc>();

      if (context.read<UserBloc>().state is! LoginDoneState) {
        await Utils.replaceAllRoutes(context, LoginPage.route);
      }

      fileBloc.add(ListFilesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePageLayout(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 250,
            child: _getSideBar(),
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: _getWrapper(child: _getContent()),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ndc_app/UI/Widgets/templateerrorcontainer.dart';
import 'package:ndc_app/UI/Widgets/templateloadingcontainer.dart';
import '../Bloc/auth_cubit.dart';

/// [AdminRequestsBody] is a stateless widget that displays the admin's
/// connection requests based on their [Type].
///
/// - [scrollController]: Controls the scrolling behavior of the list of requests.
/// - [Type]: The type of requests being displayed (e.g., "Connection Requests").
/// - [Requests]: A list of widgets representing each request.
/// - [isLoading]: A boolean indicating if additional data is currently being loaded.
/// - [canFetchMore]: A boolean indicating if more data can be fetched from the server.
/// - [fetchMoreConnectionRequests]: A function to fetch additional requests when the user scrolls to the bottom.
///
/// The widget is wrapped with a [BlocBuilder] to listen for changes in the [AuthCubit]
/// state. If the user is authenticated, their profile information is retrieved from the [AuthState].
///
/// The UI consists of:
/// - A [SafeArea] that contains a [Container] for displaying a welcome message and the type of requests.
/// - A scrollable list of [Requests] that triggers [fetchMoreConnectionRequests] when the user scrolls to the end.
/// - If [Requests] is empty and [isLoading] is true, a [LoadingContainer] is displayed.
/// - If [Requests] is empty and [isLoading] is false, a message indicating no pending requests is displayed.

class AdminRequestsBody extends StatelessWidget {
  final ScrollController scrollController;
  final String Type;
  final List<Widget> Requests;
  final bool isLoading;
  final bool canFetchMore;
  final Function fetchMoreConnectionRequests;

  AdminRequestsBody({
    Key? key,
    required this.scrollController,
    required this.Type,
    required this.Requests,
    required this.isLoading,
    required this.canFetchMore,
    required this.fetchMoreConnectionRequests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userProfile = state.userProfile;
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Welcome, ${userProfile.name}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'All $Type Requests',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
                Requests.isNotEmpty
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (!scrollInfo.metrics.outOfRange &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              !isLoading &&
                              canFetchMore) {
                            fetchMoreConnectionRequests();
                          }
                          return true;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListView.separated(
                            addAutomaticKeepAlives: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: Requests.length + 1,
                            itemBuilder: (context, index) {
                              if (index == Requests.length) {
                                return Center(
                                  child: isLoading
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: CircularProgressIndicator(),
                                        )
                                      : SizedBox.shrink(),
                                );
                              }
                              return Requests[index];
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                          ),
                        ),
                      )
                    : !isLoading
                        ? LoadingContainer(screenWidth: screenWidth)
                        : buildNoRequestsWidget(screenWidth,
                            'You currently don\'t have any new requests pending.'),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// A widget that displays a list of requests and handles various states, including loading,
/// error, and successful data fetch. This widget is intended for cases where all items should
/// be displayed.
///
/// Variables:
/// - [loading]: A boolean indicating whether the widget should display a loading state.
/// - [fetch]: A boolean indicating whether the data-fetching process is complete.
/// - [errorText]: A string that contains the error message to display if the data-fetching fails.
/// - [fetchData]: A future that represents the data-fetching operation.
/// - [listWidget]: A list of widgets representing the items to display.
///
/// Actions:
/// - Uses [FutureBuilder] to manage and display different states of data fetching.
/// - Displays a loading indicator if [loading] is true.
/// - Shows an error message using [errorText] if the fetching process encounters an error.
/// - Renders the list of widgets from [listWidget] if the fetching is successful.
/// - Handles empty list scenarios by showing a corresponding message.
class RequestsWidgetShowAll extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void> fetchData;
  final List<Widget> listWidget;

  const RequestsWidgetShowAll({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: FutureBuilder<void>(
        future: loading ? null : fetchData,
        builder: (context, snapshot) {
          if (!fetch) {
            return Container(
              height: 200,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return buildNoRequestsWidget(screenWidth, 'Error: $errorText');
          } else if (fetch) {
            if (listWidget.isEmpty) {
              return buildNoRequestsWidget(screenWidth, errorText);
            } else if (listWidget.isNotEmpty) {
              return Container(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listWidget.length,
                      itemBuilder: (context, index) {
                        return listWidget[index];
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }
}

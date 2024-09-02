import 'package:flutter/material.dart';
import 'templateerrorcontainer.dart';

/// A custom widget that handles the display of requests, including loading states,
/// errors, and a list of content. This widget can also include a "See All" button
/// to navigate to another view when there are more items to display.
///
/// Variables:
/// - [loading]: A boolean that indicates if the widget should show a loading indicator.
/// - [fetch]: A boolean that indicates if the data fetching is complete.
/// - [errorText]: A string that contains the error message to display if the fetching fails.
/// - [fetchData]: A future that represents the data-fetching operation.
/// - [listWidget]: A list of widgets representing the items to display.
/// - [showSeeAllButton]: A boolean that determines whether to display the "See All" button.
/// - [seeAllButtonText]: A string that contains the text for the "See All" button.
/// - [nextView]: A widget that represents the view to navigate to when "See All" is clicked.
///
/// Actions:
/// - Uses [FutureBuilder] to handle different states (loading, error, and data loaded).
/// - Displays a loading indicator if [loading] is true.
/// - Displays an error message using [errorText] if the data-fetching fails.
/// - Displays the list of widgets in [listWidget] if the fetching is successful.
/// - Displays a "See All" button that navigates to [nextView] when clicked.
class RequestsWidget extends StatelessWidget {
  final bool loading;
  final bool fetch;
  final String errorText;
  final Future<void> fetchData;
  final List<Widget> listWidget;
  final bool showSeeAllButton;
  final String seeAllButtonText;
  final Widget nextView;

  const RequestsWidget({
    Key? key,
    required this.loading,
    required this.fetch,
    required this.errorText,
    required this.listWidget,
    required this.fetchData,
    required this.showSeeAllButton,
    required this.seeAllButtonText,
    required this.nextView,
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
                    if (showSeeAllButton)
                      buildSeeAllButton(context),
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

  Widget buildSeeAllButton(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.08,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => nextView));
          },
          child: Text(
            seeAllButtonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
      ),
    );
  }
}

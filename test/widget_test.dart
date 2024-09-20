import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallary_app/main.dart';

void main() {
  testWidgets('Main Page displays category buttons and loading indicator',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app bar title is present.
    expect(find.text('Gallery'), findsOneWidget);

    // Verify that category buttons are present.
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Motivational'), findsOneWidget);
    expect(find.text('Inspiration'), findsOneWidget);
    expect(find.text('Life'), findsOneWidget);
    expect(find.text('Love'), findsOneWidget);
    expect(find.text('Happiness'), findsOneWidget);

    // Check for the loading indicator while fetching images.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate fetching images (you may want to mock the ApiService for more control)
    // Here, we can use tester.pumpAndSettle() to wait for any animations or loading to complete.
    await tester.pumpAndSettle();

    // After loading, check that the loading indicator is no longer visible.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // You can also add checks for the images or the image grid.
    expect(find.byType(GridView), findsOneWidget);
  });
}

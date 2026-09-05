import 'package:awaaz_room/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows app title and create room action', (tester) async {
    await tester.pumpWidget(const AwaazRoomApp());
    expect(find.text('Awaaz Room'), findsOneWidget);
    expect(find.text('Room बनाएँ'), findsOneWidget);
  });
}

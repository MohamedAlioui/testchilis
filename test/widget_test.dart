import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:chilis/Screens/LoginScreen.dart'; // Import your LoginScreen
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  // Mock the FirebaseAuth instance
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    // Initialize the mock FirebaseAuth instance before each test
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  testWidgets('Login button enabled when email and password are entered', (WidgetTester tester) async {
    // Build the LoginScreen widget
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the email and password text fields and the login button
    final emailField = find.byType(TextField).at(0); // First TextField is the email field
    final passwordField = find.byType(TextField).at(1); // Second TextField is the password field
    final loginButton = find.byType(ElevatedButton).first; // The login button

    // Enter text into the email and password fields
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // Rebuild the widget with the updated text fields
    await tester.pump();

    // Verify that the login button is enabled (if valid input is provided)
    expect(find.byWidget(loginButton), findsOneWidget);
    expect((loginButton.widget as ElevatedButton).onPressed, isNotNull); // Ensure the button is not disabled
  });

  testWidgets('Login attempt shows error if credentials are incorrect', (WidgetTester tester) async {
    // Mock Firebase Auth to return an error (for testing invalid login)
    when(mockAuth.signInWithEmailAndPassword(
        email: 'invalid@example.com',
        password: 'wrongpassword'))
        .thenThrow(FirebaseAuthException(code: 'wrong-password', message: 'Invalid credentials'));

    // Build the LoginScreen widget
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the email, password fields, and the login button
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.byType(ElevatedButton).first;

    // Enter incorrect credentials
    await tester.enterText(emailField, 'invalid@example.com');
    await tester.enterText(passwordField, 'wrongpassword');
    await tester.pump();

    // Tap the login button
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that an error message is shown
    expect(find.text('Login failed'), findsOneWidget);
  });

  testWidgets('Login attempt succeeds with correct credentials', (WidgetTester tester) async {
    // Mock Firebase Auth to return a user on successful login
    when(mockAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123'))
        .thenAnswer((_) async => UserCredential(
        user: mockUser,
        credential: EmailAuthProvider.credential(email: 'test@example.com', password: 'password123')
    ));

    // Build the LoginScreen widget
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the email, password fields, and the login button
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.byType(ElevatedButton).first;

    // Enter correct credentials
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.pump();

    // Tap the login button
    await tester.tap(loginButton);
    await tester.pump();

    // Verify that the login attempt succeeded
    expect(find.text('Logged in as test@example.com'), findsOneWidget);
  });
}

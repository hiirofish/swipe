# Swipe Test App

A simple Flutter application demonstrating smooth swipe gestures and keyboard navigation. The app shows a grid of numbers and letters that can be navigated through swipes or arrow keys.

## Features

- Responsive swipe detection with improved gesture handling
- Keyboard arrow key support
- Debug logging for gesture analysis
- Smooth transitions between states
- Cross-platform support (Web, Android, iOS)

## Controls

- **Horizontal Swipe** / **Left/Right Arrow Keys**: Change numbers (1-5)
- **Vertical Swipe** / **Up/Down Arrow Keys**: Change letters (A-E)

## Technical Details

The app includes several optimizations for better user experience:
- Adjusted minimum velocity threshold for more sensitive swipe detection
- Recovery handling for quick successive gestures
- Detailed debug logging for gesture analysis
- Performance monitoring for gesture success rate

## Getting Started

1. Make sure you have Flutter installed on your machine
2. Clone this repository
3. Run the following commands:

```bash
flutter pub get
flutter run
```

For web deployment:
```bash
flutter build web
```

## Debug Features

When running in debug mode, the app provides detailed logging about gesture detection:
- Gesture velocity and direction
- Success/failure rate of gesture detection
- Timing analysis for successive gestures

## Dependencies

- Flutter SDK
- No additional packages required

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.
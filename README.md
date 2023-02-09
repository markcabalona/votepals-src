# VotePals

This is a final project for our CS Professional Elective 2 Course at Technological University of the Philippnies - Manila
An application of Borda Count Method in Tourist Destination Picker System 

## Getting Started

### Install Flutter SDK
- Follow this [documentation](https://docs.flutter.dev/get-started/install) for a detailed guide on how to install flutter on your machine
- This project was created using Flutter 3.3.9

### Run the app
- Run the app in any web browser

- to run the app in your device:
```bash
flutter pub get
flutter run -d chrome
```

### Build the app
- to build the app in release mode, run the command below:
```bash
flutter build web --release --web-renderer canvaskit  
```

### Note:
- Setup your own firebase project for this app and replace the `firebase_options.dart` inside `/lib` directory
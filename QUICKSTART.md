# ⚡ Quick Start Guide

Get up and running with the Clinic Appointment Booking app in 5 minutes!

## 🚀 Quick Setup

### Step 1: Prerequisites
Make sure you have Flutter installed:
```bash
flutter --version
```

If not installed, visit: https://flutter.dev/docs/get-started/install

### Step 2: Get the Code
```bash
git clone <repository-url>
cd clinic_appointment_booking
```

### Step 3: Install Dependencies
```bash
flutter pub get
```

### Step 4: Run the App
```bash
flutter run
```

That's it! The app should now be running on your device/emulator. 🎉

## 📱 App Overview

### Main Features

#### 1. **Home Screen**
- View welcome message with your profile
- Check statistics (upcoming/completed appointments)
- Browse medical specialties
- See top-rated doctors
- Quick access to today's appointments

#### 2. **Find Doctors**
- Search for doctors by name, specialty, or hospital
- Filter by medical specialty
- View doctor details (experience, ratings, fees)
- Save favorite doctors
- Book appointments

#### 3. **Appointments**
- View all your appointments
- Filter by status (All/Upcoming/Completed/Cancelled)
- See appointment details
- Cancel appointments
- Track time until next appointment

#### 4. **Profile**
- View and edit personal information
- Medical history
- Settings and preferences

## 🎨 UI Components

### Key Widgets

1. **DoctorCard** - Displays doctor information
2. **AppointmentCard** - Shows appointment details
3. **SpecialtyCard** - Medical specialty selection
4. **StatsCard** - Statistics display
5. **ProfileHeader** - User profile with gradient

### Color Scheme

- **Primary**: Sky Blue (#0EA5E9)
- **Secondary**: Emerald Green (#10B981)
- **Accent**: Purple (#8B5CF6)
- **Status Colors**: Green (Completed), Blue (Upcoming), Red (Cancelled)

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point & navigation
├── models/                   # Data models
│   ├── user.dart            # User model
│   ├── doctor.dart          # Doctor model
│   ├── appointment.dart     # Appointment model
│   └── specialty.dart       # Specialty model
├── providers/               # State management
│   ├── user_provider.dart
│   ├── doctor_provider.dart
│   └── appointment_provider.dart
├── screens/                 # Main screens
│   ├── home_screen.dart
│   ├── doctors_screen.dart
│   ├── appointments_screen.dart
│   ├── profile_screen.dart
│   └── doctor_detail_screen.dart
├── widgets/                 # Reusable widgets
│   ├── doctor_card.dart
│   ├── appointment_card.dart
│   ├── specialty_card.dart
│   ├── stats_card.dart
│   └── profile_header.dart
└── utils/                   # Utilities
    ├── app_colors.dart      # Color definitions
    ├── constants.dart       # App constants
    └── formatters.dart      # Formatting utilities
```

## 🔧 Common Customizations

### Change App Colors
Edit `lib/utils/app_colors.dart`:
```dart
static const Color primary = Color(0xFF0EA5E9); // Your color here
```

### Modify Sample Data
Edit provider files to change sample doctors, appointments, or user:
- `lib/providers/doctor_provider.dart`
- `lib/providers/appointment_provider.dart`
- `lib/providers/user_provider.dart`

### Add New Specialty
Edit `lib/screens/home_screen.dart`:
```dart
Specialty(
  id: '7',
  name: 'Your Specialty',
  icon: CupertinoIcons.your_icon,
  doctorCount: 10,
  description: 'Description',
),
```

## 🎯 Sample Data Included

### 8 Sample Doctors
- Dr. Sarah Johnson (Cardiology)
- Dr. Michael Chen (Dermatology)
- Dr. Emily Rodriguez (Pediatrics)
- Dr. David Thompson (Orthopedics)
- Dr. Lisa Anderson (Neurology)
- Dr. James Wilson (General Practice)
- Dr. Maria Garcia (Psychiatry)
- Dr. Robert Lee (Dentistry)

### 7 Sample Appointments
- Mix of upcoming, completed, and cancelled
- Different doctors and times
- Various appointment reasons

### 1 Sample User
- Name: John Smith
- Complete profile with medical history

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Check for Issues
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

## 📱 Development Tips

### Hot Reload
After making changes, press `r` in terminal to hot reload

### Full Restart
Press `R` for complete app restart

### Performance Overlay
Press `p` to show performance metrics

### Widget Inspector
Press `w` to dump widget tree

## 🐛 Quick Troubleshooting

### Images Not Loading?
Check internet connection - app uses remote images from pravatar.cc

### Build Errors?
```bash
flutter clean
flutter pub get
flutter run
```

### iOS Pod Issues?
```bash
cd ios
pod install
cd ..
flutter run
```

## 📚 Learn More

- **Models**: Data structures representing entities
- **Providers**: State management using Provider package
- **Screens**: Full-page views in the app
- **Widgets**: Reusable UI components
- **Utils**: Helper functions and constants

## 🎨 Design System

### Spacing
- XS: 4px
- S: 8px
- M: 16px
- L: 24px
- XL: 32px

### Border Radius
- S: 8px
- M: 12px
- L: 16px
- XL: 24px

### Font Sizes
- XS: 12px
- S: 14px
- M: 16px
- L: 18px
- XL: 24px
- XXL: 32px

## 🚀 Next Steps

1. ✅ Run the app
2. 📖 Explore the UI and features
3. 🔍 Check out the code structure
4. 🎨 Customize colors and styling
5. 📝 Modify sample data
6. 🔌 Add backend integration
7. 🚢 Deploy to stores

## 💡 Pro Tips

- Use `const` constructors for better performance
- Leverage hot reload for faster development
- Follow Flutter best practices
- Keep widgets small and focused
- Use Provider for state management
- Add error handling for production

## 🆘 Need Help?

- Read the [SETUP.md](SETUP.md) for detailed setup
- Check [README.md](README.md) for full documentation
- Visit [Flutter Documentation](https://flutter.dev/docs)
- Explore [Cupertino Widgets](https://flutter.dev/docs/development/ui/widgets/cupertino)

---

**Happy Building! 🎉**


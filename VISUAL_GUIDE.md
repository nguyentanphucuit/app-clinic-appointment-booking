# 🎨 Visual Guide - Clinic Appointment Booking App

A visual overview of the app's screens, features, and design elements.

## 📱 App Flow

```
┌─────────────┐
│   Launch    │
│    App      │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────┐
│         Main Navigation                 │
│  ┌─────┬─────────┬──────────┬────────┐ │
│  │Home │ Doctors │Appointments│Profile │ │
│  └──┬──┴─────────┴──────────┴───┬────┘ │
└─────┼─────────────────────────────┼─────┘
      │                             │
      ▼                             ▼
```

## 🏠 Home Screen Layout

```
┌──────────────────────────────────────┐
│  ┌────────────────────────────────┐  │
│  │  Welcome back,                 │  │
│  │  John Smith               🔔   │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌───────────────┐ ┌──────────────┐ │
│  │  Upcoming: 3  │ │ Completed: 2 │ │
│  │  📅           │ │ ✅           │ │
│  └───────────────┘ └──────────────┘ │
│                                      │
│  Specialties                    →   │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐  │
│  │ ❤️  │ │ ✨  │ │ 😊  │ │ 🧠  │  │
│  │Card-│ │Derm-│ │Pedi-│ │Neur-│  │
│  │iology│ │atol-│ │atrics│ │ology│  │
│  └─────┘ └─────┘ └─────┘ └─────┘  │
│                                      │
│  Top Rated Doctors          See All │
│  ┌────────────────────────────────┐ │
│  │ 👤 Dr. Sarah Johnson          │ │
│  │    Cardiology                  │ │
│  │    ⭐ 4.9 (284)  💼 15 years  │ │
│  │    🏥 City Medical Center      │ │
│  │    💰 500.000đ                 │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 👤 Dr. Emily Rodriguez        │ │
│  │    Pediatrics                  │ │
│  │    ⭐ 4.9 (342)  💼 18 years  │ │
└──────────────────────────────────────┘
```

## 👨‍⚕️ Doctors Screen Layout

```
┌──────────────────────────────────────┐
│        Find Doctors              ×   │
├──────────────────────────────────────┤
│  🔍 Search doctors, specialties...  │
│                                      │
│  ┌───┐ ┌────────┐ ┌────────┐       │
│  │All│ │Cardio- │ │Dermato-│  →    │
│  │   │ │logy    │ │logy    │       │
│  └───┘ └────────┘ └────────┘       │
│                                      │
│  Found 8 doctors                    │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 👤 Dr. Sarah Johnson       ❤️ │ │
│  │    Cardiology                  │ │
│  │    ⭐ 4.9 (284)  💼 15 years  │ │
│  │    🏥 City Medical Center      │ │
│  │    💰 500.000đ                 │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 👤 Dr. Michael Chen        ♡  │ │
│  │    Dermatology                 │ │
│  │    ⭐ 4.8 (196)  💼 12 years  │ │
│  │    🏥 Skin & Beauty Clinic     │ │
│  │    💰 400.000đ                 │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

## 📅 Appointments Screen Layout

```
┌──────────────────────────────────────┐
│      My Appointments             ×   │
├──────────────────────────────────────┤
│  ┌───┐ ┌────────┐ ┌─────────┐      │
│  │ 7 │ │   3    │ │    2    │      │
│  │All│ │Upcoming│ │Completed│      │
│  └───┘ └────────┘ └─────────┘      │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 🕐 Upcoming    │ 2 days left   │ │
│  ├────────────────────────────────┤ │
│  │ 👤 Dr. Sarah Johnson           │ │
│  │    Cardiology                   │ │
│  │                                 │ │
│  │ 📅 Oct 19, 2025, 10:00         │ │
│  │ ⏱️ 30 min                       │ │
│  │ 📝 Regular heart checkup        │ │
│  │                                 │ │
│  │ [ Cancel Appointment ]          │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ ✅ Completed                    │ │
│  ├────────────────────────────────┤ │
│  │ 👤 Dr. Michael Chen            │ │
│  │    Dermatology                  │ │
│  │                                 │ │
│  │ 📅 Oct 12, 2025, 14:30         │ │
│  │ ⏱️ 25 min                       │ │
│  │ 📝 Skin consultation            │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

## 👤 Profile Screen Layout

```
┌──────────────────────────────────────┐
│  ╔════════════════════════════════╗ │
│  ║        [Gradient Header]       ║ │
│  ║                                ║ │
│  ║            👤                  ║ │
│  ║        John Smith              ║ │
│  ║   john.smith@email.com         ║ │
│  ║                                ║ │
│  ║   35 yrs  │  O+  │  Male       ║ │
│  ╚════════════════════════════════╝ │
│                                      │
│  Personal Information                │
│  ┌────────────────────────────────┐ │
│  │ 📱 Phone                       │ │
│  │    0123 456 789                │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ ✉️  Email                      │ │
│  │    john.smith@email.com        │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 📍 Address                     │ │
│  │    123 Healthcare St, Medical  │ │
│  └────────────────────────────────┘ │
│                                      │
│  Medical History                    │
│  ┌────────────────────────────────┐ │
│  │ • Hypertension (2020)          │ │
│  │ • Seasonal allergies           │ │
│  │ • Regular checkups             │ │
│  └────────────────────────────────┘ │
│                                      │
│  Settings                           │
│  [ 🔔 Notifications          →  ]  │
│  [ 🔒 Privacy & Security     →  ]  │
│  [ ❓ Help & Support         →  ]  │
│  [ 🚪 Logout                 →  ]  │
└──────────────────────────────────────┘
```

## 👨‍⚕️ Doctor Detail Screen Layout

```
┌──────────────────────────────────────┐
│  ←    Doctor Details            ❤️  │
├──────────────────────────────────────┤
│                                      │
│              ┌─────┐                │
│              │ 👤  │                │
│              └─────┘                │
│        Dr. Sarah Johnson            │
│          [Cardiology]               │
│                                      │
│    ⭐      👥       💼             │
│    4.9    284     15 yrs           │
│   Rating Reviews  Experience        │
│                                      │
│  About                              │
│  ┌────────────────────────────────┐ │
│  │ Experienced cardiologist       │ │
│  │ specializing in heart disease  │ │
│  │ prevention and treatment...    │ │
│  └────────────────────────────────┘ │
│                                      │
│  Details                            │
│  ┌────────────────────────────────┐ │
│  │ 🏥 Hospital                    │ │
│  │    City Medical Center          │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 📅 Available Days              │ │
│  │    Available weekdays           │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 🕐 Working Hours               │ │
│  │    09:00 - 17:00               │ │
│  └────────────────────────────────┘ │
│  ┌────────────────────────────────┐ │
│  │ 💰 Consultation Fee            │ │
│  │    500.000đ                    │ │
│  └────────────────────────────────┘ │
│                                      │
├──────────────────────────────────────┤
│     [ Book Appointment ]             │
└──────────────────────────────────────┘
```

## 🎨 Color Palette

```
Primary Colors:
┌────────┐ ┌────────┐ ┌────────┐
│ #0EA5E9│ │ #10B981│ │ #8B5CF6│
│  Blue  │ │ Green  │ │ Purple │
└────────┘ └────────┘ └────────┘
Primary    Secondary   Accent

Status Colors:
┌────────┐ ┌────────┐ ┌────────┐
│ #0EA5E9│ │ #10B981│ │ #EF4444│
│Upcoming│ │Complete│ │Cancelled│
└────────┘ └────────┘ └────────┘

Specialty Colors:
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│Cardio- │ │Dermato-│ │Neuro-  │ │Pediat- │
│logy    │ │logy    │ │logy    │ │rics    │
│ Red    │ │ Orange │ │ Purple │ │ Green  │
└────────┘ └────────┘ └────────┘ └────────┘
```

## 🧩 Component Hierarchy

```
MyApp
└── MainNavigationScreen
    ├── HomeScreen
    │   ├── ProfileHeader
    │   ├── StatsCard (×2)
    │   ├── SpecialtyCard (×6)
    │   └── DoctorCard (×5)
    │
    ├── DoctorsScreen
    │   ├── SearchBar
    │   ├── SpecialtyFilters
    │   └── DoctorCard (×8)
    │
    ├── AppointmentsScreen
    │   ├── FilterChips (×3)
    │   └── AppointmentCard (×7)
    │
    └── ProfileScreen
        ├── ProfileHeader
        ├── InfoCard (×4)
        ├── MedicalHistory
        └── SettingsList
```

## 🎯 Interactive Elements

### Tap Actions
```
DoctorCard           → DoctorDetailScreen
AppointmentCard      → AppointmentDetails
SpecialtyCard        → Filtered DoctorsList
StatCard            → Related Screen
FavoriteButton      → Toggle Favorite
CancelButton        → Show Confirmation
BookButton          → Show DatePicker
```

### Navigation Flow
```
┌──────────┐    tap     ┌────────────────┐
│  Doctor  │  ────────→ │ Doctor Detail  │
│   Card   │            │     Screen     │
└──────────┘            └────────────────┘
                               │
                               │ tap
                               ▼
                        ┌──────────────┐
                        │ Book Dialog  │
                        └──────────────┘
```

## 📏 Spacing System

```
XS:  4px  ▪
S:   8px  ▪▪
M:  16px  ▪▪▪▪
L:  24px  ▪▪▪▪▪▪
XL: 32px  ▪▪▪▪▪▪▪▪
```

## 🔤 Typography Scale

```
XXL: 32px  ■■■■  (Titles)
XL:  24px  ■■■   (Headings)
L:   18px  ■■    (Subheadings)
M:   16px  ■     (Body)
S:   14px  ▪     (Secondary)
XS:  12px  ▪     (Labels)
```

## 🎭 Widget States

### Button States
```
Default:    [ Button Text ]
Hover:      [ Button Text ]  (slightly darker)
Pressed:    [ Button Text ]  (darker + scale)
Disabled:   [ Button Text ]  (grayed out)
```

### Card States
```
Default:    ┌───────────┐
            │   Card    │
            └───────────┘

Selected:   ┌═══════════┐
            ║   Card    ║  (colored border)
            └═══════════┘

Pressed:    ┌───────────┐
            │   Card    │  (slight scale)
            └───────────┘
```

## 📱 Screen Sizes

The app is responsive and works on:
- iPhone SE (small)
- iPhone 12/13/14 (standard)
- iPhone 14 Pro Max (large)
- iPad (tablet)

## 🎬 Animations

### Transitions
- Screen transitions: Cupertino slide (iOS native)
- Tab switching: Fade + slide
- Card tap: Scale down + fade
- Modal appearance: Slide up from bottom

### Durations
```
Short:  200ms  (micro-interactions)
Medium: 300ms  (standard transitions)
Long:   500ms  (complex animations)
```

## 🌟 Key Features Visual

```
Search & Filter      Favorites          Status Tracking
┌──────────┐        ┌──────────┐       ┌──────────┐
│ 🔍 ____  │        │ ❤️ ♡ ♡  │       │ 🟢 🔵 🔴 │
│ [Filter] │        │ ❤️ ♡ ❤️  │       │ Status   │
└──────────┘        └──────────┘       └──────────┘

Statistics         Beautiful Cards      Smooth Nav
┌──────────┐        ┌──────────┐       ┌──────────┐
│ 📊       │        │ ╔══════╗ │       │ 🏠 👨‍⚕️ 📅│
│ 3 → 12   │        │ ║Gradient│       │ Selected │
└──────────┘        │ ╚══════╝ │       └──────────┘
                    └──────────┘
```

## 🎨 Design Principles

1. **iOS-First**: Native Cupertino widgets throughout
2. **Clarity**: Clear information hierarchy
3. **Efficiency**: Quick access to key features
4. **Beauty**: Modern gradients and colors
5. **Consistency**: Unified design language
6. **Feedback**: Visual responses to actions

---

**Visual design follows iOS Human Interface Guidelines**  
**All components are responsive and accessible**


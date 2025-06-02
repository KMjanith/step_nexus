# 🚶‍♂️ StepNexus

An intelligent and offline-capable mobile application for tracking walking, cycling, and traveling activities. StepNexus provides real-time feedback on distance, speed, step count, and calories burned — with smart goal-setting, scheduling, and notification features.

---

## 📱 Features

- Track steps, distance, speed, and calories for **walking**, **cycling**, and **traveling**
- **Offline-first design** using local sensors and SQLite
- Activity-specific **target setting** (steps, time, distance)
- **Real-time tracking** using raw accelerometer and GPS data
- **Idle detection** notifications to keep users moving
- **Calendar-based scheduling** and reminder alerts
- Clean, minimal **user interface** with soft theme colors

---

## 🛠️ Technology Stack

| Technology                       | Description                                     |
|----------------------------------|-------------------------------------------------|
| [Flutter](https://flutter.dev)  | Cross-platform UI framework                    |
| [Dart](https://dart.dev)        | Programming language for Flutter               |
| [SQLite](https://sqlite.org)    | Lightweight local database                     |
| `sensor_plus`                   | Access raw accelerometer and gyroscope data    |
| `geolocator`                    | GPS-based location and movement tracking       |
| `flutter_local_notifications`   | Local notifications without internet           |

---

## 🧠 Step Counting Logic

StepNexus uses a **threshold-based peak detection algorithm** on raw accelerometer data:

1. **Compute magnitude**: `√(X² + Y² + Z²)` from 3D sensor values
2. **Detect peaks** in a 3-value sliding window
3. **Ignore false positives** using a minimum interval of 400 ms
4. **Store valid steps** with timestamps and magnitudes

---

## 🔔 Notification System

- **Idle Alerts**: Triggered if no movement is detected for 1 minute
- **Goal Alerts**: Notify users upon reaching their target
- **Schedule Reminders**: Alert users 10 minutes before planned sessions

---

## 🧪 How to Run

1. **Clone the repository**:

```bash
git clone https://github.com/your-username/stepnexus.git
cd stepnexus

flutter pub get
flutter run
```
---
## 📸 Screenshots
![2](https://github.com/user-attachments/assets/ff96601f-8835-4d1d-a18c-0d61fb8c1cc8)
![4](https://github.com/user-attachments/assets/87c82770-89cc-47bc-8f08-537a9aea5ce5)
![7](https://github.com/user-attachments/assets/cc69ed07-20ca-4f6e-98c6-287830ba396a)
![10](https://github.com/user-attachments/assets/2242c700-9cf8-4209-a4b9-7d4d1688c7ef)
![9](https://github.com/user-attachments/assets/8b41b8f6-9c28-4f39-9037-da04a5fd1b14)







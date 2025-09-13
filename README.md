# zo - Reels App

A Flutter application replicating Instagram/TikTok style reels with seamless playback, likes, theme switching, and offline persistence using Hive.

---

## 🚀 How to Run

1. **Clone the Repository**

   ```bash
   git clone <your-repo-url>
   cd reels_app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Hive Adapters** (important for local storage)

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**

   * For Android Emulator:

     ```bash
     flutter run
     ```
   * For building APK:

     ```bash
     flutter build apk --release
     ```

---

## Mock Server Setup

The app is **offline-first** using Hive for persistence, but for testing remote data sync you can mock a server:

1. **Use JSON Server** (Node.js required)

   ```bash
   npm install -g json-server
   ```

2. **Create a `db.json` file** at the project root:

   ```json
   {
     "videos": [
       { "id": 1, "path": "mock_video_1.mp4", "isLiked": false, "views": 0 },
       { "id": 2, "path": "mock_video_2.mp4", "isLiked": true, "views": 10 }
     ]
   }
   ```

3. **Run JSON Server**

   ```bash
   json-server --watch db.json --port 3000
   ```

4. Update your API service in Flutter to point to `http://localhost:3000/videos` for testing network-based features.

---

## Architecture Notes

* **State Management**: Provider is used for managing app-wide state (video list, likes, theme, etc.).
* **Persistence**: Hive database is used to store video metadata (`path`, `isLiked`, `views`) locally.
* **Video Playback**: `video_player` plugin is used with seamless playback logic:

  * Only the currently visible video plays.
  * Preloading for next/previous video avoids buffering.
* **Navigation**: `PageView` for vertical scrolling reels.
* **UI Separation**:

  * `pages/` → Screens like `HomePage`, `SettingsPage`, `LikesPage`.
  * `state/` → Providers managing state and business logic.
  * `models/` → Hive models (`VideoItem`).
  * `widgets/` → Reusable UI components (`VideoPlayerWidget`).
  * `themes/` → Light/Dark theme handling.

---

##  Summary

This app demonstrates **offline persistence**, **seamless video playback**, and **state separation** in Flutter. The mock server allows for testing sync scenarios, but the app primarily runs offline with Hive.

---

 With this setup, you can:

* Run the app fully offline.
* Optionally connect to a mock server for simulating API calls.
* Extend architecture easily (e.g., integrating a real backend later).


A new Flutter project.

## Getting Started



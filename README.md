# My Daily To-Do (Flutter App)

A simple, clean, and mobile-friendly to-do list app built with Flutter. Users can create, view, and manage daily tasks, each with a title, description, and due date/time. Tasks are displayed in a scrollable list with clearly formatted deadlines and visual cues.

---

## Features

- ✅ Add tasks with a name, description, and due date/time
- 📆 Uses native date and time pickers
- ⏱ Rounds time selections to the nearest **15-minute increment** (rounded **up**)
- 💡 Welcome dialog on first launch instructing users how to get started
- Clean Material Design layout
- Fully responsive on Android and iOS

---

## Screenshots

---

## Tech Stack

- **Flutter** 3.x
- **Dart**
- **Material Design**
- `intl` for date formatting

---

## Project Structure

```
lib/
├── main.dart           # Entry point with routes and main screen (task list)
├── task_form.dart      # Form screen to add a new task
├── about.dart          # Static About page
```

---

## 🧪 How to Run

1. **Clone this repo**
   ```bash
   git clone https://github.com/your-username/my-daily-todo.git
   cd my-daily-todo
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## TODO / Future Enhancements

- [ ] Persistent local storage (`shared_preferences` or `hive`)
- [ ] Task completion with checkboxes
- [ ] Swipe to delete tasks
- [ ] Task sorting by due date
- [ ] Optional dark mode support

---

## Credits

Made with ❤️ using Flutter by Talha Qudsi

---
# Gestion Stocks Hive (Flutter Desktop)

A simple Flutter desktop application for managing stock inventory using Hive as a local database. The app supports two types of products:
- **Mauvaise Condition** (Defective goods)
- **Bonne Condition** (Good condition goods)

Each product type is stored in its own Hive box. Users can add, list, and delete items, as well as upload and display images for each product. For "Bonne Condition" items, a unique position (volume, zone, emplacement) is enforced.

---

## Features

- **Add / List / Delete** for both “Mauvaise Condition” and “Bonne Condition” products
- Image selection via native file picker, with images stored in a local folder
- Unique position constraint for “Bonne Condition” products (Type: A/B/C, Zone: x/y/z, Emplacement: 1–6)
- Persistent local storage with Hive (no external database required)
- Simple desktop UI with two tabs (BottomNavigationBar)

---

## Requirements

- Flutter SDK (≥ 2.19.0) with desktop support enabled (Windows / macOS / Linux)
- Dart SDK
- A desktop platform toolchain:
  - **Windows**: Visual Studio (Desktop Development with C++)
  - **macOS**: Xcode and Xcode command-line tools
  - **Linux**: GTK3 & build-essential packages



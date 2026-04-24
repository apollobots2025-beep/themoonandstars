# 🌌 The Moon And Stars

The Moon And Stars is a high-performance, real-data-driven 3D universe exploration application built with C++ and Qt 6. It allows users to visualize and navigate the observable universe using scientifically accurate astronomical datasets, with a focus on scalability, realism, and immersive interaction.

---

## 🚀 Features

### 🌐 3D Observable Universe Globe
- Fully interactive spherical visualization of the observable universe
- Click-to-navigate system using celestial coordinates (RA/Dec)
- Smooth rotation, zoom, and exploration of all sky regions
- Real astronomical catalog integration

---

### 🚀 Travel Mode (Immersive Navigation)
- First-person 3D navigation through space
- WASD movement with progressive acceleration
- Mouse-based camera control (free look)
- Accurate spatial positioning based on real data
- Dynamic scaling system for large-distance traversal

---

### 📡 Real Data Integration
- Designed to use only trusted scientific sources:
  - ESA Gaia (star catalogs)
  - NASA Exoplanet Archive
  - SIMBAD Astronomical Database
  - Sloan Digital Sky Survey (SDSS)
  - MAST (Hubble, Kepler, JWST data)
- No fake or fabricated data
- Expandable data pipeline architecture

---

### ⚡ Infinite Data Streaming System
- Tile-based sky partitioning (LOD system)
- On-demand data streaming
- Predictive preloading based on camera movement
- Minimal initial download (~200MB–2GB)
- Scales to large datasets (10GB+ cached over time)

---

### 💾 Smart Caching System
- Persistent local cache for all downloaded data
- Prevents redundant downloads
- Configurable cache size limits
- Efficient storage organization

---

### 🧠 High-Performance Rendering
- GPU-accelerated 3D rendering via Qt Quick3D
- Instanced rendering for large star fields
- Optimized for millions of objects
- Expandable to larger datasets with LOD control

---

### 🎮 User Interface
- Clean, modular QML UI
- Sidebar controls:
  - Load Data
  - Mode switching (Globe / Travel)
- Information panels for object metadata
- Custom reusable UI components

---

### 📦 Installer & Packaging
- macOS .app bundle generation
- Custom .dmg installer with:
  - Drag-and-drop install UI
  - Custom background image
  - App icon support

---

## 📁 Project Structure

TheMoonAndStars/ │ ├── src/                # C++ backend │   ├── main.cpp │   ├── AppModel.cpp │   ├── CatalogLoader.cpp │   └── Parsing.cpp │ ├── qml/                # UI + 3D scenes │   ├── Main.qml │   ├── GlobeMode.qml │   ├── TravelMode.qml │   └── components/ │ ├── data/               # Data configs & cache │   ├── sources.json │   └── cache/ │ ├── assets/             # Installer assets │   ├── installer_background.png │   └── app_icon.icns │ ├── CMakeLists.txt ├── build_mac.sh └── README.md

---

## 🛠️ Requirements

### macOS
- macOS 12+
- Xcode Command Line Tools
- CMake ≥ 3.21
- Internet connection (for data loading)

### Dependencies (Auto-installed via script)
- Qt 6 (Core, Quick, Quick3D, Network)

---

## 🔧 Build Instructions (macOS)

Run the provided build script:

bash chmod +x build_mac.sh ./build_mac.sh 

This will:
1. Download Qt automatically (no global install required)
2. Build the application
3. Generate a .app bundle
4. Create a .dmg installer

---

## 📦 Running the App

After building:

bash open build/TheMoonAndStars.app 

Or install via the generated .dmg.

---

## 📡 Data Usage

| Mode            | Approx Size |
|-----------------|------------|
| Light           | ~1 GB      |
| Standard        | ~5–10 GB   |
| Extended        | 20+ GB     |

Data is:
- Downloaded on demand
- Cached locally
- Reused across sessions

---

## ⚠️ Limitations

- It is not possible to include the entire observable universe
- Data availability depends on external scientific catalogs
- Performance depends on hardware and dataset size

---

## 🔮 Future Roadmap

- Real-time API streaming
- VR support
- Relativistic visual effects
- Advanced galaxy rendering
- Time evolution simulation
- AI-assisted object identification

---

## 🤝 Contributing

We would love people who could run the included build_mac.sh file on their Mac with:
chmod +x build_mac.sh
./build_mac.sh
Please upload the dmg to Google Drive and email it to apollobots2025@gmail.com. We would appreciate your help.

---

## 📄 License

This project is intended for educational and research purposes.  
Please ensure compliance with data provider licenses when distributing datasets.

---

## 🌌 Vision

The goal of The Moon And Stars is to create the most accurate, scalable, and immersive representation of the universe possible using real scientific data—while remaining accessible on consumer hardware.

--

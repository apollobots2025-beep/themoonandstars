cmake_minimum_required(VERSION 3.21)
project(TheMoonAndStars LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# macOS specific settings
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "Minimum macOS version")
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "Build architectures")

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Quick3D Network)

qt_standard_project_setup()

qt_add_executable(appTheMoonAndStars
    src/main.cpp
    src/AppModel.cpp
    src/TravelController.cpp
    src/CatalogLoader.cpp
    src/Parsing.cpp
    src/Cosmology.cpp
    src/OrbitMath.cpp
)

qt_add_qml_module(appTheMoonAndStars
    URI MoonStars
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/GlobeMode.qml
        qml/TravelMode.qml
        qml/components/SideButton.qml
        qml/components/InfoPanel.qml
        qml/components/LabelValue.qml
        qml/components/MetricChip.qml
        qml/components/StyledButton.qml
        qml/components/StatusPill.qml
        qml/components/TinyTag.qml
    RESOURCES
        qml/qmldir
)

target_include_directories(appTheMoonAndStars PRIVATE src)
target_link_libraries(appTheMoonAndStars PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::QuickControls2 Qt6::Quick3D Qt6::Network)

# macOS bundle settings
set_target_properties(appTheMoonAndStars PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/src/Info.plist"
    MACOSX_BUNDLE_BUNDLE_NAME "The Moon And Stars"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0"
    MACOSX_BUNDLE_IDENTIFIER "com.themoonandstars.app"
    MACOSX_BUNDLE_GUI_IDENTIFIER "com.themoonandstars.app"
)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/assets/app-icon.icns")
    set_source_files_properties("${CMAKE_CURRENT_SOURCE_DIR}/assets/app-icon.icns" PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    target_sources(appTheMoonAndStars PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/assets/app-icon.icns")
    set_target_properties(appTheMoonAndStars PROPERTIES MACOSX_BUNDLE_ICON_FILE app-icon)
endif()

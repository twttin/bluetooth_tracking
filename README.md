# Bluetooth Tracking App

A Flutter-based mobile application for tracking and monitoring Bluetooth devices with health and lifestyle data visualization.

## Project Goal

This project aims to create a comprehensive Bluetooth tracking application that can connect to Bluetooth devices, collect data, and provide insights through an intuitive mobile interface. The app focuses on health and lifestyle monitoring through Bluetooth connectivity.

## Research Context

This application was developed for research purposes in collaboration with the **Gao Research Group at Caltech**. The work is associated with published scientific research in Nature Biomedical Engineering, demonstrating practical applications of Bluetooth-based tracking technology in biomedical contexts.

### Research Collaboration

- **Research Partner**: [Gao Research Group](https://gao.caltech.edu/), California Institute of Technology
- **Institution**: Caltech (California Institute of Technology)

### Research Publication

- **Nature Post**: [Nature Portfolio Tweet](https://x.com/NaturePortfolio/status/1560004323731439618)
- **Research Paper**: [Nature Biomedical Engineering](https://www.nature.com/articles/s41551-022-00916-z.epdf?sharing_token=empJK1ZTBATUv8GxWtcyP9RgN0jAjWel9jnR3ZoTv0PsmXT6ksfd1fnOjHTVqM4hyGHunVIuDAvY5dfvaaH2gYfiAJ2bxA_v9vjKVug-WrrZzSh3z9V_H6JqRqk2i8zHZt4sxcQri0TwxmetQWn8Gw-fsCyPBpxaMBqxu519_Uw%3D)

This work represents a practical implementation of Bluetooth tracking technology for scientific research and biomedical applications, demonstrating the potential of mobile applications in advancing healthcare and lifestyle monitoring research.

## Features

### Core Functionality
- **Bluetooth Device Discovery**: Scan and discover nearby Bluetooth devices
- **Device Connection Management**: Connect to and manage paired Bluetooth devices
- **Data Collection**: Collect and store data from connected Bluetooth devices
- **Background Processing**: Continue data collection in the background

### User Interface
- **Multi-tab Navigation**: Four main sections accessible via bottom navigation
  - **Measure**: Real-time data visualization and device interaction
  - **Insight**: Data analytics and charts
  - **Lifestyle**: Health and lifestyle tracking features
  - **Profile**: User profile and settings

### Data Visualization
- **Interactive Charts**: Real-time data visualization using charts_flutter
- **Peak Detection**: Advanced signal processing for data analysis
- **Raw Data Display**: View and analyze raw measurement data

### Technical Features
- **Cross-platform**: Supports both Android and iOS platforms
- **Material Design**: Modern UI following Material Design principles
- **Custom Fonts**: Includes custom typography (Lato, Quicksand, DM Mono)
- **State Management**: Uses Provider pattern for state management
- **Background Tasks**: Handles data collection in background modes

## Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **Bluetooth**: flutter_bluetooth_serial
- **Charts**: charts_flutter
- **State Management**: Provider & Scoped Model
- **UI**: Material Design with Google Fonts
- **Platform**: Android & iOS

## Key Components

- **Main Application**: Entry point with routing and theme configuration
- **Bluetooth Discovery**: Device scanning and connection management
- **Data Collection**: Background tasks for continuous monitoring
- **Visualization**: Chart components for data representation
- **User Interface**: Tabbed interface with specialized pages

## Development Status

The project is actively developed with recent commits focusing on UI improvements and widget cleanup. The application provides a solid foundation for Bluetooth-based health and lifestyle tracking.
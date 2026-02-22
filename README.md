# VirtuaLearn

## Overview

**VirtuaLearn** is an educational iOS application designed to transform how early-age students learn abstract scientific concepts. Backed by a **TÜBİTAK 2209-A** (University Students Research Projects Support Program) grant, the project leverages native iOS technologies to integrate Augmented Reality (AR) directly into the learning process.

By using visual and auditory elements, VirtuaLearn aims to increase student engagement, improve comprehension of complex topics, and promote the productive use of digital technology in early education.

## Core Objectives

1. **Interactive Learning:** Provide AR modeling for fundamental subjects including **Mathematics, Biology, Physics, and Chemistry**.
2. **Abstract to Concrete:** Help students visualize and understand abstract concepts (e.g., cell structures, the solar system) by placing 3D models in their physical environment.
3. **Technological Literacy:** Encourage the positive and educational use of mobile devices among younger demographics.
4. **Digital Education Transformation:** Support the digitalization goals of the national education curriculum by developing highly accessible learning tools.

## Technology Stack

Built exclusively with modern Apple Frameworks to ensure maximum performance, privacy, and seamless AR integration.

- **Platform:** iOS / iPadOS
- **Architecture:** MVVM-C (Model-View-ViewModel with Coordinators)
- **UI Framework:** SwiftUI
- **Augmented Reality:** ARKit & RealityKit
- **3D Assets:** USDZ format (generated via Reality Composer / Reality Converter)
- **Local Persistence:** SwiftData (Offline-first architecture)
- **Testing:** SwiftTesting (for robust unit tests and data validation)

## Project Structure

The project follows a scalable, domain-driven architecture:

- `App/`: Contains the main entry point (`VirtuaLearnApp`) and global state management (`AppState`).
- `Core/`: Holds the RealityKit engine logic (`ARManager`) and asynchronous model fetching (`AssetLoader`).
- `Data/`: SwiftData schema definitions, including the core `ARConcept` model.
- `Features/`: Grouped UI components for the 2D Dashboard and the 3D AR Experience.
- `Resources/ARAssets/`: The local bundle directory housing the `.usdz` 3D educational models.

## Documentation

For deeper technical insight, refer to the documents in this `/docs` directory:

- `implementation_plan.md`: Details the module breakdowns, testing plans, and file structures.
- `technical_documentation.md`: Provides UML diagrams, data schemas, and the internal AR state management flow.

## Getting Started

### Prerequisites

- **macOS** with **Xcode 16+** installed.
- An **iOS/iPadOS Device** running iOS 17+ (Required for testing ARKit features, as the Simulator does not support the device camera).

### Installation

1. Clone this repository.
2. Open `VirtuaLearn/VirtuaLearn.xcodeproj` in Xcode.
3. Select your development team in the project target settings.
4. Build and Run (`Cmd + R`) on a physical device.

## License & Acknowledgements

This project is developed as a senior year capstone and is funded by the **TÜBİTAK 2209-A Research Grant** under the advisement of Bandırma Onyedi Eylül University.

# 🛍️ Flutter Holo App

A modern, polished Flutter e-commerce application built with clean architecture, demonstrating professional mobile development practices with smooth animations and excellent user experience.

## ✨ Features

- **📱 Responsive Design** - Works perfectly on all screen sizes
- **🏗️ Clean Architecture** - Domain, Data, and Presentation layers
- **⚡ State Management** - Riverpod for robust state handling
- **🔄 Smooth Animations** - Shimmer loading, staggered animations
- **💾 Persistent Cart** - Local storage using SharedPreferences
- **🌐 RESTful API** - Integration with FakeStoreAPI
- **🛒 Shopping Cart** - Add, remove, update quantities, cart persistence
- **📦 Product Catalog** - Grid view with categories and filtering
- **🔍 Product Details** - Detailed product view with hero animations
- **❌ Error Handling** - Comprehensive error states with retry functionality
- **🔄 Pull to Refresh** - Intuitive refresh mechanism

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App and API constants
│   ├── error/              # Error handling
│   ├── network/            # HTTP client setup
│   ├── providers/          # Dependency injection
│   ├── router/             # Navigation configuration
│   ├── usecases/           # Base use case classes
│   └── widgets/            # Reusable UI components
├── features/
│   ├── products/
│   │   ├── data/           # Data sources and models
│   │   ├── domain/         # Business logic and entities
│   │   └── presentation/   # UI and state management
│   └── cart/
│       ├── data/           # Cart data management
│       ├── domain/         # Cart business logic
│       └── presentation/   # Cart UI components
└── main.dart              # App entry point
```

## 🚀 Getting Started

## 🎯 Key Features Breakdown

### 🛍️ Product Catalog
- Grid layout with responsive design
- Category filtering with animated chips
- Shimmer loading states
- Pull-to-refresh functionality

### 📦 Product Details
- Detailed product information
- Rating and reviews display
- Add to cart functionality
- Hero image transitions

### 🛒 Shopping Cart
- Persistent cart storage
- Quantity management (increase/decrease)
- Remove items with confirmation
- Cart total calculation
- Free shipping threshold
- Clear cart functionality




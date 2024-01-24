# NASA Astronomy iOS App with TCA

<p float="left">
  <img src="https://github.com/bakkoo/Nasa-Astronomy-iOS-TCA/assets/69032652/bd1ea1b5-c06e-4087-b988-878703f2e666" width="200" />
  <img src="https://github.com/bakkoo/Nasa-Astronomy-iOS-TCA/assets/69032652/f49619fc-c3f1-4d2e-aa5c-7252ed168ad9" width="200" />
  <img src="https://github.com/bakkoo/Nasa-Astronomy-iOS-TCA/assets/69032652/e667c676-0ced-4bc2-bce4-4d5008b8e273" width="200" />
<p/>
  
## Overview

The NASA Astronomy iOS App is a mobile application that allows users to explore the Astronomy Picture of the Day (APOD) provided by NASA. The app features a beautiful user interface, fetching the latest APOD, and provides additional functionalities for an enhanced user experience.

## Features

- **Astronomy Picture of the Day (APOD):** View the latest and historical astronomy pictures selected by NASA experts.
- **Favorites:** Save your favorite astronomy pictures for quick access.
- **Settings:** Configure app settings to personalize your experience.

## Modules

### APOD Feature

- The core feature of the app, responsible for fetching and displaying the Astronomy Picture of the Day.

### Networking

- A module providing networking capabilities for making API requests. Used by the APOD feature to fetch data from NASA's API.

### Color Extensions

- Custom color extensions to define the app's color scheme. Easily customizable and maintainable.

### Image Loader

- A powerful image-loading module that efficiently loads and caches images. Utilizes Kingfisher for image downloading and caching.

## Getting Started

To run the project locally, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/bakkoo/nasa-astronomy-ios.git

2. **Install Dependencies:**
   ```bash
   cd nasa-astronomy-ios
   swift package update
3. **Open the project in Xcode:**
   ```bash
   open NasaAstronomy.xcodeproj
4. **Build and run the project using Xcode.**

   

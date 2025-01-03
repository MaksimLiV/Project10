# Project 10: Photo Management App

## Overview

This is a photo management app that allows users to take pictures or choose them from their photo library, store the images locally, and manage the names of the images. Users can add, rename, and delete images as needed. The app uses `UICollectionView` to display the images in a grid, and `UserDefaults` to persist the data between app launches.

## Features

- **Add New Person**: Users can either take a photo with the camera or select an image from the photo library.
- **View Photos**: The app displays all added photos in a collection view with their names.
- **Rename Photos**: Users can rename photos directly from the collection view by selecting an item and choosing the "Rename" option.
- **Delete Photos**: Users can permanently delete images from the app.
- **Persistent Storage**: All data (image names and file paths) is stored in `UserDefaults` and persists across app sessions.
- **Editing**: Images are editable, allowing users to crop and modify them when adding them.

## Setup and Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/project10.git

# eBay Window Shopping App

## Overview

This repository contains the solutions to HW2, HW3, and HW4 of CSCI 571 - Web Technologies. The project is an eBay Window Shopping App that allows users to search for products on eBay, view product details, manage a wishlist, and interact with a backend API. It consists of three main components:

-   **Frontend**: Web-based user interface using Angular and Bootstrap (HW3).
-   **Backend**: Node.js Express API for handling eBay API requests and MongoDB interactions (HW3).
-   **iOS App**: A Swift-based iOS app utilizing the backend (HW4).

## Project Structure

```
├── frontend/       # Angular frontend for web-based eBay shopping
├── backend/        # Node.js Express backend serving eBay API and MongoDB integration
├── ebay-shop/      # Swift-based iOS application using the backend services
```

## Features

### HW2 - Server-Side Scripting with Flask and eBay API

-   Implemented using Python and Flask.
-   Supports searching products using eBay’s Finding API.
-   Displays product search results in a tabular format.
-   Validates user input (e.g., keyword presence, price range validation).
-   Allows sorting results based on price and shipping cost.
-   Uses AJAX for dynamic data fetching without page reloads.
-   Hosted on a cloud platform (GCP, AWS, or Azure).

### HW3 - Web App with Angular, Bootstrap, and MongoDB

-   **Frontend**

    -   Developed using Angular and Bootstrap for a responsive UI.
    -   Implements an AJAX-powered search form with live product updates.
    -   Supports pagination and sorting of search results.
    -   Allows adding/removing products from a wishlist stored in MongoDB.
    -   Includes Facebook sharing for products.

-   **Backend**
    -   Built with Node.js and Express.
    -   Handles API requests to eBay using Axios.
    -   Stores wishlist items in MongoDB hosted on a cloud platform.
    -   Ensures secure and efficient API communication.

### HW4 - iOS App with Swift and SwiftUI

-   **Developed for iOS using Swift and SwiftUI**.
-   **Features include:**
    -   Search products using eBay API via the backend.
    -   Display search results in a list with images, pricing, and shipping details.
    -   Add or remove products from the wishlist, synced with MongoDB.
    -   View product details, including seller information and return policies.
    -   Share products on Facebook.
    -   Implements autocomplete for zip code input.

## Setup Instructions

### Backend

1. Navigate to the `backend` directory:
    ```sh
    cd backend
    ```
2. Install dependencies:
    ```sh
    npm install
    ```
3. Set up environment variables (`.env` file):
    ```
    EBAY_APP_ID=your_ebay_app_id
    MONGO_URI=your_mongodb_connection_string
    ```
4. Start the server:
    ```sh
    npm start
    ```

### Frontend

1. Navigate to the `frontend` directory:
    ```sh
    cd frontend
    ```
2. Install dependencies:
    ```sh
    npm install
    ```
3. Start the development server:
    ```sh
    ng serve
    ```

### iOS App

1. Open the `ebay-shop` directory in Xcode.
2. Ensure dependencies (e.g., Alamofire, Kingfisher) are installed via Swift Package Manager.
3. Run the app on a simulator or connected device.

## Deployment

-   The backend should be deployed on a cloud service like AWS/GCP/Azure.
-   The frontend can be deployed on Vercel, Firebase Hosting, or AWS Amplify.
-   The iOS app can be deployed to TestFlight for testing and later to the App Store.

## Technologies Used

-   **Backend**: Node.js, Express, MongoDB, eBay API
-   **Frontend**: Angular, Bootstrap, AJAX, JSON
-   **iOS App**: Swift, SwiftUI, Alamofire, Kingfisher
-   **Hosting**: GCP/AWS/Azure for backend, Firebase/Vercel for frontend

## Authors

-   Developed as part of CSCI 571 Web Technologies coursework.

## License

This project is for academic purposes only and should not be used for commercial applications.

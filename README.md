# OKO - AI-Powered Farming Assistant
Welcome to OKO, an innovative AI-powered farming assistant app designed to empower farmers across Africa. "oko," meaning "farm" in Yoruba, encapsulates the essence of this app—rooted in African soil, yet designed to harvest a brighter future through cutting-edge technology.

## Overview
OKO leverages Google's Gemini to provide African farmers with real-time insights, personalized advice, and powerful tools to optimize their farming practices. From monitoring crop growth to analyzing weather conditions and predicting pest threats. OKO is a comprehensive farming companion tailored to meet the unique challenges faced by farmers in diverse African climates.

## Features
### 🌍 Localized Weather Insights
OKO offers hyper-local weather forecasts and detailed reports on factors like precipitation, humidity, and wind, allowing farmers to make informed decisions that enhance crop yields.

### 🌱 AI-Powered Crop Management
OKO tracks crop growth and estimates yields based on weather suitability and sustainability factors. The app also provides daily tips to help farmers optimize their farming practices and maximize productivity.

### 🐛 Pest Threat Analysis
With Gemini powered pest threat assessments, OKO helps farmers stay ahead of potential infestations by offering advice on how to protect crops effectively.

### 💬 Interactive Chat Feature
Farmers can ask OKO questions directly through an interactive chat feature, receiving instant advice on a wide range of farming topics, from crop care to pest control.

### 🌾 Designed for African Farmers
OKO is specifically designed to address the unique agricultural challenges in African countries, offering tailored advice and tools that resonate with the needs of local farmers.

## Why OKO?
### 🌟 Remarkability
OKO stands out as a remarkable tool for farmers, merging the advanced Gemini models with local farming knowledge to create a truly impactful app. Its ability to provide real-time, actionable insights makes it an indispensable resource.

### 🎨 Creativity
OKO’s creative approach to integrating AI with traditional farming practices is groundbreaking. By offering personalized tips and insights, the app ensures that farmers can continuously improve their methods and outcomes.

### 🛠️ Usefulness
The app's usefulness is evident in its comprehensive feature set, designed to support every aspect of farming. From weather forecasts to pest control, OKO provides the information farmers need to make smarter, more informed decisions.

### 🌍 Impactfulness
OKO has the potential to significantly impact agricultural productivity across Africa. By providing farmers with the tools they need to optimize their practices, the app helps to increase yields, improve sustainability, and ultimately enhance food security.

### 🚀 Execution
OKO is expertly executed with a user-friendly interface and a robust AI engine. Its focus on localized content ensures that every farmer, regardless of their location in Africa, can benefit from the app's insights and recommendations.

## Getting Started
To run Oko locally, you'll need to set up both the client and server. Follow the steps below to get started:

### Client Setup
#### Install Android Studio and Emulator:

- Download and install Android Studio.
- Set up an Android emulator to run the client application.
#### Install Flutter:

- Follow the instructions to install Flutter on your machine.
- Ensure Flutter is properly configured with Android Studio.
#### Set Up Firebase:

- Create a Firebase project in Firebase Console.
- Add your Android app to Firebase.
#### Clone the Repository:

```
git clone https://github.com/ThashilNaidoo/Oko.git
cd oko/client
```
#### Run the Client:

```
flutter pub get
flutter run
```
### Server Setup

#### Install Node.js:

- Download and install Node.js.
#### Set Up Stable Diffusion:

- Install and configure Stable Diffusion locally, as it's required for generating images.
- Download and install the [SDXL model](https://civitai.com/models/101055/sd-xl)
#### Get a Weather API Key:

- Sign up at weatherapi.com and obtain an API key.
#### Set Up MongoDB:

- Create a MongoDB instance. You can use MongoDB Atlas for a cloud-based solution.
- Collect your MongoDB connection details.
#### Configure Environment Variables:

- Create a .env file in the server directory and add the following variables:
 ```
PORT=Your_Server_Port
DB_HOST=Your_MongoDB_Host
DB_USER=Your_MongoDB_Username
DB_PASSWORD=Your_MongoDB_Password
DB_NAME=Your_MongoDB_Database_Name
MONGO_URI=Your_MongoDB_Connection_String
AGENDA_URI=Your_MongoDB_Connection_String_With_DB_Name
GEMINI_KEY=Your_Gemini_API_Key
GEMINI_PROMPT="You are a personal farming assistant named OKO..."
WEATHER_API_KEY=Your_WeatherAPI_Key
SECRET_KEY=Your_JWT_Secret_Key
```
#### Clone the Repository:

```
git clone https://github.com/ThashilNaidoo/Oko.git
cd oko/server
```
#### Install Server Dependencies and Start the Server:

```
npm install
npm start
```

Thank you for choosing OKO — cultivating smarter farms, harvesting brighter futures.

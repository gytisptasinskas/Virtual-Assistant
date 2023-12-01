# Virtual-Assistant

## Introduction
Virtual Assistant is an App designed to help users find needed information using OpenAI API. It incorporates modern UI/UX practices with a focus on user engagement and intuitive navigation.

## Features
### Core Features
- **Home**: The central hub of the app. where you can start using your microphone for the conversatation with AI or just select cateogory based on what you want to talk about.
- **Chat**: Real-time communication with an AI based on selected cateogory.
- **Talk**: Real-time conversation with an AI using microphone and speech recognision
- **Explore**: Allows users to discover filter and search categories.
- **History**: Keeps track of your chats between AI.
- **Onboarding**: Introduction flow for new users.
- **Authentication**: Uses Firebase to authenticate users with email.

### Additional Features
- **Profile Management**: Users have their own profile where they can add their avatar and change theme of the app.

### UI/UX
- **Support for Light and Dark Mode**: Dynamically adapts to user's preferred theme settings.

## Technologies and Integrations
- **Firebase Integration**: Utilizes Firebase services for authentication, storing messsages and images.
- **OpenAI**: Uses OpenAI created ChatGBT api to generate responses for the users
- **Architecture**: Project uses MVVM architecture to seperate views from their functionality

## Installation and Setup
```bash
# Clone the repository
git clone https://github.com/gytisptasinskas/Virtual-Assistant

# Navigate to the project directory
cd Assistant

# Open the project in Xcode
open Assistant.xcodeproj

# Getting API Key
https://platform.openai.com/
```

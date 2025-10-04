# YouEdit

A platform connecting YouTube creators and video editors, streamlining the video editing and uploading process.

## 📋 Overview

YouEdit serves as a middleman between YouTube creators and video editors. It allows:

- Creators to share video resources with editors without sharing YouTube credentials
- Editors to upload edited videos for creator approval
- Creators to review and publish videos directly to their YouTube channel with a single click

This project was inspired by an idea discussed by @hkirat.

## 🚀 Features

- **Dual User Roles**: Sign up as either an Editor or Creator (or both)
- **Secure Upload Process**: Videos are only uploaded to YouTube after creator approval
- **Resumable Uploads**: Support for large video files (up to 256GB) with resumable uploads via TUS protocol
- **Resource Sharing**: Editors can download source videos and resources for editing guidance
- **Streamlined Workflow**: Simplified process for collaboration between creators and editors

## 🛠️ Technologies

- **Frontend**: React, Vite, Material UI
- **Backend**: Node.js, Express
- **File Handling**: TUS protocol for resumable uploads
- **Authentication**: Passport.js
- **Database**: MongoDB with Mongoose
- **API Integration**: YouTube API for video uploads

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:
- [Node.js](https://nodejs.org/) (v14 or higher)
- [npm](https://www.npmjs.com/) (v6 or higher)
- [MongoDB](https://www.mongodb.com/) (local or Atlas connection)

## 📥 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/YouEdit.git
   cd YouEdit
   ```

2. **Set up the backend**
   ```bash
   cd backend
   npm install
   ```

3. **Set up the frontend**
   ```bash
   cd ../frontend
   npm install
   ```

4. **Configure environment variables**
   - Create a `.env` file in the backend directory based on the provided `.env.example`
   - Add your MongoDB connection string, YouTube API credentials, and other required variables

## 🚦 Running the Application

### Manual Method

1. **Start the backend servers**
   ```bash
   # In the backend directory
   node app.js     # Main backend server
   node serve.js   # Download stream server
   node tus.js     # TUS protocol server for file uploads
   node youtube.js # YouTube API integration server
   ```

2. **Start the frontend development server**
   ```bash
   # In the frontend directory
   npm run dev
   ```

### Quick Start (Recommended)

Use our single command script to start all services:

```bash
# From the project root
./start-youedit.sh
```

This script will start all backend servers and the frontend development server in one go.

## 🌐 Accessing the Application

- Frontend: http://localhost:5173
- Backend API: http://localhost:3000

## 📚 API Documentation

The backend provides the following main endpoints:

- `/api/auth/*` - Authentication routes
- `/api/tasks/*` - Task management for editing projects
- `/api/upload/*` - File upload endpoints
- `/api/youtube/*` - YouTube integration endpoints

For detailed API documentation, see [API.md](./API.md).

## 🧪 Project Structure

```
YouEdit/
├── backend/           # Node.js backend
│   ├── app.js         # Main Express server
│   ├── serve.js       # Download stream server
│   ├── tus.js         # TUS protocol server
│   ├── youtube.js     # YouTube API integration
│   └── ...
├── frontend/          # React frontend
│   ├── src/           # Source files
│   │   ├── App.jsx    # Main application component
│   │   └── ...
│   └── ...
└── start-youedit.sh   # Single command startup script
```

## 🔮 Future Enhancements

- Live chat between editors and creators
- Video conferencing capabilities
- Migration to Amazon S3 for file storage
- Enhanced analytics for creators and editors

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🙏 Acknowledgements

- Harkirat Singh for the original concept
- All contributors to this project

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
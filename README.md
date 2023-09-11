# Stocks App
### Technologies Used
<img src="https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white" /> <img src="https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white" /> <img src="https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E" /> <img src="https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB" /> <img src="https://img.shields.io/badge/bootstrap-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white" /> 

<img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white" /> <img src="https://img.shields.io/badge/Render-%46E3B7.svg?style=for-the-badge&logo=render&logoColor=white" /> <img src="https://img.shields.io/badge/vercel-%23000000.svg?style=for-the-badge&logo=vercel&logoColor=white" />

## Overview
A comprehensive application for traders to manage their stock investments efficiently. This project is developed as part of our coursework at Avion School for the backend course.

[Demo Link](https://stocks-app-arcf.vercel.app/)

## Features
📌 **Fetching Stock Data**: We fetch real-time stock data from a third-party API, Phisix API, to populate our database.

📌 **Testing**: We've followed a Test-Driven Development (TDD) approach and achieved a test coverage of approximately 98% using RSpec and SimpleCov.

📌 **Mobile Responsiveness**: Our app is designed to be mobile-responsive, ensuring a seamless experience for both tablet and mobile device users.

📌 **Authentication & Authorization**: We use Bcrypt for secure password hashing and JWT (JSON Web Tokens) for authentication and authorization.

📌 **Email Notifications**: Trader Mailer is implemented for sending important email notifications to traders.

📌 **Database**: We've utilized PostgreSQL as our database for efficient data storage and retrieval.

📌 **Deployment**: The backend is deployed on Render, and the frontend is deployed through Vercel.

## Setup

### Backend

1. Clone this repository.
2. Install Ruby on Rails dependencies: `bundle install`
3. Start PostgreSQL service: `sudo service postgresql start`
4. Create the database and run migrations: `rails db:create` `rails db:migrate`
5. Start the background task for fetching stock data: `rails fetch_stocks:all`
6. Start the Rails server: `rails server`

#### Scheduled Stock Updates

To automatically refresh stock data at intervals, you can optionally start the cron service: `sudo service cron start`

### Frontend

1. Clone the frontend repository.
2. Install Node.js dependencies: `npm install`
3. Set up environment variables for API URLs in your `.env` file. You may need to use local storage for the host in your React app.
4. Start the React development server: `npm run dev`





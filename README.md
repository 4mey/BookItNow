# Event Management Website

A robust web application for planning, organizing, and executing events, built using Ruby on Rails. This platform provides tools for event organizers and attendees to interact seamlessly, making event management more efficient and enjoyable.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- **Authentication**: Secure user registration and login process.
- **Admin Login**: Admin panel for managing users, events, and overall site settings.
- **Events CRUD**: Create, read, update, and delete events with details such as title, description, date, time, and location.
- **RSVP Management**: Attendees can RSVP for events, helping organizers track participation.
- **Attendee Management**: Manage attendee lists, track responses, and communicate with participants.
- **Notifications with Sidekiq**: Send automated notifications to users regarding event updates and reminders using Sidekiq for background processing.
- **Dashboard**: An overview for admins and organizers, showcasing key metrics and event statistics.

## Technologies Used

- **Ruby on Rails**: Framework for building the web application.
- **PostgreSQL**: Database management system for data storage.
- **HTML/CSS/JavaScript**: Frontend technologies for user interface.
- **Bootstrap**: Framework for responsive design.
- **Devise**: Authentication system for user management.
- **Sidekiq**: Background job processing for sending notifications.
- **RSpec**: Testing framework for ensuring application quality.

## Installation

To set up the project locally, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/event-management-website.git
   cd event-management-website

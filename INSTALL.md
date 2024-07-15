# Installation

### Prerequisites

- Ruby 3.1.6
- Rails 7
- PostgreSQL


1. **Clone the repository:**
    ```sh
    git clone https://gitlab.com/dzaporozhets/microprojectapp.git
    cd microprojectapp
    ```

2. **Install dependencies:**
    ```sh
    bundle install
    ```

3. **Set up the database:**
    ```sh
    rails db:setup
    ```

4. **Run the application:**
    ```sh
    rails server
    ```

5. **Visit the app:**
    Open `http://localhost:3000` in your web browser.


This will run the application in the development mode.
For production environment make sure to set `RAILS_ENV` variable to `production`.

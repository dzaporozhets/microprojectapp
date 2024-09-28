# Installation Guide

## 1. Prerequisites

Ensure that the following are installed on your system:

- **Ruby 3.1.6**
- **Rails 7**
- **PostgreSQL**

## 2. Setting Up the Rails Application

Follow these steps to prepare and start the Rails app:

1. **Clone the repository:**
    ```sh
    git clone https://gitlab.com/dzaporozhets/microprojectapp.git
    cd microprojectapp
    ```

2. **Install dependencies:**
    ```sh

    # For Debian/Ubuntu you need to install the following dependencies before bundle install:
    # sudo apt install libyaml-dev
 
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

5. **Visit the application:**
    Open your web browser and navigate to `http://localhost:3000`.

   This will run the application in development mode.

## 3. Environment Variables

The Rails app requires at least two secret keys to run: `RAILS_MASTER_KEY` and `SECRET_KEY_BASE`.

You can handle these keys in one of two ways:

1. **Manually set all environment variables:**

    This is likely the simplest option. Run the following command to generate a list of keys that you can then export into your environment:
    ```sh
    bin/generate-env-vars
    ```

2. **Automatically generate all necessary secrets:**

    Run the script to generate all required secrets into `config/credentials.yml.enc`:
    ```sh
    rails setup:credentials_and_db_encryption
    ```

    Then, export the `RAILS_MASTER_KEY` to allow the app to read from `config/credentials.yml.enc` and load other variables from there.

## 4. Production Environment Setup

For setting up the application in a production environment:

1. Set the `RAILS_ENV` environment variable to `production`.

2. **HTTPS Configuration:**

   Rails requires HTTPS in production mode by default. It's recommended to use a web server like **Nginx** or **Apache** in front of your application. Below is a sample Nginx configuration:

### Nginx Setup


### Nginx Setup

1. **Install Nginx:**

    ```
    sudo apt install nginx
    ```

2. **Obtain SSL Certificate with Certbot:**

    ```
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d your_domain.com
    ```

3. **Create an Nginx Configuration File for the App:**

   Create a new file at `/etc/nginx/sites-available/microprojectapp` with the following content:

    ```
    server {
        listen 80;
        server_name microprojectapp.example.com;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name your_domain.com;

        ssl_certificate /etc/letsencrypt/live/microprojectapp.example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/microprojectapp.example.com/privkey.pem;

        root /path/to/your/microprojectapp/public;

        location / {
            proxy_pass http://localhost:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    ```

4. **Enable the Nginx Configuration and Restart Nginx:**

    ```
    sudo ln -s /etc/nginx/sites-available/microprojectapp /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl restart nginx
    ```

You have successfully set up your Rails application in the production environment with HTTPS enabled!

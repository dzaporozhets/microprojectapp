# Installation

### 1. Prerequisites

- Ruby 3.1.6
- Rails 7
- PostgreSQL

### 2. Prepare and start the rails app

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


### 3. ENV variables


The rails app requires at least 2 secret keys to run: `RAILS_MASTER_KEY` and `SECRET_KEY_BASE`.

There are 2 ways to handle it:

1. Manually set all ENV variables. Probably the easiest option.
    You can run `bin/generate-env-vars` to get a list of generated keys you can than export in your environment.

2. Run the script to generate all necessary secrets into `config/credentials.yml.enc`

    ```sh
    rails setup:credentials_and_db_encryption
    ```

    Then export `RAILS_MASTER_KEY` that will allow the app to read from `config/credentials.yml.enc` and pick other variables from there.


### 4. Production environment

For production environment make sure to do next:

1. Set `RAILS_ENV` variable to `production`.
2. Rails production environment requires https by default. Use web server like Nginx or Apache in front of your application. See sample nginx config example below.


#### Nginx


Start with intalling nginx

```
sudo apt install nginx
```

Get SSL using certbot

```
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your_domain.com
```

Create an app config file `/etc/nginx/sites-available/microprojectapp`

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

Enable config and restart nginx

```
sudo ln -s /etc/nginx/sites-available/microprojectapp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

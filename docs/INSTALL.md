# Installation Guide (for production)

## 1. Prerequisites

Ensure that the following are installed on your system:

- **Ruby 3.1.6**
- **Rails 7**
- **PostgreSQL**

See this preparation guide for [Debian or Ubuntu][RUBY_PG_DEBIAN.md] and then come back for step 2.

## 2. Prepare the Rails Application

Follow these steps to prepare the Rails app:

1. **Clone the repository:**
    ```sh
    git clone https://gitlab.com/dzaporozhets/microprojectapp.git
    cd microprojectapp
    ```

2. **Install dependencies:**
    ```sh
    bundle config set --local without 'development test'

    # For Debian/Ubuntu you need to install the following dependencies before bundle install:
    # sudo apt install libyaml-dev

    bundle install
    ```

## 3. Database config

Now we need to make sure our rails app can connect to the PostgreSQL database. 

* Option 1. Directly modifing `config/database.yml` with your PostgreSQL user credentials (see production section there)
* Option 2. Provide ENV variable `DATABASE_URL`. 
* Option 3. Provide ENV variables `POSTGRES_USER` and `POSTGRES_PASSWORD` 

Choose whatever fits you best. 

## 4. Rails secrets

The Rails app requires several secret keys to run. Those include `RAILS_MASTER_KEY`, `SECRET_KEY_BASE` and database encryption keys. 


* Option 1. Generate them manually and place into ENV variables.
* Option 2. Follow instructions below:

Run the script to generate all required secrets into `config/credentials.yml.enc`:

```sh
SECRET_KEY_BASE_DUMMY=1 rails setup:credentials_and_db_encryption
```

After that copy `RAILS_MASTER_KEY` from the ouput of the last command and place it into ENV variable. 

By exporting `RAILS_MASTER_KEY` we allow the app to read from `config/credentials.yml.enc` and load other variables from there.

**BACKUP both `config/credentials.yml.enc` file and RAILS_MASTER_KEY somewhere safe**

## 5. Setup the Rails app database

Now we let our Rails app connect to the PostgreSQL database and create all necessary tables.

```sh
RAILS_ENV=production rails db:setup
```

## 6. Compile css and javascript

We need to precompile assets like css and javascript for the app to run. 

```sh
RAILS_ENV=production rails assets:precompile
```

## 7. Test run the application

If the command below starts without error, we can proceed to setup webserver and the rest.

```sh
RAILS_ENV=production rails server -b 0.0.0.0
```

Cancel the command to stop the server. We will start it again later. 


## 8. Web server (Nginx) setup + HTTPS

To obtain the SSL certificate for your app you need to have a domain name you plan to use for the app.

Rails requires HTTPS in production mode by default. It's recommended to use a web server like **Nginx** or **Apache** in front of your application. Below are instructions for Nginx configuration:

1. **Install Nginx:**

    ```
    sudo apt install nginx
    ```

2. **Obtain SSL Certificate with Certbot (replace your_domain.com with your real domain name):**

    ```
    sudo apt install certbot python3-certbot-nginx
    sudo certbot --nginx -d your_domain.com
    ```

3. **Create an Nginx Configuration File for the App:**

   Create a new file at `/etc/nginx/sites-available/microprojectapp` with the following content:

    ```
    server {
        listen 80;
        server_name your_domain.com;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl;
        server_name your_domain.com;

        ssl_certificate /etc/letsencrypt/live/your_domain.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your_domain.com/privkey.pem;

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

    Replace all occurences of `your_domain.com` with your domain name.

    Replace `/path/to/your/microprojectapp` with path to your microprojectapp directory. 

4. **Enable the Nginx Configuration and Restart Nginx:**

    ```
    sudo ln -s /etc/nginx/sites-available/microprojectapp /etc/nginx/sites-enabled/

    # Optional: You might want to remove the default nginx landing page 
    sudo rm /etc/nginx/sites-enabled/default 

    # Check that config is OK
    sudo nginx -t

    # Restart nginx
    sudo systemctl restart nginx
    ```

## 9. Start the Rails app


You need 2 more ENV variables: `APP_DOMAIN` and `RAILS_ENV`. Set them separately or include in the command below. Up to you. 

```
APP_DOMAIN=your_domain.com RAILS_ENV=production bundle exec puma -C config/puma.rb
```

Congrats! Now everything is running. Go to your domain to see the app running. 


## Extras

Some of the features like email delivery or AWS S3 file storage requires extra configuration.  

### Email sending (postfix)

```
sudo apt-get update
sudo apt-get install postfix
```
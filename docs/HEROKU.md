# Deploying on Heroku

This guide details the steps required to deploy your application on Heroku. Before starting, ensure you have installed the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#install-with-an-installer).
**Alternatively**, you can use the [Heroku Dashboard](https://dashboard.heroku.com) to create and manage your application, which allows you to skip installing the CLI. Note that some advanced tasks may still require the CLI.

---

## 1. Clone Your Repository

Begin by cloning the repository and navigating into the project directory:

    git clone https://gitlab.com/dzaporozhets/microprojectapp.git
    cd microprojectapp

---

## 2. Authenticate with Heroku

Log in to your Heroku account via the CLI:

    heroku login

---

## 3. Create a Heroku Application

Create a new Heroku application. By default, this will set up your app in the US region. To deploy in the EU region, use the --region eu flag.

- **US Region:**

    heroku create

- **EU Region:**

    heroku create --region eu

*Alternatively, you can create a new application using the Heroku Dashboard.*

---

## 4. Provision a PostgreSQL Database

Add a PostgreSQL database add-on. (Note: This service incurs charges.)

    heroku addons:create heroku-postgresql:essential-0

---

## 5. Deploy Your Code

Push your main branch to Heroku:

    git push heroku main

---

## 6. Set Up the Database

Run the necessary migrations and seed the database with initial data. If you encounter issues with migration (e.g., due to delayed PostgreSQL provisioning), wait a minute and try again.

    heroku run rails db:migrate
    heroku run rails db:seed

---

## 7. Launch Your Application

Open your deployed application in the default web browser:

    heroku open

---

## 8. Configure Your Domain

Set your custom domain by replacing your-domain-name-here.com with your actual domain:

    heroku config:set APP_DOMAIN=your-domain-name-here.com

Your application should now be live at your specified domain.

---

# Additional Configuration Options

## Generate Database Encryption Keys (Optional)

For applications requiring two-factor authentication, generate encryption keys as follows:

    heroku run ./bin/heroku-generate-db-encryption-vars

This command outputs three lines of instructions—follow them to complete the setup.

---

## File Upload Configuration

To support file uploads, choose one of the following methods:

### Option 1: Using AWS S3

1. Create an S3 bucket.
2. Set the following Heroku environment variables with your AWS credentials and bucket information:

    heroku config:set AWS_ACCESS_KEY_ID=your-access-key
    heroku config:set AWS_SECRET_ACCESS_KEY=your-secret-key
    heroku config:set AWS_REGION=your-region
    heroku config:set AWS_S3_BUCKET=your-bucket-name

### Option 2: Using the Bucketeer Add-on

Provision the Bucketeer add-on to handle file uploads:

    heroku addons:create bucketeer:hobbyist

---

## Email Functionality (Optional)

Enable email features (e.g., for user signup and password resets) using Mailgun:

1. **Activate the Mailgun Add-on:**

    heroku addons:create mailgun:starter

2. **Complete Domain Setup:**
   - Navigate to your Heroku dashboard.
   - Click the Mailgun add-on to access the Mailgun dashboard.
   - Follow the steps to verify your domain and retrieve credentials.

3. **Configure Mailgun Credentials:**

    heroku config:set SMTP_LOGIN=your-smtp-login
    heroku config:set SMTP_PASSWORD=your-smtp-password
    heroku config:set SMTP_SERVER=your-smtp-server

---

## Updating Your Application

To update your deployment with the latest changes from the main branch, run:

    git pull https://gitlab.com/dzaporozhets/microprojectapp.git main
    git push heroku main
    heroku run rails db:migrate


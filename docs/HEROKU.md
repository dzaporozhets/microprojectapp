# Running on Heroku

Before you proceed you need to install [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#install-with-an-installer).

1. **Clone the repository:**
    ```sh
    git clone https://gitlab.com/dzaporozhets/microprojectapp.git
    cd microprojectapp
    ```

2. **Login to heroku:**
    ```sh
    heroku login
    ```

3. **Create an application:**
    ```sh
    # US region
    heroku create

    # EU region
    heroku create --region eu
    ```

4. **Add PostgreSQL database:**
    ```sh
    heroku addons:create heroku-postgresql:essential-0
    ```

5. **Push the code to Heroku:**
    ```sh
    git push heroku main
    ```

6. **Prepare the database:**
    ```sh
    # If command below fails, maybe postgresql provision is not ready yet.
    # Give it a try in a minute or two.
    heroku run rails db:migrate

    # Fill the database with necessary data
    heroku run rails db:seed
    ```

7. **Open the application:**
    ```sh
    heroku open
    ```

Done! The last command should open the application in your browser.

### Extras:

#### Base keys for sessions, db encryption etc.  

```
# Generate random values
heroku run ./bin/generate-env-vars

# Copy next values from previous command output and set it below
heroku config:set RAILS_MASTER_KEY=
heroku config:set SECRET_KEY_BASE=
heroku config:set ACTIVE_RECORD_PRIMARY_KEY=
heroku config:set ACTIVE_RECORD_DETERMINISTIC_KEY=
heroku config:set ACTIVE_RECORD_KEY_DERIVATION_SALT=
```

#### File uploads via Amazon S3 (optional, but recommended).

This is required for file uploads to work on Heroku.
Create the S3 bucket and set following credentilas with heroku:

```
heroku config:set AWS_ACCESS_KEY_ID=
heroku config:set AWS_SECRET_ACCESS_KEY=
heroku config:set AWS_REGION=
heroku config:set AWS_S3_BUCKET=
```

#### Emails (optional, but recommended).

If you don't need to send emails like signup emails or password reset, then you can skip it.
You can use mailgun to send emails. For that you need to quite a few things.
You need to use your own domain, activate add-on, setup mailgun domain verification etc.

1. **Activate mailgun addon:**
    ```sh
    heroku addons:create mailgun:starter
    ```

2. **Got to heroku app page, click mailgun addon and get redirected to mailgun dashboard**
3. **Go through adding new domain setup and receive credentails from mailgun**
4. **Pass those credentilas to heroku**
    ```sh
    heroku config:set SMTP_LOGIN=
    heroku config:set SMTP_PASSWORD=
    heroku config:set SMTP_SERVER=
    ```

#### Use your domain

If you decide to go with our own domain, make sure to update the app with `APP_DOMAIN` variable:

    heroku config:set ADD_DOMAIN=



#### Updating to a newest version

Just pull latest changes from main branch and run db:migrate

```
git pull https://gitlab.com/dzaporozhets/microprojectapp.git main
git push heroku main
heroku run rails db:migrate
```

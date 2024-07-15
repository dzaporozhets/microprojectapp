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

```
heroku addons:create mailgun:starter
heroku config:set APP_DOMAIN=yourapp.herokuapp.com
```

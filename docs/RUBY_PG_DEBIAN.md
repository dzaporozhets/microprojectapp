# Guide: Installing Ruby and PostgreSQL on Debian using asdf

This guide provides step-by-step instructions on how to install Ruby and PostgreSQL on a Debian system. 

It consists of the following steps:

- 1. Prepare the user
- 2. Install ruby
- 3. Install PostgreSQL
- 4. Prepare PostgreSQL user


## 1. Prepare the user

You can use any user you want. But we would expect it to have some sudo capabilities to be able to install packages. 

## 2. Install ruby

`asdf` is a version manager that allows you to easily manage multiple versions of various programming languages and tools. Follow the instructions on the official `asdf` website to install `asdf`:

- [asdf Installation Guide](https://asdf-vm.com/guide/getting-started.html)

Make sure to add it to your shell (like `echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc`). 


Install Ruby dependencies:

```
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev libreadline-dev \
    libsqlite3-dev libcurl4-openssl-dev libffi-dev libyaml-dev
```

Now lets proceed with installation of Ruby:

1. **Add the asdf Ruby plugin:**
    ```bash
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    ```
2. **Install Ruby version 3.1.6:**
    ```bash
    asdf install ruby 3.1.6
    ```
3. **Set Ruby 3.1.6 as the global version:**
    ```bash
    asdf global ruby 3.1.6
    ```
4. **Verify the Ruby installation:**
    ```bash
    ruby -v
    ```

## 3. Install PostgreSQL

We are going to install PostgreSQL version 14. For newer versions please adjust steps accordingly

```
# Import the repository signing key 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```

Now update package manager via `sudo apt update`


1. **Set the locale environment variables (optional in Ubuntu):**
    ```bash
    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
    ```
2. **Install PostgreSQL:**
    ```bash
    sudo apt install -y postgresql-14 postgresql-client-14 libpq-dev
    ```
3. **Configrm PostgreSQL version installed:**
    ```bash
    psql --version
    ```
4. **Ensure PostgreSQL 14 is running and enabled on boot:**
    ```bash
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    ```

5. **Check its running:**
    ```bash
    sudo systemctl status postgresql
    ```
Now you need to create a PostgreSQL user for the app. 

Access PostgreSQL console

```
sudo -u postgres psql
```

Execute the command below replacing password with your choice. Username is `microproject` but you can change it if you want. 

```
CREATE USER microproject WITH PASSWORD 'your_secure_password';
ALTER ROLE microproject CREATEDB;
```


## 5. Done

Now you have both Ruby and PostgreSQL in your system. You also have login and password for PostgreSQL user that you will use later in `config/database.yml`. 

You can proceed with `INSTALL.md`
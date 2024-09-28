
# Guide: Installing Ruby and PostgreSQL on Debian using asdf

This guide provides step-by-step instructions on how to install Ruby and PostgreSQL on a Debian system using the `asdf` version manager. By following this guide, you will be able to manage multiple versions of these software packages effortlessly.

## 1. Install asdf

`asdf` is a version manager that allows you to easily manage multiple versions of various programming languages and tools. Follow the instructions on the official `asdf` website to install `asdf`:

- [asdf Installation Guide](https://asdf-vm.com/guide/getting-started.html)

## 2. Install Ruby with asdf

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

## 3. Install PostgreSQL with asdf

1. **Install the necessary dependencies for PostgreSQL:**
    ```bash
    sudo apt-get install linux-headers-$(uname -r) build-essential libssl-dev libreadline-dev zlib1g-dev \
    libcurl4-openssl-dev uuid-dev icu-devtools libicu-dev
    ```
2. **Add the asdf PostgreSQL plugin:**
    ```bash
    asdf plugin add postgres
    ```

3. **Set the locale environment variables (to prevent potential issues):**
    ```bash
    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"
    ```

4. **Install PostgreSQL version 14.12:**
    ```bash
    asdf install postgres 14.12
    ```

5. **Set PostgreSQL 14.12 as the global version:**
    ```bash
    asdf global postgres 14.12
    ```

6. **Start the PostgreSQL service:**
    ```bash
    pg_ctl start
    ```

7. **Create a default database:**
    ```bash
    # You might need to create a user first:
    # psql -U postgres
    # CREATE USER your_user_name;
    # ALTER USER your_user_name WITH SUPERUSER; (optional, depends on your needs)
    # \q

    createdb default
    ```

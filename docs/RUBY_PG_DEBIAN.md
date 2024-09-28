# Install ruby and postgresql on Debian

Install asdf - https://asdf-vm.com/guide/getting-started.html

Install asdf ruby plugin: 

    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf install ruby 3.1.6
    asdf global ruby 3.1.6
    ruby -v


Install asdf postgresql plugin: 

    sudo apt-get install linux-headers-$(uname -r) build-essential libssl-dev libreadline-dev zlib1g-dev libcurl4-openssl-dev uuid-dev icu-devtools libicu-dev
    asdf plugin add postgres

    export LC_ALL="en_US.UTF-8"
    export LC_CTYPE="en_US.UTF-8"

    asdf install postgres 14.12
    asdf global postgres 14.12

    pg_ctl start
    createdb default
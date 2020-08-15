# Whois Server

An HTTP wrapper for [`weppos/whois`](https://github.com/weppos/whois) ruby project, providing parsed WHOIS data for domain names.

## Install

If you're using bundler, simply run `bundle install`, it'll install the required dependencies from the gem files.

Otherwise, install the gems:

```sh
gem install whois whois-parser
```

## Usage

First run the server:

```sh
PORT=8080 ruby server.rb
```

Where you replace `8080` with a valid unoccupied port.

Then, you can call the service in an HTTP call, sending the domain/FQDN via the `site` GET param:

```sh
curl http://0.0.0.0:8080/?site=google.it # make sure to replace your machine IP address
```

## Deploy to Heroku

The project is heroku-ready and you can simply follow their git deploy to push to your dyno and access the service via their provided app domains.

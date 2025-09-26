# MicroProject.app

MicroProject.app is a lightweight project management tool designed for individuals and small teams to collaborate, track progress, and manage tasks efficiently without the complexity of traditional project management software.


* [Website](https://about.microproject.app/)
* [MIT License](LICENSE)
* [Quick Start](#quick-start)
* [Configuration](docs/CONFIG.md)
* [Contact](#contact)
* [App Screenshot](https://microproject.app/screenshot_xl.png)

## Quick Start

To run the application, you have 3 options:

### 1. Quick Start with Docker

For testing and getting started quickly:

```bash
# Development mode
docker-compose -f docker-compose.dev.yml up --build

# Production mode
SECRET_KEY_BASE=$(openssl rand -hex 64) docker-compose -f docker-compose.prod.yml up --build
```

For detailed Docker setup, see [Docker Guide](docs/DOCKER.md).

### 2. Deploy to Heroku

For production deployments, use a cloud platform like [Heroku](https://www.heroku.com/). For step-by-step instructions, see our [Heroku deployment guide](docs/HEROKU.md).

### 3. Run on Your Server or Local Machine

For proper production setups on your own server, follow the [installation instructions](docs/INSTALL.md).

## Configuration

The app requires several environment variables to be set for proper configuration. For detailed configuration steps and a complete list of required environment variables, refer to the [Configuration Guide](docs/CONFIG.md).

## Contact

If you have questions, feedback, or suggestions, feel free to reach out:

* **Create an Issue**: Open an issue on this project to report bugs, request features, or ask questions.
* **Twitter**: Mention me on [Twitter](https://x.com/dzaporozhets) at `@dzaporozhets`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Developer Certificate of Origin

By contributing to this project, you agree to the [Developer Certificate of Origin (DCO)](DCO). We encourage all contributors to sign off their commits using `Signed-off-by: Your Name <your.email@example.com>`. You can do this by adding `-s` to your git commit command.


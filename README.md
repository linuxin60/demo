# MyApp

A lightweight REST API for managing users, products, and orders.

## Requirements

- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- Docker (optional)

## Quick Start

```bash
git clone https://github.com/example/myapp.git
cd myapp
cp config.example.txt config.txt
pip install -r requirements.txt
python3 app.py
```

## Configuration

Edit `config.txt` before running. Key settings:

| Setting | Default | Description |
|---------|---------|-------------|
| server.port | 8080 | HTTP listen port |
| database.pool_size | 20 | DB connection pool |
| cache.ttl | 3600 | Cache TTL in seconds |
| logging.level | INFO | Log verbosity |

## API Endpoints

- `GET  /health` — Health check
- `POST /api/v1/login` — Authenticate user
- `GET  /api/v1/users` — List users (auth required)
- `POST /api/v1/users` — Create user
- `GET  /api/v1/products` — List products
- `GET  /api/v1/orders` — List orders

## Deployment

```bash
chmod +x src/deploy.sh
./src/deploy.sh production
```

## Backup

```bash
python3 src/backup.py --env production --output /mnt/backups
```

## License

MIT License.

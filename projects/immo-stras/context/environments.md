# immo-stras - Environment Configuration

## Deployment Pipeline (CI/CD)

### GitHub Actions Workflow
- **Repository**: GitHub Actions pour le déploiement automatique
- **Trigger**: Push sur la branche `main`
- **Processus**:
  1. Build de l'image Docker
  2. Push vers GHCR (GitHub Container Registry)
  3. SSH vers VPS
  4. Docker pull de la nouvelle image
  5. Redémarrage du conteneur

### Déclencher un déploiement
```bash
cd $WORKSPACE/immo-stras
git add .
git commit -m "feat: description des changements"
git push origin main
# Le workflow GitHub Actions se déclenche automatiquement
```

### URLs du projet
- **Code**: https://github.com/vpellerin/immo-stras
- **Container Registry**: ghcr.io/vpellerin/immo-stras
- **Application**: https://immo.vpdata.fr
- **n8n**: https://n8n.vpdata.fr

## Production Environment (VPS)

### Server Details
- **Host**: VPS vincent user (`vps_h`)
- **User**: vincent
- **Application URL**: http://vps_h:8000 (internal)
- **Public URL**: https://immo.vpdata.fr (if configured)

### Application Status
- **FastAPI Server**: Running on port 8000
- **Database**: SQLite at `/app/data/immo.db` (Docker) or `./data/immo.db` (local)
- **Images**: Stored in `/app/images/` (Docker) or `./images/` (local)
- **n8n Integration**: Configured for daily email reports

### Docker Configuration
```yaml
# docker-compose.yml
services:
  immo-stras:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./data:/app/data
      - ./images:/app/images
    environment:
      - DATABASE_PATH=/app/data/immo.db
      - IMAGES_PATH=/app/images
```

### API Endpoints
- **Health Check**: `GET /health`
- **Summary**: `GET /api/summary?date=yesterday`
- **Stats**: `GET /api/stats`
- **Dashboard**: `GET /` (web interface)

### n8n Workflow
- **Daily Email**: Runs at 09:00 daily
- **Webhook URL**: https://n8n.vpdata.fr/webhook/immo-scraping
- **Email**: vpellerindata@gmail.com
- **Status**: ✅ ACTIVATED (2026-01-08)

## Development Environment (Local)

### Local Setup
```bash
cd $WORKSPACE/immo-stras
uv sync
DATABASE_PATH="./data/immo.db" uv run uvicorn app.main:app --reload
```

### Local Database
- **Path**: `./data/immo.db`
- **Type**: SQLite
- **Current Status**: 5 active listings (vente only)

## Environment Variables

### Production (.env)
```bash
# Database
DATABASE_PATH=/app/data/immo.db
IMAGES_PATH=/app/images

# API
API_HOST=0.0.0.0
API_PORT=8000

# Search Criteria (VENTE ONLY)
SEARCH_PRICE_MAX=420000
SEARCH_SURFACE_MIN=85
SEARCH_PROPERTY_TYPES=apartment,house

# Search Locations (2026-01-08: Added Eckbolsheim)
SEARCH_CITIES=Strasbourg,Lingolsheim,Oberhausbergen,Wolfisheim,Eckbolsheim
SEARCH_ZIPCODES=67200,67380,67205,67202,67201

# n8n Integration
N8N_WEBHOOK_URL=https://n8n.vpdata.fr/webhook/immo-scraping
```

### Development (.env.local)
```bash
# Database
DATABASE_PATH=./data/immo.db
IMAGES_PATH=./images

# API
API_HOST=127.0.0.1
API_PORT=8000
DEBUG=true
RELOAD=true
```

## Deployment Commands

### Check Production Status
```bash
# SSH to VPS
ssh vincent@vps_h

# Check Docker containers
docker ps | grep immo

# Check application logs
docker logs immo-stras

# Check API health
curl http://localhost:8000/health
```

### Test API Endpoints
```bash
# Summary endpoint
curl "http://vps_h:8000/api/summary?date=yesterday"

# Stats endpoint  
curl "http://vps_h:8000/api/stats"

# Health check
curl "http://vps_h:8000/health"
```

### Restart Application
```bash
# On VPS
cd /path/to/immo-stras
docker-compose down
docker-compose up -d

# Or if running directly
pkill -f "uvicorn app.main:app"
DATABASE_PATH="/app/data/immo.db" uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## Troubleshooting

### Common Issues

1. **API Returns Empty Data**
   - Check database path in environment
   - Verify database file exists and has data
   - Check file permissions

2. **Email Report Shows "undefined"**
   - Check n8n workflow configuration
   - Verify API endpoints return valid JSON
   - Check email template variables

3. **Wrong Price Data (Location vs Vente)**
   - Database may contain mixed data
   - Need to filter by property type
   - Clean database if necessary

### Debug Commands
```bash
# Check database content
sqlite3 ./data/immo.db "SELECT COUNT(*) FROM annonces WHERE is_active = 1;"

# Check price distribution
sqlite3 ./data/immo.db "SELECT MIN(price), MAX(price), AVG(price) FROM annonces WHERE is_active = 1 AND price IS NOT NULL;"

# Check for location data
sqlite3 ./data/immo.db "SELECT price, title FROM annonces WHERE price < 2000 AND is_active = 1 LIMIT 5;"

# Verify search criteria in database
sqlite3 ./data/immo.db "SELECT COUNT(*) FROM annonces WHERE zip_code = '67201';"
sqlite3 ./data/immo.db "SELECT DISTINCT city FROM annonces WHERE zip_code = '67201' LIMIT 5;"
```

## Recent Changes

### 2026-01-08 - Eckbolsheim Added
- **Added**: Eckbolsheim (67201) to search criteria
- **Files Modified**:
  - `docker-compose.yml` (lines 33-34)
  - `README.md` (line 21)
- **Requires**: GitHub Actions deployment to apply on VPS
- **n8n**: Daily email workflow ACTIVATED

## Next Steps

1. **Verify VPS Status**: Check if application is running on VPS
2. **Test API Endpoints**: Ensure they return correct data
3. **Fix n8n Workflow**: Update email template to handle data correctly
4. **Database Cleanup**: Remove location listings if mixed with vente
# immo-stras - Technology Stack

## Global Context References

**ALWAYS load these global contexts first:**
- `@~/.opencode/context/core/standards/code.md` - Universal code standards
- `@~/.opencode/context/global/tools.md` - CLI commands and tools
- `@~/.opencode/context/global/environments.md` - Environment configuration

## Project-Specific Stack

### Core Technologies
- **Python 3.12+** with uv package manager
- **lbc** - LeBonCoin API/scraper library
- **FastAPI** - Web API framework
- **SQLite** - Database (immo.db)
- **Docker** - Containerization
- **n8n** - Workflow automation

### Web Scraping Architecture
```
Real Estate Sites → Playwright → Data Processing → DuckDB/PostgreSQL → Analytics
```

### Key Libraries
```python
# Web scraping
from playwright.async_api import async_playwright
import asyncio
import aiohttp

# Data processing
import pandas as pd
import polars as pl  # For large datasets

# Database
import duckdb
import psycopg2
from sqlalchemy import create_engine

# Data validation
from pydantic import BaseModel, validator
```

### Project Structure
```
immo-stras/
├── scrapers/              # Web scraping modules
│   ├── sites/             # Site-specific scrapers
│   ├── parsers/           # HTML parsing logic
│   └── utils/             # Scraping utilities
├── data/                  # Data storage
│   ├── raw/               # Raw scraped data
│   ├── processed/         # Cleaned data
│   └── exports/           # Analysis outputs
├── database/              # Database schemas and migrations
├── analysis/              # Data analysis notebooks
├── config/                # Configuration files
└── tests/                 # Test suites
```

### Environment Variables
```bash
# Database connections
DUCKDB_PATH=data/immo_stras.duckdb
POSTGRES_URL=postgresql://user:pass@localhost:5432/immo_stras

# Scraping configuration
SCRAPING_DELAY_MIN=1
SCRAPING_DELAY_MAX=3
MAX_CONCURRENT_REQUESTS=5
USER_AGENT="Mozilla/5.0 (compatible; ImmoBot/1.0)"

# Proxy settings (if needed)
PROXY_URL=http://proxy:port
PROXY_USERNAME=username
PROXY_PASSWORD=password
```

### Common Commands
```bash
# Run scrapers
uv run python scrapers/run_all.py
uv run python scrapers/sites/leboncoin.py

# Data analysis
uv run jupyter lab analysis/
uv run python analysis/price_analysis.py

# Database operations
duckdb data/immo_stras.duckdb
psql -d immo_stras

# Testing
uv run pytest tests/ -v
uv run playwright test
```

### Playwright Configuration
```python
# Browser configuration for scraping
BROWSER_CONFIG = {
    "headless": True,
    "viewport": {"width": 1920, "height": 1080},
    "user_agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
    "extra_http_headers": {
        "Accept-Language": "fr-FR,fr;q=0.9,en;q=0.8"
    }
}

# Anti-detection measures
STEALTH_CONFIG = {
    "random_delays": True,
    "rotate_user_agents": True,
    "use_proxy_rotation": False,  # Enable if needed
    "respect_robots_txt": True
}
```

### Database Schemas

#### DuckDB (Local Analytics)
```sql
-- Properties table
CREATE TABLE properties (
    id VARCHAR PRIMARY KEY,
    url VARCHAR UNIQUE,
    title VARCHAR,
    price INTEGER,
    surface INTEGER,
    rooms INTEGER,
    location VARCHAR,
    description TEXT,
    images JSON,
    scraped_at TIMESTAMP,
    source VARCHAR
);

-- Price history
CREATE TABLE price_history (
    property_id VARCHAR,
    price INTEGER,
    recorded_at TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);
```

#### PostgreSQL (Production)
```sql
-- Similar schema with additional indexes
CREATE INDEX idx_properties_location ON properties(location);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_properties_scraped_at ON properties(scraped_at);
```

### Data Processing Pipeline
```python
# Standard data processing workflow
async def process_scraped_data(raw_data: list) -> pd.DataFrame:
    """Process raw scraped data into structured format"""
    
    # 1. Data validation
    validated_data = [validate_property(item) for item in raw_data]
    
    # 2. Data cleaning
    df = pd.DataFrame(validated_data)
    df = clean_property_data(df)
    
    # 3. Data enrichment
    df = enrich_location_data(df)
    df = calculate_price_metrics(df)
    
    # 4. Deduplication
    df = df.drop_duplicates(subset=['url'])
    
    return df
```

### Error Handling & Monitoring
```python
# Robust scraping with error handling
import logging
from tenacity import retry, stop_after_attempt, wait_exponential

logger = logging.getLogger(__name__)

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=4, max=10)
)
async def scrape_with_retry(url: str) -> dict:
    """Scrape URL with retry logic"""
    
    try:
        async with async_playwright() as p:
            browser = await p.chromium.launch(**BROWSER_CONFIG)
            page = await browser.new_page()
            
            await page.goto(url)
            data = await extract_property_data(page)
            
            await browser.close()
            return data
            
    except Exception as e:
        logger.error(f"Scraping failed for {url}: {e}")
        raise
```

### Performance Optimization
- **Concurrent scraping**: Limited concurrent requests to avoid blocking
- **Caching**: Cache parsed data to avoid re-processing
- **Incremental updates**: Only scrape new/updated listings
- **Database optimization**: Proper indexing for query performance

### Legal & Ethical Considerations
- **Robots.txt compliance**: Respect site scraping policies
- **Rate limiting**: Reasonable delays between requests
- **User agent**: Identify scraper appropriately
- **Data usage**: Only for personal/research purposes
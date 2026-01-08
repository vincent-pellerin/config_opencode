# immo-stras - Business Patterns & Workflows

## Global Context References

**ALWAYS load these global contexts first:**
- `@~/.opencode/context/core/workflows/delegation.md` - Task delegation patterns
- `@~/.opencode/context/core/standards/patterns.md` - Universal patterns

## Web Scraping Patterns

### Site-Specific Scraper Pattern
```python
# Base scraper class for consistency
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import List, Dict, Optional

@dataclass
class PropertyListing:
    """Standardized property data structure"""
    url: str
    title: str
    price: Optional[int]
    surface: Optional[int]
    rooms: Optional[int]
    location: str
    description: str
    images: List[str]
    source: str

class BaseScraper(ABC):
    """Base class for all real estate site scrapers"""
    
    def __init__(self, base_url: str, site_name: str):
        self.base_url = base_url
        self.site_name = site_name
        self.session = None
    
    @abstractmethod
    async def get_listing_urls(self, search_params: Dict) -> List[str]:
        """Get URLs of property listings"""
        pass
    
    @abstractmethod
    async def parse_listing(self, url: str) -> PropertyListing:
        """Parse individual property listing"""
        pass
    
    async def scrape_all(self, search_params: Dict) -> List[PropertyListing]:
        """Complete scraping workflow"""
        urls = await self.get_listing_urls(search_params)
        listings = []
        
        for url in urls:
            try:
                listing = await self.parse_listing(url)
                listings.append(listing)
                await asyncio.sleep(random.uniform(1, 3))  # Rate limiting
            except Exception as e:
                logger.error(f"Failed to parse {url}: {e}")
                continue
        
        return listings
```

### Data Validation Pattern
```python
# Pydantic models for data validation
from pydantic import BaseModel, validator, Field
from typing import Optional, List
import re

class PropertyData(BaseModel):
    """Validated property data model"""
    
    url: str = Field(..., description="Property listing URL")
    title: str = Field(..., min_length=1, description="Property title")
    price: Optional[int] = Field(None, gt=0, description="Price in euros")
    surface: Optional[int] = Field(None, gt=0, description="Surface in m²")
    rooms: Optional[int] = Field(None, gt=0, le=20, description="Number of rooms")
    location: str = Field(..., min_length=1, description="Property location")
    description: str = Field(default="", description="Property description")
    images: List[str] = Field(default_factory=list, description="Image URLs")
    source: str = Field(..., description="Source website")
    
    @validator('url')
    def validate_url(cls, v):
        if not v.startswith(('http://', 'https://')):
            raise ValueError('URL must start with http:// or https://')
        return v
    
    @validator('location')
    def validate_location(cls, v):
        # Ensure location contains Strasbourg area
        strasbourg_keywords = ['strasbourg', 'schiltigheim', 'bischheim', 'hoenheim']
        if not any(keyword in v.lower() for keyword in strasbourg_keywords):
            raise ValueError('Property must be in Strasbourg area')
        return v
    
    @validator('price')
    def validate_price_range(cls, v):
        if v is not None and (v < 50000 or v > 2000000):
            raise ValueError('Price seems unrealistic for Strasbourg market')
        return v
```

### Async Scraping Pattern
```python
# Efficient concurrent scraping
import asyncio
import aiohttp
from playwright.async_api import async_playwright
import random

class ConcurrentScraper:
    """Manage concurrent scraping with rate limiting"""
    
    def __init__(self, max_concurrent: int = 5, delay_range: tuple = (1, 3)):
        self.max_concurrent = max_concurrent
        self.delay_range = delay_range
        self.semaphore = asyncio.Semaphore(max_concurrent)
    
    async def scrape_url(self, url: str, scraper_func) -> Optional[PropertyListing]:
        """Scrape single URL with rate limiting"""
        async with self.semaphore:
            try:
                # Random delay to avoid detection
                await asyncio.sleep(random.uniform(*self.delay_range))
                
                result = await scraper_func(url)
                logger.info(f"✅ Scraped: {url}")
                return result
                
            except Exception as e:
                logger.error(f"❌ Failed: {url} - {e}")
                return None
    
    async def scrape_urls(self, urls: List[str], scraper_func) -> List[PropertyListing]:
        """Scrape multiple URLs concurrently"""
        tasks = [self.scrape_url(url, scraper_func) for url in urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Filter out None results and exceptions
        return [r for r in results if isinstance(r, PropertyListing)]
```

## Data Processing Patterns

### ETL Pipeline Pattern
```python
# Extract, Transform, Load pipeline
from typing import Protocol
import pandas as pd

class DataProcessor(Protocol):
    """Protocol for data processing steps"""
    
    async def process(self, data: pd.DataFrame) -> pd.DataFrame:
        ...

class PropertyETL:
    """ETL pipeline for property data"""
    
    def __init__(self, processors: List[DataProcessor]):
        self.processors = processors
    
    async def extract(self, scrapers: List[BaseScraper]) -> pd.DataFrame:
        """Extract data from all scrapers"""
        all_listings = []
        
        for scraper in scrapers:
            try:
                listings = await scraper.scrape_all(self.get_search_params())
                all_listings.extend(listings)
            except Exception as e:
                logger.error(f"Scraper {scraper.site_name} failed: {e}")
        
        return pd.DataFrame([listing.__dict__ for listing in all_listings])
    
    async def transform(self, df: pd.DataFrame) -> pd.DataFrame:
        """Apply all transformation processors"""
        for processor in self.processors:
            df = await processor.process(df)
        
        return df
    
    async def load(self, df: pd.DataFrame, target: str):
        """Load data to target database"""
        if target == "duckdb":
            await self.load_to_duckdb(df)
        elif target == "postgresql":
            await self.load_to_postgresql(df)
        else:
            raise ValueError(f"Unknown target: {target}")
```

### Data Cleaning Pattern
```python
# Standardized data cleaning
import re
from typing import Optional

class PropertyCleaner:
    """Clean and standardize property data"""
    
    @staticmethod
    def clean_price(price_text: str) -> Optional[int]:
        """Extract numeric price from text"""
        if not price_text:
            return None
        
        # Remove currency symbols and spaces
        price_clean = re.sub(r'[€\s,]', '', price_text)
        
        # Extract numbers
        price_match = re.search(r'(\d+)', price_clean)
        if price_match:
            return int(price_match.group(1))
        
        return None
    
    @staticmethod
    def clean_surface(surface_text: str) -> Optional[int]:
        """Extract surface area from text"""
        if not surface_text:
            return None
        
        # Look for pattern like "85 m²" or "85m2"
        surface_match = re.search(r'(\d+)\s*m[²2]', surface_text.lower())
        if surface_match:
            return int(surface_match.group(1))
        
        return None
    
    @staticmethod
    def standardize_location(location: str) -> str:
        """Standardize location format"""
        # Remove extra whitespace
        location = ' '.join(location.split())
        
        # Capitalize properly
        location = location.title()
        
        # Fix common abbreviations
        replacements = {
            'Str.': 'Strasbourg',
            'Schilt.': 'Schiltigheim',
            'Bisch.': 'Bischheim'
        }
        
        for abbrev, full in replacements.items():
            location = location.replace(abbrev, full)
        
        return location
```

## Analysis Patterns

### Market Analysis Pattern
```python
# Real estate market analysis
import pandas as pd
import numpy as np
from typing import Dict, List

class MarketAnalyzer:
    """Analyze real estate market trends"""
    
    def __init__(self, df: pd.DataFrame):
        self.df = df.copy()
        self.prepare_data()
    
    def prepare_data(self):
        """Prepare data for analysis"""
        # Calculate price per m²
        self.df['price_per_sqm'] = self.df['price'] / self.df['surface']
        
        # Extract arrondissement from location
        self.df['arrondissement'] = self.df['location'].str.extract(r'(\d+)e?')
        
        # Categorize property types
        self.df['property_type'] = self.df['title'].apply(self.categorize_property)
    
    def price_analysis_by_location(self) -> Dict[str, Dict]:
        """Analyze prices by location"""
        return {
            location: {
                'median_price': group['price'].median(),
                'median_price_per_sqm': group['price_per_sqm'].median(),
                'count': len(group),
                'avg_surface': group['surface'].mean()
            }
            for location, group in self.df.groupby('location')
            if len(group) >= 5  # Minimum sample size
        }
    
    def trend_analysis(self, days: int = 30) -> Dict:
        """Analyze price trends over time"""
        recent_data = self.df[
            self.df['scraped_at'] >= pd.Timestamp.now() - pd.Timedelta(days=days)
        ]
        
        daily_stats = recent_data.groupby(
            recent_data['scraped_at'].dt.date
        ).agg({
            'price': ['mean', 'median', 'count'],
            'price_per_sqm': ['mean', 'median']
        }).round(2)
        
        return daily_stats.to_dict()
    
    @staticmethod
    def categorize_property(title: str) -> str:
        """Categorize property type from title"""
        title_lower = title.lower()
        
        if any(word in title_lower for word in ['appartement', 'appart', 'f1', 'f2', 'f3', 'f4', 'f5']):
            return 'Appartement'
        elif any(word in title_lower for word in ['maison', 'villa', 'pavillon']):
            return 'Maison'
        elif any(word in title_lower for word in ['studio', 'chambre']):
            return 'Studio'
        else:
            return 'Autre'
```

## Monitoring & Alerting Patterns

### Scraping Health Monitor
```python
# Monitor scraping performance and health
from dataclasses import dataclass
from datetime import datetime, timedelta
import json

@dataclass
class ScrapingMetrics:
    """Scraping performance metrics"""
    site_name: str
    total_urls: int
    successful_scrapes: int
    failed_scrapes: int
    avg_response_time: float
    timestamp: datetime
    
    @property
    def success_rate(self) -> float:
        return self.successful_scrapes / self.total_urls if self.total_urls > 0 else 0

class HealthMonitor:
    """Monitor scraping health and performance"""
    
    def __init__(self, alert_threshold: float = 0.8):
        self.alert_threshold = alert_threshold
        self.metrics_history = []
    
    def record_metrics(self, metrics: ScrapingMetrics):
        """Record scraping metrics"""
        self.metrics_history.append(metrics)
        
        # Check for alerts
        if metrics.success_rate < self.alert_threshold:
            self.send_alert(metrics)
    
    def send_alert(self, metrics: ScrapingMetrics):
        """Send alert for poor performance"""
        message = f"""
        🚨 Scraping Alert: {metrics.site_name}
        Success Rate: {metrics.success_rate:.1%} (threshold: {self.alert_threshold:.1%})
        Failed: {metrics.failed_scrapes}/{metrics.total_urls}
        Time: {metrics.timestamp}
        """
        
        logger.warning(message)
        # Could integrate with Slack, email, etc.
    
    def get_health_report(self, hours: int = 24) -> Dict:
        """Generate health report for last N hours"""
        cutoff = datetime.now() - timedelta(hours=hours)
        recent_metrics = [m for m in self.metrics_history if m.timestamp >= cutoff]
        
        if not recent_metrics:
            return {"status": "no_data"}
        
        avg_success_rate = sum(m.success_rate for m in recent_metrics) / len(recent_metrics)
        
        return {
            "status": "healthy" if avg_success_rate >= self.alert_threshold else "unhealthy",
            "avg_success_rate": avg_success_rate,
            "total_scrapes": sum(m.total_urls for m in recent_metrics),
            "sites_monitored": len(set(m.site_name for m in recent_metrics))
        }
```

## Business Rules

### Data Quality Rules
- **Minimum data requirements**: URL, title, location must be present
- **Price validation**: Must be within realistic range for Strasbourg market
- **Location filtering**: Only properties in Strasbourg metropolitan area
- **Duplicate detection**: Same URL = same property

### Scraping Ethics
- **Rate limiting**: Minimum 1-3 seconds between requests
- **Respect robots.txt**: Check and follow site policies
- **User agent identification**: Clear identification as research bot
- **No aggressive scraping**: Avoid overwhelming target sites

### Data Retention
- **Raw data**: Keep for 30 days for debugging
- **Processed data**: Keep indefinitely for trend analysis
- **Images**: Store URLs only, not actual images
- **Personal data**: Avoid scraping personal contact information
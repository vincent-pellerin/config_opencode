# immo-stras - Project Context

## Global Context References

**ALWAYS load these global contexts first:**
- `@~/.opencode/context/global/environments.md` - Environment setup and VPS configuration
- `@~/.opencode/context/core/workflows/task-breakdown.md` - Task management for complex features

## Project Overview

### Mission
Automated real estate market analysis for Strasbourg metropolitan area through web scraping and data analytics.

### Business Objectives
- **Monitor market trends** in Strasbourg real estate
- **Track price evolution** across different neighborhoods
- **Identify market opportunities** for buyers/investors
- **Provide data-driven insights** for real estate decisions
- **Automate data collection** from multiple real estate websites

## Target Market

### Geographic Scope
- **Primary**: Strasbourg city center and close suburbs
- **Secondary**: Eurométropole de Strasbourg (28 communes)
- **Focus areas**: Popular neighborhoods for young professionals and families
- **Current coverage (2026-01-08)**:
  - Strasbourg (67200)
  - Lingolsheim (67380)
  - Oberhausbergen (67205)
  - Wolfisheim (67202)
  - Eckbolsheim (67201)

### Property Types
- **Apartments**: F1 to F5, focus on F2-F3 for young professionals
- **Houses**: Small to medium houses with gardens
- **Student housing**: Studios and small apartments near universities
- **Investment properties**: Rental yield analysis

### Price Ranges
- **Studios**: €80,000 - €150,000
- **F2**: €120,000 - €250,000  
- **F3**: €180,000 - €350,000
- **Houses**: €250,000 - €600,000

## Data Sources

### Primary Sources
- **LeBonCoin**: Largest French classified ads platform
- **SeLoger**: Professional real estate platform
- **Bien'ici**: Modern real estate search engine
- **PAP**: Direct owner-to-buyer platform

### Data Points Collected
- **Basic info**: Price, surface, rooms, location
- **Details**: Description, energy rating, charges
- **Media**: Photos, virtual tours (URLs only)
- **Metadata**: Listing date, source, last update

### Update Frequency
- **Daily scraping**: New listings and price changes
- **Weekly analysis**: Market trend reports
- **Monthly reports**: Comprehensive market overview

## Architecture

### Data Flow
```
Real Estate Sites → Scrapers → Raw Data → Processing → DuckDB → Analysis → Reports
                                    ↓
                              PostgreSQL (Backup)
```

### Environments
- **Development**: Local with SQLite for fast iteration (`./data/immo.db`)
- **Production**: VPS vincent user (`vps_h`) with Docker deployment
- **Analysis**: FastAPI dashboard and API endpoints

### Storage Strategy
- **SQLite**: Primary database for both dev and production (simple deployment)
- **Images**: Local file storage with organized directory structure
- **n8n Integration**: Daily email reports via workflow automation

## Current Implementation

### Scrapers Status
- **LeBonCoin**: ✅ Implemented and tested
- **SeLoger**: 🚧 In development
- **Bien'ici**: 📋 Planned
- **PAP**: 📋 Planned

### Data Pipeline
1. **Extraction**: Playwright-based scrapers
2. **Validation**: Pydantic models for data quality
3. **Cleaning**: Standardization and deduplication
4. **Storage**: DuckDB for analytics, PostgreSQL for backup
5. **Analysis**: Pandas/Polars for data processing

### Monitoring
- **Scraping health**: Success rates and error tracking
- **Data quality**: Validation metrics and anomaly detection
- **Performance**: Response times and resource usage

## Analysis Capabilities

### Market Analysis
- **Price trends**: Historical price evolution by area
- **Price per m²**: Comparative analysis across neighborhoods
- **Market velocity**: Time on market and listing turnover
- **Seasonal patterns**: Monthly and quarterly trends

### Geographic Analysis
- **Neighborhood comparison**: Price and availability by area
- **Transport accessibility**: Proximity to tram/bus lines
- **Amenities mapping**: Schools, shops, parks nearby
- **Investment potential**: Rental yield estimation

### Property Analysis
- **Type distribution**: Apartments vs houses by area
- **Size analysis**: Surface area trends and pricing
- **Energy efficiency**: EPC ratings and impact on price
- **Feature analysis**: Balcony, parking, garden impact

## Development Workflow

### Local Development
1. **Setup**: Clone repo, install dependencies with uv
2. **Configure**: Set up `.env` with scraping parameters
3. **Test scrapers**: Run against small sample of URLs
4. **Develop analysis**: Create notebooks for data exploration
5. **Validate**: Check data quality and consistency

### Deployment Process
1. **Code review**: All scrapers require testing
2. **Data validation**: Ensure quality before production
3. **Staging deploy**: Test on VPS with limited scope
4. **Production deploy**: Full scraping with monitoring
5. **Analysis update**: Refresh reports and dashboards

### Quality Assurance
- **Data validation**: Automated checks for data quality
- **Scraper testing**: Regular validation of extraction logic
- **Performance monitoring**: Track scraping efficiency
- **Legal compliance**: Respect robots.txt and rate limits

## Common Tasks

### Adding New Data Source
1. Analyze site structure and anti-bot measures
2. Implement scraper following BaseScraper pattern
3. Add data validation and cleaning logic
4. Test with small sample and validate output
5. Integrate into main pipeline with monitoring

### Market Analysis Updates
1. Refresh data with latest scraping results
2. Update analysis notebooks with new insights
3. Generate updated reports and visualizations
4. Share findings with stakeholders

### Performance Optimization
1. Profile scraping performance and bottlenecks
2. Optimize database queries and indexing
3. Implement caching for frequently accessed data
4. Monitor resource usage and costs

## Legal & Ethical Considerations

### Web Scraping Ethics
- **Respect robots.txt**: Check and follow site policies
- **Rate limiting**: Reasonable delays between requests
- **No personal data**: Avoid scraping contact information
- **Research purpose**: Data used for market analysis only

### Data Privacy
- **No PII collection**: Avoid personal information
- **Anonymized analysis**: Aggregate data only
- **Secure storage**: Encrypted databases and backups
- **Access control**: Limited access to sensitive data

### Compliance
- **GDPR compliance**: No personal data processing
- **Terms of service**: Respect website terms
- **Copyright**: No reproduction of copyrighted content
- **Fair use**: Educational and research purposes

## Success Metrics

### Technical Metrics
- **Scraping reliability**: >95% success rate
- **Data freshness**: Daily updates for active listings
- **Query performance**: <2s for standard analysis
- **Data quality**: <1% invalid records

### Business Metrics
- **Market coverage**: >80% of available listings
- **Analysis accuracy**: Validated against manual checks
- **Insight generation**: Weekly trend reports
- **User value**: Actionable market intelligence

## Future Enhancements

### Technical Improvements
- **Real-time scraping**: WebSocket-based updates
- **ML price prediction**: Predictive modeling
- **API development**: REST API for data access
- **Dashboard creation**: Interactive web dashboard

### Business Expansion
- **Geographic expansion**: Other French cities
- **Commercial properties**: Office and retail spaces
- **Rental market**: Rental price analysis
- **Market alerts**: Automated opportunity detection
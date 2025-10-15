# Deployment Guide

**Date**: October 13, 2025  
**Status**: Research Phase  
**Target**: Small-scale deployment for testing (you + a few users)

---

## Current Architecture

### Services
- **Frontend**: React app (built to static files)
- **Backend**: Flask API server
- **Database**: SQLite (file-based)
- **Cache**: Redis (optional for MVP)
- **Web Server**: Nginx (serves frontend + proxies API)

### Current Setup
- **Docker**: Multi-stage build (frontend build + backend runtime)
- **Port**: 80 (frontend + API served together)
- **Database**: SQLite file in `/app/backend/instance/`
- **Environment**: Development configuration

### Environment Variables
```bash
FLASK_ENV=development
FLASK_DEBUG=True
DATABASE_URL=sqlite:////app/backend/instance/pokehub_dev.db
REDIS_URL=redis://redis:6379/0
SECRET_KEY=dev-secret-key
JWT_SECRET_KEY=dev-jwt-secret
```

---

## Cloud Provider Options

### Option A: Railway ⭐ **RECOMMENDED**

**Pros:**
- Docker-first approach (perfect for our setup)
- $5/month free credit
- Simple deployment from GitHub
- Built-in PostgreSQL (if we want to upgrade)
- Good developer experience
- Automatic HTTPS
- Custom domains supported

**Cons:**
- Smaller community than Heroku
- Free tier has limits

**Cost:** $5 free credit, then ~$5-10/month for small app

**Deployment:** Connect GitHub repo, Railway auto-detects Docker

**Best For:** Our current Docker setup, learning, cost-effective

---

### Option B: Render

**Pros:**
- Free tier for web services
- Docker support
- PostgreSQL free tier
- Auto-deploy from GitHub
- Good for small projects
- Automatic HTTPS

**Cons:**
- Free tier spins down after inactivity (cold starts)
- Limited resources on free tier

**Cost:** Free tier available, paid starts $7/month

**Deployment:** Connect GitHub, select Docker, auto-deploy

**Best For:** Free tier testing, simple deployment

---

### Option C: Fly.io

**Pros:**
- Docker-native
- Generous free tier (3 VMs)
- Global deployment
- Good for learning
- Modern tooling
- Fast cold starts

**Cons:**
- Slightly steeper learning curve
- Newer platform

**Cost:** Free tier generous, paid ~$5-10/month

**Deployment:** `flyctl` CLI tool, Docker-based

**Best For:** Learning modern deployment, global reach

---

### Option D: DigitalOcean App Platform

**Pros:**
- Good balance of simplicity and control
- $5/month basic tier
- Docker support
- PostgreSQL managed database
- Good documentation
- Reliable infrastructure

**Cons:**
- No free tier (but cheap)
- Slightly more complex than Railway

**Cost:** ~$5-12/month for basic app + database

**Deployment:** Connect GitHub, configure build settings

**Best For:** Production-like environment, reliability

---

### Option E: Heroku

**Pros:**
- Simplest deployment (git push)
- Free tier available (with limitations)
- Built-in PostgreSQL support
- Good for learning
- Large community

**Cons:**
- Free tier sleeps after 30 min inactivity
- Limited free hours per month
- More expensive as you scale
- No Docker support on free tier

**Cost:** Free tier available, paid starts ~$7/month per dyno

**Deployment:** Git-based (would need to restructure for our Docker setup)

**Best For:** Simple apps without Docker

---

### Option F: AWS/GCP/Azure (Enterprise)

**Pros:**
- Full control
- Scalable
- Industry standard
- Many services available

**Cons:**
- Complex setup
- Steeper learning curve
- Can get expensive quickly
- Overkill for small project

**Cost:** Variable, can be free tier but complex

**Deployment:** Complex, requires infrastructure knowledge

**Best For:** Production applications, learning cloud infrastructure

---

## Recommended Approach

### **Primary Recommendation: Railway**

**Why Railway:**
1. **Perfect Docker Fit**: Our app is already containerized
2. **Cost Effective**: $5 free credit covers small testing
3. **Simple Deployment**: Connect GitHub, auto-deploy
4. **Learning Friendly**: Modern platform, good docs
5. **Room to Grow**: Can upgrade to PostgreSQL later

### **Alternative: Render (if free tier preferred)**

**Why Render as backup:**
1. **Free Tier**: Good for initial testing
2. **Docker Support**: Works with our setup
3. **Simple**: GitHub integration
4. **Upgrade Path**: Can move to paid when needed

---

## Pre-Deployment Checklist

### Environment Configuration
- [ ] Create `.env.example` file
- [ ] Document all required environment variables
- [ ] Ensure no hardcoded secrets in code
- [ ] Set production environment variables

### Database Strategy
- [ ] **Decision**: Keep SQLite (simple) or upgrade to PostgreSQL (scalable)
- [ ] **Recommendation**: Start with SQLite, upgrade later if needed
- [ ] Verify database migration scripts work
- [ ] Test database persistence in container

### Frontend Configuration
- [ ] Verify production build works
- [ ] Check API URL configuration (should be relative `/api/`)
- [ ] Test with production-like environment
- [ ] Verify static file serving

### Docker Configuration
- [ ] Review Dockerfile (✅ already good)
- [ ] Test Docker build locally
- [ ] Verify all services start correctly
- [ ] Check health checks work

### Security
- [ ] Review CORS settings
- [ ] Check authentication tokens
- [ ] Verify no exposed secrets
- [ ] Update SECRET_KEY and JWT_SECRET_KEY for production

---

## Deployment Steps (Railway)

### Step 1: Prepare Repository
1. Create `.env.example` file
2. Update README with deployment instructions
3. Test Docker build locally
4. Commit all changes

### Step 2: Railway Setup
1. Sign up at [railway.app](https://railway.app)
2. Connect GitHub account
3. Create new project
4. Select repository

### Step 3: Configure Deployment
1. Railway auto-detects Docker
2. Set environment variables:
   ```bash
   FLASK_ENV=production
   FLASK_DEBUG=False
   SECRET_KEY=your-production-secret-key
   JWT_SECRET_KEY=your-production-jwt-secret
   DATABASE_URL=sqlite:////app/backend/instance/pokehub.db
   REDIS_URL=redis://localhost:6379/0
   ```
3. Deploy

### Step 4: Verify Deployment
1. Check health endpoint
2. Test frontend loads
3. Test API endpoints
4. Verify Pokemon data loads

### Step 5: Custom Domain (Optional)
1. Add custom domain in Railway dashboard
2. Configure DNS records
3. SSL certificate auto-provisioned

---

## Post-Deployment

### Health Checks
- **Frontend**: `https://your-app.railway.app/`
- **API**: `https://your-app.railway.app/api/v1/pokemon`
- **Health**: `https://your-app.railway.app/api/health` (if implemented)

### Monitoring
- Railway provides basic metrics
- Check logs in Railway dashboard
- Monitor resource usage

### Troubleshooting
- **App won't start**: Check logs, verify environment variables
- **Database issues**: Check SQLite file permissions
- **API not working**: Verify nginx configuration
- **Frontend not loading**: Check build process

---

## Future Enhancements

### Phase 1: Basic Deployment
- [ ] Deploy to Railway
- [ ] Test with you + a few users
- [ ] Monitor performance
- [ ] Gather feedback

### Phase 2: Improvements
- [ ] Custom domain setup
- [ ] Database upgrade to PostgreSQL
- [ ] CI/CD automation
- [ ] Performance monitoring

### Phase 3: Scaling
- [ ] Load balancing
- [ ] CDN for static assets
- [ ] Database optimization
- [ ] Caching improvements

---

## Cost Estimates

### Railway (Recommended)
- **Free Tier**: $5 credit/month
- **Paid**: ~$5-10/month for small app
- **Database**: Included (SQLite) or +$5/month (PostgreSQL)

### Render (Alternative)
- **Free Tier**: $0 (with limitations)
- **Paid**: $7/month for web service
- **Database**: Free tier available

### Total Monthly Cost
- **Railway**: $0-10/month
- **Render**: $0-7/month
- **Both**: Very affordable for testing

---

## Decision Points

### Immediate Decisions
1. **Provider**: Railway (recommended) or Render (free tier)
2. **Database**: SQLite (start) or PostgreSQL (upgrade later)
3. **Domain**: Railway subdomain or custom domain

### Future Decisions
1. **Scaling**: When to upgrade infrastructure
2. **Database**: When to move to PostgreSQL
3. **Monitoring**: What metrics to track
4. **CI/CD**: When to automate deployments

---

## Next Steps

1. **This Session**: Complete research and documentation
2. **Next Session**: 
   - Choose provider (Railway recommended)
   - Set up account
   - Deploy application
   - Test and verify
   - Share with testers

---

**Last Updated**: October 13, 2025  
**Status**: Ready for deployment  
**Recommendation**: Railway for Docker-first deployment

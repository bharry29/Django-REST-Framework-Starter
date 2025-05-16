# Project variables
PROJECT_NAME = django_rest_template
PYTHON = python3
PIP = pip3
MANAGE = python manage.py
VENV_NAME = venv

# Docker variables
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_PROD = docker-compose -f docker-compose.yml -f docker-compose.prod.yml

# Help command
help:
	@echo "Available commands:"
	@echo "  make init-full    - Initialize the project with interactive prompts"
	@echo "  make install      - Install dependencies"
	@echo "  make migrate      - Run database migrations"
	@echo "  make superuser    - Create a superuser"
	@echo "  make run          - Run the development server"
	@echo "  make test         - Run tests"
	@echo "  make lint         - Run linting"
	@echo "  make format       - Format code"
	@echo "  make type-check   - Run type checking"
	@echo "  make clean        - Clean up Python cache files"
	@echo "  make docker-init  - Initialize Docker configuration files"
	@echo "  make docker-build - Build Docker containers"
	@echo "  make docker-up    - Start Docker containers"
	@echo "  make docker-down  - Stop Docker containers"
	@echo "  make docker-logs  - View Docker container logs"
	@echo "  make docker-shell - Open a shell in the web container"
	@echo "  make docker-prod  - Build and start production containers"
	@echo "  make docker-clean - Remove all Docker containers and volumes"
	@echo "  make health-check - Run health checks"
	@echo "  make metrics      - View application metrics"
	@echo "  make backup       - Backup database"
	@echo "  make restore      - Restore database"

# Initialize project with interactive prompts
init-full:
	@echo "Initializing $(PROJECT_NAME)..."
	@read -p "Enter project name [$(PROJECT_NAME)]: " project_name; \
	project_name=$${project_name:-$(PROJECT_NAME)}; \
	project_name=$$(echo $$project_name | tr '[:upper:]' '[:lower:]' | tr ' ' '_'); \
	read -p "Enter app name [api]: " app_name; \
	app_name=$${app_name:-api}; \
	app_name=$$(echo $$app_name | tr '[:upper:]' '[:lower:]' | tr ' ' '_'); \
	echo "Project name: $$project_name"; \
	echo "App name: $$app_name"; \
	echo "\nSelect database type:"; \
	echo "1) PostgreSQL (Recommended for production)"; \
	echo "2) MySQL"; \
	echo "3) SQLite (Development only)"; \
	echo "4) MongoDB"; \
	echo "5) Oracle"; \
	echo "6) Microsoft SQL Server"; \
	read -p "Enter database choice [1]: " db_choice; \
	db_choice=$${db_choice:-1}; \
	case $$db_choice in \
		1) \
			db_engine="django.db.backends.postgresql"; \
			db_name="postgres"; \
			db_package="psycopg2-binary"; \
			;; \
		2) \
			db_engine="django.db.backends.mysql"; \
			db_name="mysql"; \
			db_package="mysqlclient"; \
			;; \
		3) \
			db_engine="django.db.backends.sqlite3"; \
			db_name="db.sqlite3"; \
			db_package=""; \
			;; \
		4) \
			db_engine="djongo"; \
			db_name="mongodb"; \
			db_package="djongo"; \
			;; \
		5) \
			db_engine="django.db.backends.oracle"; \
			db_name="oracle"; \
			db_package="cx_Oracle"; \
			;; \
		6) \
			db_engine="mssql"; \
			db_name="mssql"; \
			db_package="mssql-django"; \
			;; \
		*) \
			echo "Invalid choice. Using PostgreSQL."; \
			db_engine="django.db.backends.postgresql"; \
			db_name="postgres"; \
			db_package="psycopg2-binary"; \
			;; \
	esac; \
	echo "\nSelected database: $$db_name"; \
	read -p "Continue? [y/N]: " confirm; \
	if [ "$$confirm" != "y" ]; then \
		echo "Aborted."; \
		exit 1; \
	fi; \
	\
	# Create virtual environment and install dependencies \
	$(PYTHON) -m venv $(VENV_NAME); \
	. $(VENV_NAME)/bin/activate; \
	$(PIP) install -r requirements.txt; \
	if [ ! -z "$$db_package" ]; then \
		$(PIP) install $$db_package; \
	fi; \
	\
	# Create Django project \
	django-admin startproject $$project_name .; \
	\
	# Create app directory structure \
	mkdir -p $$app_name/tests; \
	touch $$app_name/__init__.py; \
	touch $$app_name/tests/__init__.py; \
	\
	# Create app files \
	echo "from django.apps import AppConfig\n\nclass $$(echo $$app_name | sed 's/^./\U&/')Config(AppConfig):\n    default_auto_field = 'django.db.models.BigAutoField'\n    name = '$$app_name'" > $$app_name/apps.py; \
	\
	# Create models.py \
	echo "from django.contrib.auth.models import AbstractUser\nfrom django.db import models\n\nclass User(AbstractUser):\n    \"\"\"Custom user model with additional fields.\"\"\"\n    email = models.EmailField(unique=True)\n    is_active = models.BooleanField(default=True)\n    date_joined = models.DateTimeField(auto_now_add=True)\n    last_login = models.DateTimeField(auto_now=True)\n\n    class Meta:\n        verbose_name = 'User'\n        verbose_name_plural = 'Users'\n\n    def __str__(self):\n        return self.email" > $$app_name/models.py; \
	\
	# Create serializers.py \
	echo "from rest_framework import serializers\nfrom django.contrib.auth import get_user_model\n\nUser = get_user_model()\n\nclass UserSerializer(serializers.ModelSerializer):\n    \"\"\"Serializer for the User model.\"\"\"\n    class Meta:\n        model = User\n        fields = ('id', 'username', 'email', 'password', 'is_active')\n        extra_kwargs = {'password': {'write_only': True}}\n\n    def create(self, validated_data):\n        user = User.objects.create_user(**validated_data)\n        return user" > $$app_name/serializers.py; \
	\
	# Create views.py \
	echo "from rest_framework import viewsets, permissions\nfrom rest_framework_simplejwt.views import TokenObtainPairView\nfrom django.contrib.auth import get_user_model\nfrom .serializers import UserSerializer\n\nUser = get_user_model()\n\nclass UserViewSet(viewsets.ModelViewSet):\n    \"\"\"ViewSet for the User model.\"\"\"\n    queryset = User.objects.all()\n    serializer_class = UserSerializer\n    permission_classes = [permissions.IsAuthenticated]\n\n    def get_permissions(self):\n        if self.action == 'create':\n            return [permissions.AllowAny()]\n        return super().get_permissions()" > $$app_name/views.py; \
	\
	# Create urls.py \
	echo "from django.urls import path, include\nfrom rest_framework.routers import DefaultRouter\nfrom .views import UserViewSet\n\nrouter = DefaultRouter()\nrouter.register(r'users', UserViewSet)\n\nurlpatterns = [\n    path('', include(router.urls)),\n]" > $$app_name/urls.py; \
	\
	# Create admin.py \
	echo "from django.contrib import admin\nfrom django.contrib.auth import get_user_model\n\nUser = get_user_model()\n\n@admin.register(User)\nclass UserAdmin(admin.ModelAdmin):\n    list_display = ('username', 'email', 'is_active', 'date_joined')\n    search_fields = ('username', 'email')\n    list_filter = ('is_active', 'date_joined')" > $$app_name/admin.py; \
	\
	# Create test files \
	echo "from django.test import TestCase\nfrom django.contrib.auth import get_user_model\n\nUser = get_user_model()\n\nclass UserModelTest(TestCase):\n    def setUp(self):\n        self.user_data = {\n            'username': 'testuser',\n            'email': 'test@example.com',\n            'password': 'testpass123'\n        }\n\n    def test_create_user(self):\n        user = User.objects.create_user(**self.user_data)\n        self.assertEqual(user.username, self.user_data['username'])\n        self.assertEqual(user.email, self.user_data['email'])\n        self.assertTrue(user.check_password(self.user_data['password']))" > $$app_name/tests/test_models.py; \
	\
	echo "from django.test import TestCase\nfrom django.urls import reverse\nfrom rest_framework.test import APIClient\nfrom django.contrib.auth import get_user_model\n\nUser = get_user_model()\n\nclass UserViewSetTest(TestCase):\n    def setUp(self):\n        self.client = APIClient()\n        self.user_data = {\n            'username': 'testuser',\n            'email': 'test@example.com',\n            'password': 'testpass123'\n        }\n        self.user = User.objects.create_user(**self.user_data)\n        self.client.force_authenticate(user=self.user)\n\n    def test_create_user(self):\n        url = reverse('user-list')\n        data = {\n            'username': 'newuser',\n            'email': 'new@example.com',\n            'password': 'newpass123'\n        }\n        response = self.client.post(url, data)\n        self.assertEqual(response.status_code, 201)" > $$app_name/tests/test_views.py; \
	\
	# Create necessary directories \
	mkdir -p static/admin media logs templates/admin; \
	\
	# Update project settings \
	sed -i '' "s/INSTALLED_APPS = \[/INSTALLED_APPS = \[\n    'rest_framework',\n    'rest_framework_simplejwt',\n    'drf_spectacular',\n    'corsheaders',\n    '$$app_name',/" $$project_name/settings.py; \
	\
	# Update database settings \
	sed -i '' "s/DATABASES = {/DATABASES = {\n    'default': {\n        'ENGINE': '$$db_engine',\n        'NAME': '$$db_name',\n        'USER': '',\n        'PASSWORD': '',\n        'HOST': '',\n        'PORT': '',\n    },/" $$project_name/settings.py; \
	\
	# Update project URLs \
	echo "from django.contrib import admin\nfrom django.urls import path, include\nfrom drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView\n\nurlpatterns = [\n    path('admin/', admin.site.urls),\n    path('api/', include('$$app_name.urls')),\n    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),\n    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),\n]" > $$project_name/urls.py; \
	\
	# Create .env file from example \
	cp .env.example .env; \
	\
	# Update .env with database settings \
	sed -i '' "s/DB_ENGINE=.*/DB_ENGINE=$$db_engine/" .env; \
	sed -i '' "s/DB_NAME=.*/DB_NAME=$$db_name/" .env; \
	\
	# Run migrations and create superuser \
	$(MANAGE) makemigrations; \
	$(MANAGE) migrate; \
	$(MANAGE) createsuperuser; \
	$(MANAGE) collectstatic --noinput; \
	\
	echo "Project initialized successfully with $$db_name database!"

# Install dependencies
install:
	. $(VENV_NAME)/bin/activate && $(PIP) install -r requirements.txt

# Run migrations
migrate:
	. $(VENV_NAME)/bin/activate && $(MANAGE) migrate

# Create superuser
superuser:
	. $(VENV_NAME)/bin/activate && $(MANAGE) createsuperuser

# Run development server
run:
	. $(VENV_NAME)/bin/activate && $(MANAGE) runserver

# Run tests
test:
	. $(VENV_NAME)/bin/activate && pytest

# Run linting
lint:
	. $(VENV_NAME)/bin/activate && flake8

# Format code
format:
	. $(VENV_NAME)/bin/activate && black . && isort .

# Clean up Python cache files
clean:
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -r {} +
	find . -type d -name "*.egg" -exec rm -r {} +
	find . -type d -name ".pytest_cache" -exec rm -r {} +
	find . -type d -name ".coverage" -exec rm -r {} +
	find . -type d -name "htmlcov" -exec rm -r {} +

# Initialize Docker configuration
docker-init:
	@echo "Creating Docker configuration files..."
	@mkdir -p nginx/ssl
	@echo "Creating Dockerfile..."
	@echo "# Use Python 3.12 slim image\nFROM python:3.12-slim\n\n# Set environment variables\nENV PYTHONDONTWRITEBYTECODE=1 \\\n    PYTHONUNBUFFERED=1 \\\n    DJANGO_SETTINGS_MODULE=$(PROJECT_NAME).settings\n\n# Set work directory\nWORKDIR /app\n\n# Install system dependencies\nRUN apt-get update && apt-get install -y --no-install-recommends \\\n    build-essential \\\n    libpq-dev \\\n    && rm -rf /var/lib/apt/lists/*\n\n# Install Python dependencies\nCOPY requirements.txt .\nRUN pip install --no-cache-dir -r requirements.txt\n\n# Copy project files\nCOPY . .\n\n# Collect static files\nRUN python manage.py collectstatic --noinput\n\n# Create non-root user\nRUN useradd -m appuser && chown -R appuser:appuser /app\nUSER appuser\n\n# Run gunicorn\nCMD [\"gunicorn\", \"--bind\", \"0.0.0.0:8000\", \"$(PROJECT_NAME).wsgi:application\"]" > Dockerfile
	@echo "Creating docker-compose.yml..."
	@echo "version: '3.8'\n\nservices:\n  web:\n    build: .\n    command: gunicorn $(PROJECT_NAME).wsgi:application --bind 0.0.0.0:8000\n    volumes:\n      - .:/app\n      - static_volume:/app/staticfiles\n      - media_volume:/app/media\n    ports:\n      - \"8000:8000\"\n    env_file:\n      - .env\n    depends_on:\n      - db\n    networks:\n      - app_network\n\n  db:\n    image: postgres:15\n    volumes:\n      - postgres_data:/var/lib/postgresql/data/\n    environment:\n      - POSTGRES_DB=$${DB_NAME}\n      - POSTGRES_USER=$${DB_USER}\n      - POSTGRES_PASSWORD=$${DB_PASSWORD}\n    networks:\n      - app_network\n\n  nginx:\n    image: nginx:1.25\n    volumes:\n      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro\n      - static_volume:/app/staticfiles\n      - media_volume:/app/media\n    ports:\n      - \"80:80\"\n      - \"443:443\"\n    depends_on:\n      - web\n    networks:\n      - app_network\n\nvolumes:\n  postgres_data:\n  static_volume:\n  media_volume:\n\nnetworks:\n  app_network:\n    driver: bridge" > docker-compose.yml
	@echo "Creating docker-compose.prod.yml..."
	@echo "version: '3.8'\n\nservices:\n  web:\n    build:\n      context: .\n      dockerfile: Dockerfile\n    env_file:\n      - .env.prod\n    restart: always\n    depends_on:\n      - db\n    volumes:\n      - static_volume:/app/staticfiles\n      - media_volume:/app/media\n    networks:\n      - app_network\n\n  db:\n    image: postgres:15\n    env_file:\n      - .env.prod\n    volumes:\n      - postgres_data:/var/lib/postgresql/data/\n    networks:\n      - app_network\n\n  nginx:\n    build:\n      context: ./nginx\n      dockerfile: Dockerfile\n    ports:\n      - \"80:80\"\n      - \"443:443\"\n    volumes:\n      - static_volume:/app/staticfiles\n      - media_volume:/app/media\n      - ./nginx/ssl:/etc/nginx/ssl\n    depends_on:\n      - web\n    networks:\n      - app_network\n\nvolumes:\n  postgres_data:\n  static_volume:\n  media_volume:\n\nnetworks:\n  app_network:\n    driver: bridge" > docker-compose.prod.yml
	@echo "Creating nginx/Dockerfile..."
	@echo "FROM nginx:1.25\n\n# Remove default nginx configuration\nRUN rm /etc/nginx/conf.d/default.conf\n\n# Copy custom nginx configuration\nCOPY nginx.conf /etc/nginx/conf.d/\n\n# Create directory for SSL certificates\nRUN mkdir -p /etc/nginx/ssl\n\n# Create directory for static and media files\nRUN mkdir -p /app/staticfiles /app/media\n\n# Set proper permissions\nRUN chown -R nginx:nginx /app/staticfiles /app/media\n\n# Expose ports\nEXPOSE 80 443\n\n# Start Nginx\nCMD [\"nginx\", \"-g\", \"daemon off;\"]" > nginx/Dockerfile
	@echo "Creating nginx/nginx.conf..."
	@echo "upstream django {\n    server web:8000;\n}\n\nserver {\n    listen 80;\n    server_name localhost;\n\n    location / {\n        return 301 https://$$host$$request_uri;\n    }\n}\n\nserver {\n    listen 443 ssl;\n    server_name localhost;\n\n    ssl_certificate /etc/nginx/ssl/cert.pem;\n    ssl_certificate_key /etc/nginx/ssl/key.pem;\n\n    # SSL configuration\n    ssl_protocols TLSv1.2 TLSv1.3;\n    ssl_ciphers HIGH:!aNULL:!MD5;\n    ssl_prefer_server_ciphers on;\n    ssl_session_cache shared:SSL:10m;\n    ssl_session_timeout 10m;\n\n    # Security headers\n    add_header X-Frame-Options \"DENY\" always;\n    add_header X-XSS-Protection \"1; mode=block\" always;\n    add_header X-Content-Type-Options \"nosniff\" always;\n    add_header Referrer-Policy \"no-referrer-when-downgrade\" always;\n    add_header Content-Security-Policy \"default-src 'self' http: https: data: blob: 'unsafe-inline'\" always;\n    add_header Strict-Transport-Security \"max-age=31536000; includeSubDomains\" always;\n\n    # Proxy headers\n    proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;\n    proxy_set_header X-Forwarded-Proto $$scheme;\n    proxy_set_header Host $$host;\n    proxy_redirect off;\n\n    # Static files\n    location /static/ {\n        alias /app/staticfiles/;\n        expires 30d;\n        add_header Cache-Control \"public, no-transform\";\n    }\n\n    # Media files\n    location /media/ {\n        alias /app/media/;\n        expires 30d;\n        add_header Cache-Control \"public, no-transform\";\n    }\n\n    # API endpoints\n    location /api/ {\n        proxy_pass http://django;\n        proxy_set_header X-Real-IP $$remote_addr;\n        proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;\n        proxy_set_header Host $$host;\n        proxy_set_header X-Forwarded-Proto $$scheme;\n    }\n\n    # Admin interface\n    location /admin/ {\n        proxy_pass http://django;\n        proxy_set_header X-Real-IP $$remote_addr;\n        proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;\n        proxy_set_header Host $$host;\n        proxy_set_header X-Forwarded-Proto $$scheme;\n    }\n\n    # API documentation\n    location /api/docs/ {\n        proxy_pass http://django;\n        proxy_set_header X-Real-IP $$remote_addr;\n        proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;\n        proxy_set_header Host $$host;\n        proxy_set_header X-Forwarded-Proto $$scheme;\n    }\n\n    # Default location\n    location / {\n        proxy_pass http://django;\n        proxy_set_header X-Real-IP $$remote_addr;\n        proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;\n        proxy_set_header Host $$host;\n        proxy_set_header X-Forwarded-Proto $$scheme;\n    }\n}" > nginx/nginx.conf
	@echo "Docker configuration files created successfully!"

# Docker commands
docker-build:
	$(DOCKER_COMPOSE) build

docker-up:
	$(DOCKER_COMPOSE) up -d

docker-down:
	$(DOCKER_COMPOSE) down

docker-logs:
	$(DOCKER_COMPOSE) logs -f

docker-shell:
	$(DOCKER_COMPOSE) exec web bash

docker-prod:
	$(DOCKER_COMPOSE_PROD) up --build -d

docker-clean:
	$(DOCKER_COMPOSE) down -v
	docker system prune -f

# Docker development commands
docker-migrate:
	$(DOCKER_COMPOSE) exec web python manage.py migrate

docker-superuser:
	$(DOCKER_COMPOSE) exec web python manage.py createsuperuser

docker-collectstatic:
	$(DOCKER_COMPOSE) exec web python manage.py collectstatic --noinput

# Docker production commands
docker-prod-migrate:
	$(DOCKER_COMPOSE_PROD) exec web python manage.py migrate

docker-prod-superuser:
	$(DOCKER_COMPOSE_PROD) exec web python manage.py createsuperuser

docker-prod-collectstatic:
	$(DOCKER_COMPOSE_PROD) exec web python manage.py collectstatic --noinput

# Docker SSL commands
docker-ssl-init:
	mkdir -p nginx/ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout nginx/ssl/key.pem \
		-out nginx/ssl/cert.pem \
		-subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Docker backup commands
docker-backup:
	$(DOCKER_COMPOSE) exec db pg_dump -U postgres postgres > backup_$$(date +%Y%m%d_%H%M%S).sql

docker-restore:
	@read -p "Enter backup file name: " backup_file; \
	$(DOCKER_COMPOSE) exec -T db psql -U postgres postgres < $$backup_file

# Type checking
type-check:
	. $(VENV_NAME)/bin/activate && mypy .

# Health check
health-check:
	. $(VENV_NAME)/bin/activate && $(MANAGE) health_check

# View metrics
metrics:
	. $(VENV_NAME)/bin/activate && $(MANAGE) prometheus_metrics

# Backup database
backup:
	. $(VENV_NAME)/bin/activate && $(MANAGE) dumpdata > backup_$$(date +%Y%m%d_%H%M%S).json

# Restore database
restore:
	@read -p "Enter backup file name: " backup_file; \
	. $(VENV_NAME)/bin/activate && $(MANAGE) loaddata $$backup_file

# Cache management
cache-clear:
	. $(VENV_NAME)/bin/activate && $(MANAGE) cache_clear

# Redis management
redis-flush:
	. $(VENV_NAME)/bin/activate && $(MANAGE) redis_flush

# Performance monitoring
profile:
	. $(VENV_NAME)/bin/activate && $(MANAGE) profile

# Security checks
security-check:
	. $(VENV_NAME)/bin/activate && bandit -r .
	. $(VENV_NAME)/bin/activate && safety check

.PHONY: help init-full install migrate superuser run test lint format clean \
	docker-init docker-build docker-up docker-down docker-logs docker-shell docker-prod docker-clean \
	docker-migrate docker-superuser docker-collectstatic \
	docker-prod-migrate docker-prod-superuser docker-prod-collectstatic \
	docker-ssl-init docker-backup docker-restore \
	type-check health-check metrics backup restore \
	cache-clear redis-flush profile security-check 
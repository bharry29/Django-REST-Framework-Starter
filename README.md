# Django REST Framework Starter

A production-ready Django REST API template with best practices, security features, and comprehensive documentation. Also known as "DRF Starter" for short.

## Features

- 🔐 **Security First**: JWT authentication, CORS protection, rate limiting, and more
- 📚 **API Documentation**: Swagger UI integration with drf-spectacular
- 🐳 **Docker Support**: Production-ready Docker configuration with Nginx
- 🗄️ **Database Support**: PostgreSQL, MySQL, SQLite, MongoDB, Oracle, MS SQL Server
- 📊 **Monitoring**: Health checks, metrics, and error tracking
- 🧪 **Testing**: Comprehensive test suite with pytest
- 🛠️ **Development Tools**: Code formatting, linting, and type checking
- 🔄 **CI/CD Ready**: GitHub Actions workflow included

## Use Cases

### 1. 🚀 Rapid API Development
- **Perfect for**: Startups and MVPs
- **Key Benefits**:
  - Quick setup with production-ready security
  - Built-in user authentication
  - API documentation out of the box
  - Easy to extend and customize
- **Example**: Building a mobile app backend in days instead of weeks

### 2. 🔒 Enterprise Applications
- **Perfect for**: Large organizations
- **Key Benefits**:
  - Enterprise-grade security features
  - Multiple database support
  - Comprehensive monitoring
  - Scalable architecture
- **Example**: Internal tools, employee portals, or customer-facing APIs

### 3. 📱 Mobile App Backend
- **Perfect for**: Mobile developers
- **Key Benefits**:
  - JWT authentication for mobile apps
  - CORS configuration for mobile clients
  - Rate limiting for API protection
  - File upload handling
- **Example**: Backend for iOS/Android apps with user authentication

### 4. 🎓 Learning Projects
- **Perfect for**: Students and developers learning Django
- **Key Benefits**:
  - Production-ready code examples
  - Best practices implementation
  - Comprehensive documentation
  - Testing examples
- **Example**: Learning Django REST Framework with real-world patterns

### 5. 🔄 Microservices
- **Perfect for**: Microservices architecture
- **Key Benefits**:
  - Docker containerization
  - Health monitoring
  - API documentation
  - Easy deployment
- **Example**: Building individual microservices with consistent patterns

### 6. 📊 Data APIs
- **Perfect for**: Data-driven applications
- **Key Benefits**:
  - Multiple database support
  - Efficient data serialization
  - Caching capabilities
  - Rate limiting
- **Example**: APIs for data analytics or reporting systems

### 7. 🔐 Authentication Service
- **Perfect for**: Authentication providers
- **Key Benefits**:
  - JWT token management
  - User management
  - Security features
  - API documentation
- **Example**: Centralized authentication service for multiple applications

### 8. 🛍️ E-commerce Backend
- **Perfect for**: Online stores
- **Key Benefits**:
  - User management
  - File handling for products
  - Security features
  - Database flexibility
- **Example**: REST API for e-commerce platforms

### 9. 📱 Progressive Web Apps (PWA)
- **Perfect for**: Web applications
- **Key Benefits**:
  - RESTful API structure
  - CORS configuration
  - File handling
  - Authentication
- **Example**: Backend for modern web applications

### 10. 🔄 API Gateway
- **Perfect for**: API management
- **Key Benefits**:
  - Rate limiting
  - Authentication
  - Documentation
  - Monitoring
- **Example**: Central API gateway for multiple services

## Quick Start

### Prerequisites

- Python 3.12+
- Docker and Docker Compose (for containerized setup)
- Git

### Setup Instructions

1. **Clone and Initialize**
   ```bash
   git clone https://github.com/yourusername/drf-starter.git
   cd drf-starter
   make init-full
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. **Choose Your Setup Method**

   **Local Development:**
   ```bash
   make install
   make migrate
   make createsuperuser
   make run
   ```

   **Docker Development:**
   ```bash
   make docker-build
   make docker-up
   make docker-migrate
   make docker-createsuperuser
   make docker-collectstatic
   ```

4. **Access Your Application**
   - API: http://localhost:8000/api/
   - Admin: http://localhost:8000/admin/
   - API Docs: http://localhost:8000/api/schema/swagger-ui/

5. **Production Deployment**
   ```bash
   # Configure production settings
   cp .env.example .env.prod
   # Edit .env.prod with production settings
   
   # Deploy with Docker
   make docker-prod
   ```

## Available Make Commands

### Development Commands
- `make install` - Install dependencies
- `make migrate` - Run database migrations
- `make run` - Start development server
- `make test` - Run tests
- `make lint` - Run code linting
- `make format` - Format code
- `make type-check` - Run type checking

### Docker Commands
- `make docker-build` - Build Docker images
- `make docker-up` - Start Docker containers
- `make docker-down` - Stop Docker containers
- `make docker-logs` - View Docker logs
- `make docker-shell` - Open shell in web container

### Production Commands
- `make docker-prod` - Deploy to production
- `make docker-prod-down` - Stop production deployment
- `make docker-prod-logs` - View production logs
- `make docker-prod-backup` - Backup production data
- `make docker-prod-restore` - Restore production data

## Community Guidelines

We welcome contributions from the community! Please read our community guidelines before contributing:

- [Code of Conduct](CODE_OF_CONDUCT.md) - Our community standards and enforcement guidelines
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to this project
- [Changelog](CHANGELOG.md) - Version history and changes

### How to Contribute

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

For detailed contribution guidelines, please see our [Contributing Guide](CONTRIBUTING.md).

## Security Features

- JWT token authentication with refresh tokens
- Password hashing with PBKDF2
- CORS protection
- Rate limiting
- SSL/TLS encryption
- Security headers
- XSS protection
- CSRF protection
- SQL injection protection
- Secure password validation
- Session security
- File upload security

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- [GitHub Issues](https://github.com/yourusername/drf-starter/issues) - Report bugs or request features
- [Discussions](https://github.com/yourusername/drf-starter/discussions) - Join community discussions
- [Documentation](https://github.com/yourusername/drf-starter/wiki) - Detailed documentation and guides

## Acknowledgments

- [Django](https://www.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [drf-spectacular](https://drf-spectacular.readthedocs.io/)
- [Contributor Covenant](https://www.contributor-covenant.org/)

## Database Options

The template supports multiple database options:

1. **PostgreSQL** (Recommended for Production)
   - Most popular choice for Django applications
   - Excellent performance and reliability
   - Full support for all Django features
   - Great for complex queries and large datasets

2. **MySQL**
   - Widely used in production
   - Good performance and reliability
   - Full support for most Django features
   - Popular choice for web applications

3. **SQLite** (Development Only)
   - Lightweight and file-based
   - No server setup required
   - Perfect for development and testing
   - Not recommended for production

4. **MongoDB**
   - NoSQL database option
   - Great for flexible schemas
   - Good for document-based data
   - Requires additional configuration

5. **Oracle**
   - Enterprise-grade database
   - Excellent for large-scale applications
   - Requires Oracle client installation
   - Good for existing Oracle environments

6. **Microsoft SQL Server**
   - Enterprise-grade database
   - Good for Windows environments
   - Requires SQL Server installation
   - Suitable for .NET integration

### Database Selection

During project initialization (`make init-full`), you'll be prompted to choose your database. The template will:
1. Install the appropriate database driver
2. Configure the database settings
3. Set up the necessary environment variables
4. Create the initial database structure

### Database Configuration

Database settings are stored in:
- `.env` file for environment variables
- `settings.py` for Django configuration

Example database configuration in `.env`:
```ini
# Database settings
DB_ENGINE=django.db.backends.postgresql
DB_NAME=your_database_name
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_HOST=localhost
DB_PORT=5432
```

## Template Files Structure

### Core Files
```
.
├── Makefile                 # Project commands and automation
├── README.md               # Project documentation
├── requirements.txt        # Python dependencies
├── manage.py              # Django management script
├── .gitignore            # Git ignore rules
├── pytest.ini            # Test configuration
├── .env.example          # Environment variables template
└── LICENSE               # MIT License
```

### Project Structure (Generated by make init-full)
```
.
├── <project_name>/           # Project configuration
│   ├── __init__.py
│   ├── settings.py          # Project settings
│   ├── urls.py             # Project URL configuration
│   ├── asgi.py             # ASGI configuration
│   └── wsgi.py             # WSGI configuration
│
├── <app_name>/              # Main API application
│   ├── __init__.py
│   ├── admin.py            # Admin interface configuration
│   ├── apps.py             # App configuration
│   ├── models.py           # Database models
│   ├── serializers.py      # API serializers
│   ├── urls.py             # App URL configuration
│   ├── views.py            # API views
│   └── tests/              # Test directory
│       ├── __init__.py
│       ├── test_models.py
│       ├── test_views.py
│       └── test_serializers.py
│
├── static/                  # Static files
│   └── admin/
│
├── media/                   # User-uploaded files
│
├── logs/                    # Application logs
│
├── nginx/                   # Nginx configuration
│   ├── nginx.conf
│   ├── Dockerfile
│   └── ssl/                # SSL certificates
│
└── templates/              # HTML templates
    └── admin/
```

### Example Files

#### .env.example
```ini
# Django settings
DEBUG=True
DJANGO_SECRET_KEY=your-secure-secret-key-here
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

# Database settings
DB_ENGINE=django.db.backends.sqlite3
DB_NAME=db.sqlite3
DB_USER=
DB_PASSWORD=
DB_HOST=
DB_PORT=

# JWT settings
JWT_ACCESS_TOKEN_LIFETIME_MINUTES=60
JWT_REFRESH_TOKEN_LIFETIME_DAYS=7

# CORS settings
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

#### <app_name>/models.py
```python
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    """Custom user model with additional fields."""
    email = models.EmailField(unique=True)
    is_active = models.BooleanField(default=True)
    date_joined = models.DateTimeField(auto_now_add=True)
    last_login = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return self.email
```

#### <app_name>/serializers.py
```python
from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    """Serializer for the User model."""
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'password', 'is_active')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user
```

#### <app_name>/views.py
```python
from rest_framework import viewsets, permissions
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import get_user_model
from .serializers import UserSerializer

User = get_user_model()

class UserViewSet(viewsets.ModelViewSet):
    """ViewSet for the User model."""
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_permissions(self):
        if self.action == 'create':
            return [permissions.AllowAny()]
        return super().get_permissions()
```

#### <app_name>/tests/test_models.py
```python
from django.test import TestCase
from django.contrib.auth import get_user_model

User = get_user_model()

class UserModelTest(TestCase):
    def setUp(self):
        self.user_data = {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'testpass123'
        }

    def test_create_user(self):
        user = User.objects.create_user(**self.user_data)
        self.assertEqual(user.username, self.user_data['username'])
        self.assertEqual(user.email, self.user_data['email'])
        self.assertTrue(user.check_password(self.user_data['password']))
```

#### <app_name>/tests/test_views.py
```python
from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model

User = get_user_model()

class UserViewSetTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user_data = {
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'testpass123'
        }
        self.user = User.objects.create_user(**self.user_data)
        self.client.force_authenticate(user=self.user)

    def test_create_user(self):
        url = reverse('user-list')
        data = {
            'username': 'newuser',
            'email': 'new@example.com',
            'password': 'newpass123'
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 201)
``` 
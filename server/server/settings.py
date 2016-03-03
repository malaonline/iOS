"""
Django settings for server project.

Generated by 'django-admin startproject' using Django 1.8.6.

For more information on this file, see
https://docs.djangoproject.com/en/1.8/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.8/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.8/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '0jid#n&g1!*f&z7$_^-qfqt2x_hgsv2gw%1ad%%-ml9%dm#7bl'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []

DEFAULT_CHARSET = 'utf-8'

# Application definition

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework.authtoken',
    'django_s3_storage',
    'static_precompiler',
    'app',
    'teacher',
    'staff',
)

REST_FRAMEWORK = {
    # Use Django's standard `django.contrib.auth` permissions,
    # or allow read-only access for unauthenticated users.
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.TokenAuthentication',
    ),
    'DEFAULT_RENDERER_CLASSES': (
        'app.renderer.CustomJSONRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ),
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.DjangoModelPermissionsOrAnonReadOnly'
    ],
    'EXCEPTION_HANDLER': 'app.exception.exception_handler',
    'PAGE_SIZE': 10,
    'DEFAULT_THROTTLE_CLASSES': (
        'app.throttles.BurstRateThrottle',
        'app.throttles.SustainedRateThrottle'
    ),
    'DEFAULT_THROTTLE_RATES': {
        'burst': '60/min',
        'sustained': '1000/day'
    },
}

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.security.SecurityMiddleware',
)

ROOT_URLCONF = 'server.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'server.wsgi.application'

# Database
# https://docs.djangoproject.com/en/1.8/ref/settings/#databases
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    'static_precompiler.finders.StaticPrecompilerFinder',
)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'maladb',
        'USER': 'malauser',
        'PASSWORD': 'mala123',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}


# Internationalization
# https://docs.djangoproject.com/en/1.8/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Shanghai'

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)

STATIC_URL = '/dev-static/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static")    # same level with apps
]

LOGIN_URL = '/login/'

STATIC_ROOT = '/var/www/static/'
MEDIA_ROOT = '/var/www/upload/'
MEDIA_URL = '/upload/'

# DEFAULT_FILE_STORAGE = 'django_s3_storage.storage.S3Storage'
# STATICFILES_STORAGE = 'django_s3_storage.storage.StaticS3Storage'

DEFAULT_FILE_STORAGE = 'django.core.files.storage.FileSystemStorage'
STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.StaticFilesStorage'

STATIC_PRECOMPILER_ROOT = os.path.join(BASE_DIR, 'static')
STATIC_PRECOMPILER_OUTPUT_DIR = 'compiled'

AWS_REGION = 'cn-north-1'
AWS_ACCESS_KEY_ID = 'AKIAP22CWKUZDOMHLFGA'
AWS_SECRET_ACCESS_KEY = '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'
AWS_S3_BUCKET_NAME = 'dev-upload'
AWS_S3_CALLING_FORMAT = "boto.s3.connection.OrdinaryCallingFormat"
AWS_S3_KEY_PREFIX = ""
AWS_S3_BUCKET_AUTH = True
AWS_S3_MAX_AGE_SECONDS = 60*60  # 1 hour.
AWS_S3_PUBLIC_URL = ''
AWS_S3_REDUCED_REDUNDANCY = False

AWS_S3_BUCKET_NAME_STATIC = "dev-static"
AWS_S3_CALLING_FORMAT_STATIC = "boto.s3.connection.OrdinaryCallingFormat"
AWS_S3_BUCKET_AUTH_STATIC = False
AWS_S3_KEY_PREFIX_STATIC = ""
AWS_S3_MAX_AGE_SECONDS_STATIC = 60*60*24*365  # 1 year.
AWS_S3_PUBLIC_URL_STATIC = ''
AWS_S3_REDUCED_REDUNDANCY_STATIC = False

YUNPIAN_API_KEY = 'f79c************************1569'  # yunpian.com sms api key

PINGPP_API_KEY = 'sk_test_TGi9q1m5iPmHX9Cin18e1C88'
PINGPP_APP_ID = 'app_eHWnr9D4qb90Sq1O'
PINGPP_PUB_KEY = open(os.path.join(BASE_DIR, 'server/pingpp.pub'), 'rb').read()

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': ("[%(asctime)s] %(levelname)s [%(name)s:%(lineno)s] " +
                       "%(message)s"),
            'datefmt': "%d/%b/%Y %H:%M:%S"
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': 'log.log',
            'formatter': 'verbose'
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'propagate': True,
            'level': 'DEBUG',
        },
        'app': {
            'handlers': ['file'],
            'propagate': True,
            'level': 'DEBUG',
        },
        # 'django.db.backends':{
        #     'handlers': ['file'],
        #     'level': 'DEBUG'
        # }
    }
}

# 样本数据配置
SAMPLE_DATA_LENGTH = 20  # 长度
SAMPLE_PARENT_USER_FORMULA = "parent{id}"
SAMPLE_TEACHER_USER_FORMULA = "test{id}"
UNITTEST = False

# 加密的密钥salt
PASSWORD_SALT = "abc"

# 内部测试配置
# 固定的sms
FAKE_SMS_SERVER = True
# 固定的审核进度
FIX_TEACHER_STATUS = True


try:
    from .local_settings import *
except:
    pass

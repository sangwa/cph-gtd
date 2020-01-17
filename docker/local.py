### Based on: https://github.com/shacker/gtd/blob/master/project/local.example.py ###

# Overrides
from .settings import *  # noqa: F401

# Disable Host header checks
ALLOWED_HOSTS = ['*']

# Django signing key populated from k8s secrets
SECRET_KEY = os.environ['SECRET_KEY']

DEBUG = True

# Also populate DB connection settings from k8s environment
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('PG_NAME', 'gtd'),
        'USER': os.environ.get('PG_USER', 'gtd'),
        'PASSWORD': os.environ.get('PG_PASS', ''),
        'HOST': os.environ.get('PG_HOST', '127.0.0.1'),
        'PORT': os.environ.get('PG_PORT', ''),
    },
}

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# TODO-specific settings
TODO_STAFF_ONLY = False
TODO_DEFAULT_LIST_SLUG = 'tickets'
TODO_DEFAULT_ASSIGNEE = None
TODO_PUBLIC_SUBMIT_REDIRECT = '/'

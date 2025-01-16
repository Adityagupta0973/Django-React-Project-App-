set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --no-input

python manage.py migrate

if [[ $CREATE_SUPERUSER == "True" ]]; then
    python manage.py shell << END
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username="${DJANGO_SUPERUSER_USERNAME}").exists():
    User.objects.create_superuser(
        username="${DJANGO_SUPERUSER_USERNAME}",
        email="${DJANGO_SUPERUSER_EMAIL}",
        password="${DJANGO_SUPERUSER_PASSWORD}"
    )
    print("Superuser created successfully.")
else:
    print("Superuser already exists.")
END
fi 
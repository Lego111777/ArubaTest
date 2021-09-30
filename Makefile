up:
	@docker-compose up
	@echo "Startup complete, you can now browse to 'localhost:8000'"

upd:
	@docker-compose up -d

build:
	@docker-compose build
	@pre-commit install -f

stop:
	@docker-compose stop

start: build up

down:
	@docker-compose down

restart:
	@docker-compose restart

restartw:
	@docker-compose restart web

shell:
	@docker-compose run --rm web python manage.py shell

logs:
	@docker-compose logs -tf

logscw:
	@docker-compose logs -tf celery-worker

logscb:
	@docker-compose logs -tf celery-beat

logsw:
	@docker-compose logs -tf web

makemigrations:
	@docker-compose run --rm web python manage.py makemigrations

migrate:
	@docker-compose run --rm web python manage.py migrate

migrate_ftfa_db:
	@docker-compose run --rm web python manage.py migrate --database=ftfa_db

migrate_all:
	@docker-compose run --rm web python manage.py migrate
	@docker-compose run --rm web python manage.py migrate --database=ftfa_db

createsuperuser:
	@docker-compose run --rm web python manage.py createsuperuser

blake:
	@black . && flake8 .

test:
	@docker-compose run --rm web coverage run --source='.' manage.py test $(app) --parallel

reset_logins:
	@docker-compose run --rm web python manage.py axes_reset

dbdel:
	@docker volume rm "$(docker volume ls -q | grep portal_postgres | awk "{print $1}" )"

create_ftfa_db:
	@docker-compose up -d
	@docker exec -it portal_db_1 psql -U food_and_trees food_and_trees_db -c "CREATE DATABASE ftfa_db WITH ENCODING 'UTF8' TEMPLATE template0"
	@docker-compose down

collectstatic:
	@docker-compose run --rm web python manage.py collectstatic --noinput


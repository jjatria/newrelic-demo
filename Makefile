UID := $$( id -u )
GID := $$( id -g )

start: snapshot api
	docker-compose up --build -d --remove-orphans
	docker-compose restart www

snapshot:
	docker build . --tag panop:builder --target base --file docker/www
	docker run --rm --env 'PERL_CPANM_HOME=/app/.cpanm' --user "${UID}:${GID}" --volume "${PWD}":/app panop:builder carton install

stop:
	docker-compose down --remove-orphans

api:
	docker build --tag panop:redoc --file docker/redoc docker
	docker run --rm --user "${UID}:${GID}" --volume "${PWD}/public":/docs panop:redoc bundle api.yml --output api.html

logs:
	docker-compose logs --tail 10 -f

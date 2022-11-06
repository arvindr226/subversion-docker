# Setup
Make a traefik.env like:
```
echo 'TRAEFIK_DOMAIN=traefik.example.com' > ./traefik.env
echo 'EMAIL=admin@example.com' >> ./traefik.env
echo 'HASHED_PASSWORD="'$(openssl passwd -apr1 changeit | sed 's/\$/\\\$/g')'"' >> ./traefik.env
```

**Note**
* Change the domain and email address to match what you will be using
* Change the password from `changeit` to be more secure. This is the password for the `admin` user
  on traefik's web interface (available at traefik.example.com) 

# Start

```
$ docker compose --env-file ./traefik.env up -d
```

# Stop

```
$ docker compose -p traefik down
```

## Overrides
The `docker-compose.yaml` on its own will start traefik for http only and start automatically when docker starts.
The `docker-compose.override.yaml` includes SSL via LetsEncrypt's HTTP challenge.

If that meets your needs, this is suitable for production. Start traefik before starting your other services

If you wish to use another challenge (such as DNS), review Traefik's documentation and override the `command:` section.
Since you can't append to `command:`, it's probably best to copy the `docker-compose.override.yaml` and modify it per your needs.
In that case, start with:

```
$ docker compose --env-file ./traefik.env -f ./docker-compose.yaml -f ./my-custom-ssl.yaml up -d
```

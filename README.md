## WIP

## ngrok setup
- ngrok http 4000
- add ngrok address webhook to block native webhooks

## Run the following commands inside the root folder for docker setup
- MIX_ENV=prod mix release
- docker build -t vhs . 
- docker run --name vhs -d --publish 4000:4000 vhs:latest
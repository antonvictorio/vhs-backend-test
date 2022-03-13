## Setup
### Ngrok installation and setup
- download ngrok
  - https://ngrok.com/download
- expose web server on port 4000 of your local machine to the internet

  ```
    ngrok http 4000
  ```
- add ngrok address webhook to block native webhooks
  - https://explorer.blocknative.com/account  

## Basic usage
### Track transactions
  - Endpoint (POST)
    -  http://localhost:4000/blocknative/watch
### Input single tx id
```json
  {
    "tx_id": "SAMPLE HASH"
  }
```
### Input multiple tx ids
```json
  {
    "tx_id": ["HASH1", "HASH2"]
  }
```

### Get current pending transactions
  - Endpoint (GET)
    -  http://localhost:4000/transactions/pending

## Docker setup (optional)
- MIX_ENV=prod mix release
- docker build -t vhs . 
- docker run --name vhs -d --publish 4000:4000 vhs:latest

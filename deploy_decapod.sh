# Run containers 
docker-compose up -d

# Give the containers time to boot up
sleep 10

# Run migrations
docker-compose exec admin decapod-admin migration apply
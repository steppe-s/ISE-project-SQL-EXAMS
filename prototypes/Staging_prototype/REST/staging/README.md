# Build
mvn clean package && docker build -t nl.han.ise/staging .

# RUN

docker rm -f staging || true && docker run -d -p 8080:8080 -p 4848:4848 --name staging nl.han.ise/staging 
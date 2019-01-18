docker build -t codebysid/many:latest -t codebysid/many:$SHA -f ./client/Dockerfile ./client
docker build -t codebysid/server_many:latest -t codebysid/server_many:$SHA -f ./server/Dockerfile ./server
docker build -t codebysid/worker_many:latest -t codebysid/worker_many:$SHA -f ./worker/Dockerfile ./worker

docker push codebysid/many:latest
docker push codebysid/server_many:latest
docker push codebysid/worker_many:latest

docker push codebysid/many:$SHA
docker push codebysid/server_many:$SHA
docker push codebysid/worker_many:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=codebysid/server_many:$SHA
kubectl set image deployments/client-deployment client=codebysid/many:$SHA
kubectl set image deployments/worker-deployment worker=codebysid/worker_many:$SHA

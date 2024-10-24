FILENAME="main"
curl -o "$FILENAME.py" "https://api.waadri.top/ChaoXing/download/other-signin-node.py"

IMAGE_NAME="ccr.ccs.tencentyun.com/misaka-public/waadri-sign-node"

echo "构建arm64"
docker buildx build \
    --builder default \
    --platform linux/arm64 \
    --tag $IMAGE_NAME:arm64 \
    --push \
    .

echo "构建amd64"
docker buildx build \
    --builder default \
    --platform linux/amd64 \
    -t $IMAGE_NAME:amd64 \
    --push \
    .
docker tag $IMAGE_NAME:amd64 $IMAGE_NAME:latest
docker push $IMAGE_NAME:latest

sed -i 's/user_list\[uid\]\["address"\]/os.getenv("HAPPY", user_list[uid]\["address"\])/g' "$FILENAME.py"
sed -i 's/sign_data\["address"\] = address/sign_data\["address"\] = os.getenv("HAPPY", address)/g' "$FILENAME.py"
sed -i 's/set_address = address/set_address = os.getenv("HAPPY", address)/g' "$FILENAME.py"

docker buildx build \
    --builder default \
    --platform linux/arm64 \
    -t $IMAGE_NAME:happy-arm64 \
    --push \
    .
docker buildx build \
    --builder default \
    --platform linux/amd64 \
    -t $IMAGE_NAME:happy-amd64 \
    --push \
    .
GAME_DIR=/home/steam/.klei/DoNotStarveTogether/DediServer
MOD_DIR=/home/steam/dst/mods

# ALWAYS_GENERATE_WORLD
if [ "$ALWAYS_GENERATE_WORLD" = true ]; then
    echo "ALWAYS_GENERATE_WORLD is set to true, regenerating world."
elif [ -e "$GAME_DIR/cluster_token.txt" ]; then
    echo "World already exists, skip creating a new world."
    exit 0  # 或者直接使用 `exit`，默认返回0
fi

echo "Clear existing world data." 

find $GAME_DIR -mindepth 1 -delete
find $MOD_DIR -mindepth 1 -delete

# Create a new world
mkdir -p $GAME_DIR

echo "Generating world..."

# Copy the default world settings
cp -r /home/steam/dst/template/* $GAME_DIR

CLUSTER_KEY="${CLUSTER_KEY:-dst}"
CLUSTER_NAME="${CLUSTER_NAME:-心心与乐乐的世界}"
CLUSTER_DESCRIPTION="${CLUSTER_DESCRIPTION:-心心与乐乐}"

sed -e "s/__master_ip__/$MASTER_IP/g" \
    -e "s/__cluster_key__/$CLUSTER_KEY/g" \
    -e "s/__cluster_name__/$CLUSTER_NAME/g" \
    -e "s/__cluster_description__/$CLUSTER_DESCRIPTION/g" \
    -e "s/__cluster_password__/$CLUSTER_PASSWORD/g" \
    /home/steam/dst/template/cluster.ini > $GAME_DIR/cluster.ini

echo "$CLUSTER_TOKEN" > $GAME_DIR/cluster_token.txt

chmod -R 777 $GAME_DIR
chmod -R 777 $MOD_DIR

cp $GAME_DIR/modoverrides.lua ${GAME_DIR}/Master/modoverrides.lua
mv $GAME_DIR/modoverrides.lua ${GAME_DIR}/Caves/modoverrides.lua

mv $GAME_DIR/dedicated_server_mods_setup.lua $MOD_DIR/dedicated_server_mods_setup.lua

echo "World generation complete."

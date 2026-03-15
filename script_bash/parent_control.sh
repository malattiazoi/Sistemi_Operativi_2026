while true; do
    kill -9=$(ps -e| grep -i fortnite | cut -d" " -f2)
    kill -9=$(ps -e| grep -i battlefield | cut -d" " -f2)
done

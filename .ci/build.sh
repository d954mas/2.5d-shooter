
if [ $# -eq 0 ]; then
	PLATFORM="x86_64-linux"
else
	PLATFORM="$1"
fi

echo "${PLATFORM}"

# {"version": "1.2.89", "sha1": "5ca3dd134cc960c35ecefe12f6dc81a48f212d40"}
SHA1=$(curl -s http://d.defold.com/stable/info.json | sed 's/.*sha1": "\(.*\)".*/\1/')
echo "Using Defold version ${SHA1}"

BOB_URL="http://d.defold.com/archive/${SHA1}/bob/bob.jar"

echo "Downloading ${BOB_URL}"
#curl -o bob.jar ${BOB_URL}

echo "Build content"
java -jar bob.jar --archive --email foo@bar.com -tc true --auth 12345 --brhtml ./.ci/report.html clean resolve build
echo "Build headless"
java -jar bob.jar --variant headless -p $PLATFORM  -bo ./.ci/bundle/headless bundle
echo "Build html"
java -jar bob.jar --variant release -p js-web -bo ./.ci/bundle/html bundle 

#pushd .
# todo: dynamic naming, full paths

timestamp=$(date "+%Y%m%d_%H%M")
zipname="as_2015_2016Q4-"
zipname="$zipname$timestamp.zip"
zip -X -x *.zip -x *.ps1 -x *.sh -r $zipname *

zipurl="https://localhost:9877/bbcswebdav/institution/ThemeFiles/"
zipurl="$zipurl$zipname"

curl -X PUT -u "administrator:password" --data-binary @$zipname $zipurl --insecure

. ./setURI.sh
APIKEY="Apikey:c94048220527a3d038db5c19e1156c08"
ACTION=testcases
JSON=./json/testcases/createTestCase.json
http POST $URI$ACTION $APIKEY  < $JSON
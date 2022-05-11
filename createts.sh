#!/bin/bash


echo
echo
echo "Step1: Create Truststore" 
echo
keytool -genkey -alias temp -keystore truststore.jks -storepass demosdemos

echo
echo
echo 'Step2: Delete temporary keystore temp'
echo
keytool -delete -alias temp -keystore truststore.jks

echo
echo
echo 'Step3: Generate Certificate' 
echo
openssl req -new > ndv.server.cert.csr

echo
echo
echo 'Step4: Generate Private Key'
echo
openssl rsa -in privkey.pem -out ndv.server.cert.key

echo
echo 'Step5: Generate self signed certificate'
echo
openssl x509 -in ndv.server.cert.csr -out ndv.server.cert.crt -req -signkey ndv.server.cert.key -days 365

echo
echo
echo 'Import Certificate into Trust Store' 
keytool -import -alias mycert1 -file ndv.server.cert.crt -keystore truststore.p12 -storetype PKCS12 

echo
echo 'It is important that the name of the generated certificate is ndv.server.cert.crt' 
echo 'and that the name of the generated private key is ndv.server.cert.key.'
echo
echo 'please copy ndv.server.* files to the Natural/bin folder'



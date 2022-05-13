#!/bin/bash

echo
echo 'This script is used to create a self signed certificate and trust store'
echo 'Note: Ensure that you have access to keytool and openssl'
echo
echo 'There are 6 steps in the script'
echo "Step1: Create Truststore"
echo 'Step2: Delete temporary keystore temp'
echo 'Step3: Generate Certificate Signing Request'
echo 'Step4: Generate Private Key'
echo 'Step5: Generate self signed certificate'
echo 'Step6: Import Certificate into Trust Store'
echo
echo 'Continue (y/n)'

while true
do
    read -r -p 'Do you want to continue? ' choice
    case "$choice" in
      n|N) exit;;
      y|Y) break;;
      *) echo 'Response not valid';;
    esac
done

echo
echo "Step1: Create Truststore with alias temp" 
echo
echo keytool -genkey -alias temp -keystore truststore.jks -storepass $tspasswd
echo
read -p 'Enter to continue' coninue
echo
echo 'Please enter a password for the Trust Store' 
read -r tspasswd
if [ "$tspasswd" = "" ];
then
    echo "Please enter a Trust Store Password"
    exit
fi

keytool -genkey -alias temp -keystore truststore.jks -storepass $tspasswd 
echo
echo
echo 'Step2: Delete temporary keystore temp'
echo keytool -delete -alias temp -keystore -storepass 'tspasswd' truststore.jks  
read -p 'Enter continue' coninue
echo
keytool -delete -alias temp -storepass $tspasswd  -keystore truststore.jks

echo
echo
echo 'Step3: Generate Certificate Signing Request' 
echo 'openssl req -new > ndv.server.cert.csr'
echo
read -p 'Enter to continue'  
echo
openssl req -new > ndv.server.cert.csr

echo
echo
echo 'Step4: Generate Private RSA Key'
echo 'openssl rsa -in privkey.pem -out ndv.server.cert.key'
echo
read -p 'Enter to continue'
echo

openssl rsa -in privkey.pem -out ndv.server.cert.key

echo
echo 'Step5: Generate self signed certificate'
echo openssl x509 -in ndv.server.cert.csr -out ndv.server.cert.crt -req -signkey ndv.server.cert.key -days 365
echo
read -p 'Enter to continue' 
echo
openssl x509 -in ndv.server.cert.csr -out ndv.server.cert.crt -req -signkey ndv.server.cert.key -days 365

echo
echo
echo 'Step6: Import Certificate into Trust Store' 
echo keytool -import -alias ndvcert -file ndv.server.cert.crt -keystore truststore.p12 -storetype PKCS12
echo
read -p 'Enter to continue'
echo


keytool -import -alias ndvcert -file ndv.server.cert.crt -keystore truststore.p12 -storetype PKCS12 

echo
echo 'It is important that the name of the generated certificate is ndv.server.cert.crt' 
echo 'and that the name of the generated private key is ndv.server.cert.key.'
echo
echo 'Please copy ndv.server.* files to the Natural/bin folder'



#!/bin/sh

registryUrl=registry.dev
rootCertificateAuthority=devCA
Green='\033[1;32m'
Nc='\033[0m'

mkdir ssl

echo "1. Generate dev root private key '${rootCertificateAuthority}.key'"
openssl genrsa -out ./ssl/${rootCertificateAuthority}.key 2048

echo "2. Generate dev root certificate '${rootCertificateAuthority}.crt'"
openssl req \
   -x509 \
   -new \
   -key ./ssl/${rootCertificateAuthority}.key \
   -days 8897 \
   -subj "/C=UA/ST=Ukraine/L=Vinnytsia/O=DevOrganization/OU=DevUnit/CN=dev/emailAddress=dev@email.com" \
   -out ./ssl/${rootCertificateAuthority}.crt

echo "View dev root certificate: 'openssl x509 -noout -text -in ./ssl/${rootCertificateAuthority}.crt'"

echo
echo "(if '/usr/share/ca-certificates/${rootCertificateAuthority}.crt' exists, delete it manually: 'sudo rm /usr/share/ca-certificates/${rootCertificateAuthority}.crt')"
echo "3. Manually copy root dev certificate to OS: '${Green}sudo cp ./ssl/${rootCertificateAuthority}.crt /usr/share/ca-certificates/${Nc}'"
echo "4. Manually add root dev certificate to OS: '${Green}sudo dpkg-reconfigure ca-certificates' and press space on ${rootCertificateAuthority}.crt${Nc}'"
echo "5. Manually update OS certificates: '${Green}sudo update-ca-certificates${Nc}'"
echo "6. Manually add dns record '127.0.0.1 ${registryUrl}': '${Green}sudo gedit /etc/hosts${Nc}'"
echo "(if something goes wrong, try to edit in text editor: 'sudo gedit /etc/ca-certificates.conf')"
echo
#sudo rm /usr/share/ca-certificates/${rootCertificateAuthority}.crt
#sudo cp ./ssl/${rootCertificateAuthority}.crt /usr/share/ca-certificates/
#sudo dpkg-reconfigure ca-certificates
#sudo update-ca-certificates
#sudo gedit /etc/hosts

echo "7. Generate registry private key '${registryUrl}.key' for https://${registryUrl}"
openssl genrsa -out ./ssl/${registryUrl}.key 2048

echo "8. Generate registry signing request './ssl/${registryUrl}.csr' for https://${registryUrl}"
openssl req \
   -new \
   -key ./ssl/${registryUrl}.key \
   -subj "/C=UA/ST=Ukraine/L=Vinnytsia/O=DevOrganization/OU=RegistryUnit/CN=${registryUrl}/emailAddress=registry@email.com" \
   -out ./ssl/${registryUrl}.csr

echo "View signing request: 'openssl req -noout -text -verify -in ./ssl/${registryUrl}.csr'"

echo "9. Create registry certificate '${registryUrl}.crt' for https://${registryUrl}"
openssl x509 \
   -req \
   -in ./ssl/${registryUrl}.csr \
   -CA ./ssl/${rootCertificateAuthority}.crt \
   -CAkey ./ssl/${rootCertificateAuthority}.key \
   -CAcreateserial \
   -days 5000 \
   -out ./ssl/${registryUrl}.crt

echo "   File ./ssl/${rootCertificateAuthority}.srl contain ids of all signed certificates.
   If you need to sign another certificate with same root dev certificate ./ssl/${rootCertificateAuthority}.crt 
   specify argument '-CAserial ./ssl/${rootCertificateAuthority}.srl \'"

echo "View registry certificate: 'openssl x509 -noout -text -in ./ssl/${registryUrl}.crt'"
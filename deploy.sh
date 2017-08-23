#!/bin/bash
echo "hello"
# sudo cat /opt/poc1/Dockerfile /opt/poc2/Dockerfile >>/opt/final/Dockerfile1
# sudo cat /opt/jenkins/Dockerfile /opt/junit/Dockerfile >>/opt/final/Dockerfile2

files="/opt/base/Dockerfile"
files1= ""
echo "hello2"
softwares=($(grep -oP '(?<=toolname>)[^<]+' "/opt/Script/config.xml"))

for i in ${!softwares[*]}
do
  echo "$i" "${softwares[$i]}"
  # instead of echo use the values to send emails, etc
  file2="/opt/"${softwares[$i]}"/Dockerfile"
  echo $file2/opt/final/Dockerfile1
 # files+= "$files /opt/"${softwares[$i]}"/Dockerfile"
 files1="$files1 $file2"
 echo "now print the string after current iteration"
 echo file is : $files1
done
echo "after loop"
echo final value "$files $files1"
cd /opt/final
echo "before creating file"
file4=/opt/final/Dockerfile
sudo touch $file4
echo "after creating file"
sudo chmod 777 $file4
echo "before copy content" 
sudo cat $files $files1 >> $file4
echo "after copy content" 
cd /opt/final
sudo docker build -t test2 .
echo "after build image"
sudo docker run -p 8081:8080 -it test2 /bin/bash
echo "after creating container"

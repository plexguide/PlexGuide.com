#!/bin/bash
. "/usr/bin/variables"

printf "\n\n\n==============================================================\n"

printf "Setup following endpoints in rclone:\n\n"


echo "- Endpoint to your cloud storage."
printf "\t- Create new remote [Press N]\n"
if [ "$(printenv ENCRYPT_MEDIA)" != "0" ]; then
printf "\t- Give it a name example gd\n"
else
printf "\t- Enter Rclone cloud endpoint: $(echo -n $(printenv RCLONE_CLOUD_ENDPOINT) | head -c -1)\n"
fi
printf "\t- Choose Google Drive [Press 7]\n"
printf "\t- If you have a client id paste it here or leave it blank\n"
printf "\t- Choose headless machine [Press N]\n"
printf "\t- Open the url in your browser and enter the verification code\n\n"

if [ "$(printenv ENCRYPT_MEDIA)" != "0" ]; then
echo "- Encryption and decryption for your cloud storage."
printf "\t- Create new remote [Press N]\n"
printf "\t- Enter Rclone cloud endpoint: $(echo -n $(printenv RCLONE_CLOUD_ENDPOINT) | head -c -1)\n"
printf "\t- Choose Encrypt/Decrypt a remote [Press 5]\n"
printf "\t- Enter the name of the remote created in cloud-storage appended  with a colon (:) and the subfolder on your cloud. Example gd:/Media or just gd: if you have your files in root.\n"
printf "\t- Choose how to encrypt filenames. I prefer option 2 Encrypt the filenames\n"
printf "\t- Choose to either generate your own or random password. I prefer to enter my own.\n"
printf "\t- Choose to enter pass phrase for the salt or leave it blank. I prefer to enter my own.\n\n"

echo "- Encryption and decryption for your local storage."
printf "\t- Create new remote [Press N]\n"
printf "\t- Enter Rclone local endpoint: $(echo -n $(printenv RCLONE_LOCAL_ENDPOINT) | head -c -1)\n"
printf "\t- Choose Encrypt/Decrypt a remote [Press 5]\n"
printf "\t- Enter the encrypted folder: ${cloud_encrypt_dir}. If you are using subdirectory append it to it. Example ${cloud_encrypt_dir}/Media\n"
printf "\t- Choose the same filename encrypted as you did with the cloud storage.\n"
printf "\t- Enter the same password as you did with the cloud storage.\n"
printf "\t- Enter the same pass phrase as you did with the cloud storage.\n"
fi

printf "==============================================================\n\n\n"

rclone $rclone_config config

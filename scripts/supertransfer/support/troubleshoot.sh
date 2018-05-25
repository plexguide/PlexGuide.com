####### Troubleshooting steps: ###########################

1. Make sure you have enabled gdrive api access in
   both the dev console and admin security settings.

2. Check if the json keys have "domain wide delegation"

3. Check if the this email is correct:
   [1;35m$gdsaImpersonate[0m
      - if it is incorrect, configure it again with:
        supertransfer --config

4. Remove the offending keys and run:
        supertransfer --purge-rclone

5. Check these logs for detailed debugging:
      - /tmp/SA_error.log

##########################################################

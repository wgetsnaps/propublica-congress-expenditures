#!/bin/sh

TARGET_URL=https://projects.propublica.org/represent/expenditures/

wget "${TARGET_URL}" \
      --adjust-extension \
      --convert-links \
      --include-directories 'represent/expenditures/,congress/assets/,rails/assets/congress/,js/public/assets/' \
      --no-host-directories \
      --page-requisites \
      --recursive --level 1 \
      --span-hosts \
      --output-file /dev/stdout \
  | tee ./wget.log


# get the favicon.ico
curl -O https://projects.propublica.org/favicon.ico

# move index.html out of the subdirectory and then delete the subdirectory
cp represent/expenditures/index.html index.html \
     && rm -r represent/expenditures/

# adjust where the relative links point to
sed -i '' 's@\.\./\.\./@./@g' index.html
# disable ads
sed -i '' 's@<script src="https://connect.facebook.net/en_US/all.js"></script>@<!-- <script src="https://connect.facebook.net/en_US/all.js"></script>-->@' index.html
find js/public/assets/{beacons,google_*}.* -type f | while read -r fname; do
    newfname="$(dirname ${fname})/$(basename ${fname}).bak"
    mv "${fname}" "${newfname}"
done

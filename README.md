
# Mirror of ProPublica's Congress Expenditures data

This is a single page with links to a bunch of large CSV files. This is a nice example of a web-scrape-to-data-crunching workflow, in either Python or plain old Bash+grep.


Mirror page:

https://wgetsnaps.github.io/propublica-congress-expenditures/represent/expenditures.html


Original page:

https://projects.propublica.org/represent/expenditures





## wget used to get the page

~~~sh

# just get the page
wget --recursive --level 1 \
  --adjust-extension \
  --page-requisites \
  --convert-links \
  --no-host-directories \
  --output-file /dev/stdout \
  https://projects.propublica.org/represent/expenditures \
  | tee ./wget.log

mkdir -p datafiles/congress/staffers

# replace S3 path with our own local data dir
sed -i '' 's@https://pp-projects-static.s3.amazonaws.com@datafiles@g' represent/expenditures.html


mkdir -p datafiles/represent/expenditures
cd datafiles/represent/expenditures
# now get the data files
curl -s https://projects.propublica.org/represent/expenditures \
  | ack -o 'https://pp-projects-static.s3.amazonaws.com/congress/staffers/[^"]+' \ 
  | ack 'detail' \
  | xargs -n1 curl -O

~~~

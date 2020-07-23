# README

## Setup

```bash
# cd into directory
bundle install
rake db:setup
rake upload_csv_files
bundle exec rails server # -p 3000

# another terminal same directory
bin/client -y 1891 -t 'Louisville Eclipse','Boston Reds'
 bin/client -y 1988 -t 'Seattle Mariners','New York Mets'
```

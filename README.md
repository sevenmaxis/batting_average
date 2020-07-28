# README

## Setup

```bash
# cd into directory
bundle install
rake db:setup db:seed
bundle exec rails server # -p 3000

# another terminal same directory
bin/client -y 1891 -t 'Louisville Colonels','St. Louis Browns'
bin/client -y 1988 -t 'Seattle Mariners','New York Mets'
```

### Time optimization

Before: 34.88 seconds
After: 24.85 seconds

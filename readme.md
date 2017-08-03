
# who's on the couch?

a quick'n'easy way to import whosonfirst data in to couchdb

### install couch db

```bash
docker run -p 5984:5984 -d couchdb
```

you now have a fancy GUI running at: http://localhost:5984/_utils/

### create an index

```bash
curl -X PUT http://localhost:5984/wof
```

### import all the data

```bash
find '/whosonfirst-data/data' -type f -name '*.geojson' | parallel --no-notice curl -s -XPUT "http://localhost:5984/wof/{/.}" -d "@{}"
```

### import only some of the data (advanced usage)

create a filter file which lists all the placetypes you're interested in (name it `placetype.filter`):

```bash
"wof:placetype":\s*"\(continent\|country\|dependency\|disputed\|macroregion\|region\|macrocounty\|county\|localadmin\|locality\|borough\|macrohood\|neighbourhood\)"
```

and then just add it to the pipeline:

```bash
function placetypeFilter {
  while IFS= read -r FILENAME; do
    grep --files-with-match -f "placetype.filter" "${FILENAME}" || true;
  done
}

find '/whosonfirst-data/data' -type f -name '*.geojson' | placetypeFilter | parallel --no-notice curl -s -XPUT "http://localhost:5984/wof/{/.}" -d "@{}"
```

require! {
  \fs
  \csv-parse
  \csv-stringify
  \through2
  \stream-statistics
}

dist = [0] * 101
pointless = 0

fs.create-read-stream \erogamescape-slim.csv
.pipe csv-parse!
.pipe through2.obj (chunk, encoding, done) ->
  if chunk.0 isnt ''
    @push chunk.0
  done!
.pipe stream-statistics!
.on \data (stat) ->
  for own property of stat
    if property.0 isnt \_
      console.log "#property: #{stat[property]}"

require! {
  \fs
  \csv-parse
  \csv-stringify
  \through2
}

fs.create-read-stream \erogamescape-dump.csv
.pipe csv-parse!
.pipe through2.obj (chunk, encoding, done) ->
  # Skip records with no tokuten 
  if chunk[2] isnt ''
    @push chunk[2, 4]
  done!
.pipe csv-stringify!
.pipe fs.create-write-stream \erogamescape-slim.csv

require! {
  \fs
  \csv-parse
  \csv-stringify
  \through2
}

dist = [0] * 101
pointless = 0

fs.create-read-stream \erogamescape-slim.csv
.pipe csv-parse!
.pipe through2.obj (chunk, encoding, done) ->
  if chunk.0 is ''
    pointless++
  else
    dist[chunk.0]++
  done!
.on \finish ->
  console.log dist
  console.log "Bad sectors: #{pointless}"

require! {
  \fs
  \async
  \csv-parse
  \csv-stringify
  \through2
  \mecab-async
}

mecab = new mecab-async!

reader = fs.create-read-stream \erogamescape-slim.csv
parser = csv-parse!
stringifier = csv-stringify!
writer = fs.create-write-stream \erogamescape-tokenized.csv

reader.pipe parser

total-records = 0

tokenizer = ([point, text], done) ->
  # Eliminate HTML tags
  text .= replace /<.+?>/g ' '

  error, result <- mecab.parse text
  return done error if error

  tokenized-text = result.map (.7) .join ' '

  stringifier.write [point, tokenized-text]

  total-records++
  console.log "Processed #{total-records} records" if total-records % 10 is 0

  done!

queue = async.queue tokenizer, 10

parser.on \data (data) -> queue.push [data]

stringifier.pipe writer

import base64

var filename: string = ""

filename = "payload.bin"
let blob = readFile(filename)

echo encode(blob)

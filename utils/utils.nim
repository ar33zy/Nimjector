import yaml/serialization, streams
import terminal, strutils, strformat

type Technique = object
  name : string
  techniques: seq[string]

proc colored_print(to_print: string, color: ForegroundColor): void = 
  setForegroundColor(color)
  echo to_print

proc get_techniques(file_name: string): seq[Technique] =
  var techniqueList: seq[Technique]
  var s = newFileStream(file_name)
  load(s, techniqueList)
  s.close()

  return techniqueList

proc process_binary(binary: string, technique_list: seq): void = 
  let bin = readFile(binary).replace('\x00', ' ')

  for i in technique_list:
    var 
      count: int = 0
      res: int
  
    colored_print(fmt"[+] Checking API calls used by {i.name}.", fgGreen)
    for api_call in i.techniques:
      if bin.contains(api_call):
        count += 1
        colored_print(fmt"[-] Detected API call: {api_call}", fgYellow)
    res = int((count / len(i.techniques)) * 100)
    if res > 50:
      colored_print(fmt"[!] Potential Injection Technique: {i.name} - {res}%", fgRed)
 

import yaml/serialization, streams
import terminal, strutils, strformat

type Technique = object
  name: string
  api_calls: seq[string]

type ApiCall = object
  api_call: string
  fn_template: string

type Arguments = object
  name: string
  calls: seq[ApiCall]

proc get_techniques(file_name: string): seq[Technique] =
  var techniqueList: seq[Technique]
  var s = newFileStream(file_name)
  load(s, techniqueList)
  s.close()

  return techniqueList

proc custom_arguments(file_name: string): seq[Arguments] = 
  var customArguments: seq[Arguments]
  var s = newFileStream(file_name)
  load(s, customArguments)
  s.close()

  return customArguments

proc get_calls(technique_list: seq[Technique], technique: string): seq[string] = 
  for i in technique_list:
    if i.name == technique:
      return i.api_calls

proc get_argument(argument_list: seq[Arguments], technique: string): seq[ApiCall] = 
  for i in argument_list:
    if i.name == technique:
      return i.calls

proc colored_print(to_print: string, color: ForegroundColor): void = 
  setForegroundColor(color)
  echo to_print

proc indent_lines(lines: string, indent: int): string = 
  var indented = newSeq[string]()
  
  for i in lines.split("\n"):
    indented.add(" ".repeat(indent) & i)
  
  return join(indented, "\n")

proc build_template(technique: string, technique_list: seq): string = 
  let argument_list = custom_arguments("models/custom_arguments.yml")
  
  let calls = get_calls(technique_list, technique)
  let arguments = get_argument(argument_list, technique)
  var payload_template = readFile("templates/base_exe.nim")
  var api_template = newSeq[string]()
  var checker = newSeq[string]()
  var content: string = ""
  
  for call in calls:
    content = ""
    for custom_arg in arguments:
      if custom_arg.api_call == call:
        content = custom_arg.fn_template
        if not checker.contains(content):
          checker.add(content)
          break

    if content == "":      
      content = readFile(fmt"functions/{call}.nim")
    api_template.add(content)

  var compiled_api = join(api_template, "")
  compiled_api = indent_lines(compiled_api, 2)
  
  payload_template = payload_template.replace("REPLACE_TECHNIQUE_NAME", technique)
  payload_template = payload_template.replace("REPLACE_API_CALLS", compiled_api)
  
  return payload_template

# Blue Team Capabilities 

proc process_binary(binary: string, technique_list: seq): void = 
  let bin = readFile(binary).replace('\x00', ' ')

  for i in technique_list:
    var 
      count: int = 0
      res: int
  
    colored_print(fmt"[+] Checking API calls used by {i.name}.", fgGreen)
    for api_call in i.api_calls:
      if bin.contains(api_call):
        count += 1
        colored_print(fmt"[-] Detected API call: {api_call}", fgYellow)
    res = int((count / len(i.api_calls)) * 100)
    if res >= 50:
      colored_print(fmt"[!] Potential Injection Technique: {i.name} - {res}%", fgRed)

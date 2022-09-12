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

type InitSetup = object
  name: string
  setup: seq[string]

type Modules = object
  name: string 
  modules: seq[string]

type NtdllCalls = object
  name: string 
  ntdll: string

proc init_setup(file_name: string): seq[InitSetup] =
  var initSetup: seq[InitSetup]
  var s = newFileStream(file_name)
  load(s, initSetup)
  s.close()

  return initSetup

proc module_setup(file_name: string): seq[Modules] =
  var moduleSetup: seq[Modules]
  var s = newFileStream(file_name)
  load(s, moduleSetup)
  s.close()

  return moduleSetup 

proc ntdll_setup(file_name: string): seq[NtdllCalls] =
  var ntdllSetup: seq[NtdllCalls]
  var s = newFileStream(file_name)
  load(s, ntdllSetup)
  s.close()

  return ntdllSetup

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

proc get_arguments(argument_list: seq[Arguments], technique: string): seq[ApiCall] = 
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

proc get_modules(technique: string, variation: string): string = 
  var modules = newseq[string]()
  modules.add("import base64")
  modules.add("import winim")
  modules.add("import winim/lean")

  if variation == "syscalls":
    modules.add("include syscalls")
    return join(modules, "\n")

  let module_list = module_setup("models/modules.yml")
  for i in module_list:
    if i.name == technique:
      for j in i.modules:
        modules.add(j)

  return join(modules, "\n")

proc k32_to_nt(call: string, ntdll_calls: seq[NtdllCalls]): string = 
  for i in ntdll_calls:
    if i.name == call:
      return i.ntdll
  return ""

 
proc get_init_setup(technique: string, technique_list: seq, variation: string): string = 
  let setup_list = init_setup("models/init_setup.yml")
  let ntdll_calls = ntdll_setup("models/k32_to_nt.yml")
  let calls = get_calls(technique_list, technique)

  var setup_contents: string
  var combined_setup = newSeq[string]()

  for i in setup_list:
    if i.name == technique:
      for j in i.setup:
        setup_contents = readFile(fmt"inits/{j}.nim")
        combined_setup.add(setup_contents)
  
  if variation == "ntdll":
    for i in calls:
      var api_call = k32_to_nt(i, ntdll_calls)
      if api_call != "":
        setup_contents = readFile(fmt"inits/{api_call}.nim")
        combined_setup.add(setup_contents)
  
  return join(combined_setup, "\n")

proc build_template(technique: string, technique_list: seq, variation: string): string = 
  let argument_list = custom_arguments("models/custom_arguments.yml")
  let ntdll_calls = ntdll_setup("models/k32_to_nt.yml")
  let ntdll_variations = @["ntdll", "syscalls", "gstub"]
  
  let calls = get_calls(technique_list, technique)
  let arguments = get_arguments(argument_list, technique)
  var payload_template = readFile("templates/base_exe.nim")
  var api_template = newSeq[string]()
  var checker = newSeq[string]()
  var content: string = ""
  
  for call in calls:
    var api_call = call
    var temp = k32_to_nt(call, ntdll_calls)
    if contains(ntdll_variations, variation) and temp != "":
      api_call = k32_to_nt(call, ntdll_calls)
    
    content = ""
    for custom_arg in arguments:
      if custom_arg.api_call == api_call:
        content = readFile(fmt"custom/{custom_arg.fn_template}.nim")
        if not checker.contains(content):
          checker.add(content)
          break

    if content == "":      
      content = readFile(fmt"functions/{api_call}.nim")
      checker.add(content)
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

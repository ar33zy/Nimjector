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
    modules.add("include utils/syscalls")

  if variation == "gstub":
    modules.add("import osproc")
    modules.add("include utils/GetSyscallStub")
 
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

  if variation == "gstub":
    for i in calls:
      var api_call = k32_to_nt(i, ntdll_calls)
      if api_call != "":
        setup_contents = readFile(fmt"inits/gstub{api_call}.nim")
        combined_setup.add(setup_contents)
  
  return join(combined_setup, "\n")

proc get_gstub_init(calls: seq[string], ntdll_calls: seq[NtdllCalls]): string =
  var gstub_init = newSeq[string]()
  var gstub_call_init = readFile("inits/gstubInit.nim")
  var gstub_call_template = readFile("inits/gstubCall.nim")
  var gstub_offset_template = readFile("inits/gstubOffset.nim")
  var temp_template = ""
  
  gstub_init.add(gstub_call_init) 
  
  var count = 1
  var prev = 0
  for call in calls:
    var temp = k32_to_nt(call, ntdll_calls)
    if temp != "":
      if count != 1:
         temp_template = gstub_offset_template.replace("REPLACE_COUNT", intToStr(count))
         temp_template = temp_template.replace("REPLACE_PREV", intToStr(prev))
         gstub_init.add(temp_template)
         
      temp_template = gstub_call_template.replace("REPLACE_API_CALL", temp)
      temp_template = temp_template.replace("REPLACE_COUNT", intToStr(count))
      gstub_init.add(temp_template)
      
      prev = count
      count += 1

  gstubInit.add("\n")
  return join(gstubInit, "\n")

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

  # Initialize if gstub
  if variation == "gstub":
    var gstub_init = get_gstub_init(calls, ntdll_calls)
    api_template.add(gstub_init)
    
  # Setup API calls
  for call in calls:
    var api_call = call
    var temp = k32_to_nt(call, ntdll_calls)
    if contains(ntdll_variations, variation) and temp != "":
      api_call = temp
    
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

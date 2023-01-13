# Nimjector

A process injection framework written in Nim. The tool heavily aims to teach process injection techniques while providing significant information on how the technique works. In addition, the tool does not only focus on crafting payloads, but also detecting different techniques on suspicious binaries.

## Installation

Install the following packages first before compiling the tool:

```
$ git clone https://github.com/ar33zy/Nimjector.git
$ cd 
# Ensure mingw gcc is installed
$ sudo apt install mingw-w64
# Install nim modules
$ nimble install yaml docopt winim nimcrypto
# Compile the nimjector binary
$ nim c --skipProjCfg -d=release --cc:gcc --embedsrc=on --hints=on --app=console --cpu=amd64 --out=nimjector nimjector.nim
```

## Usage

### List

```bash
# For listing all techniques
$ ./nimjector list -t all

# For printing API calls used by the technique
$ ./nimjector list -t <technique> -c <all>

# Example:
$ ./nimjector list -t set_timer -c VirtualAlloc
[*] Listing API call description - VirtualAlloc
[!] VirtualAlloc is often used by malware to allocate memory as part of process injection. This function returns the memory address of the newly allocated space.
```

### Red

Required fields:
- image
- technique

Optional fields:
- print
- encrypt
- nt (NT API Calls)
- syscalls (System Calls)
- gstub (GetSyscallStub)

```
# For compiling a specific technique
$ ./nimjector red -t <technique_name> -i <shellcode>

# For printing the source code of the technique
$ ./nimjector red -t <technique_name> -i <shellcode> -P

# For applying shellcode encryption
$ ./nimjector red -t <technique_name> -i <shellcode> -e

# For applying call variations 
$ ./nimjector red -t <technique_name> -i <shellcode> [-n | -s | -g]
```

### Blue

```
# For running the checks on a single binary
$ ./nimjector blue -f <binary>
```

## Credits

### Blog Posts
https://www.ired.team/offensive-security/code-injection-process-injection
https://www.elastic.co/blog/ten-process-injection-techniques-technical-survey-common-and-trending-process

### Process Injection Repositories
https://github.com/byt3bl33d3r/OffensiveNim/
https://github.com/snovvcrash/NimHollow
https://github.com/icyguider/Nimcrypt2
https://github.com/pwndizzle/c-sharp-memory-injection
https://github.com/S3lrius/Nimalathatep/
https://github.com/ChaitanyaHaritash/Callback_Shellcode_Injection
https://github.com/sh3d0ww01f/nim_shellloader
https://github.com/aahmad097/AlternativeShellcodeExec
https://github.com/RedTeamOperations/Advanced-Process-Injection-Workshop

### System Calls
https://github.com/S3cur3Th1sSh1t/NimGetSyscallStub
https://github.com/ajpc500/NimlineWhispers2

### Others
https://github.com/S3cur3Th1sSh1t/Creds/tree/daadda8791fd9b45401cef4809953ab4d67b07e9

### API Calls Description
https://malapi.io/

include utils/utils


# For binary checking
let technique_list = get_techniques("models/techniques.yml")
let bin = "test.exe"
process_binary(bin, technique_list)



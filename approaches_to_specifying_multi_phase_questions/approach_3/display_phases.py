
INDENT = "  "
filename = f"gift_card_spec.rb"

with open(filename, 'r') as f:
    cont: str = f.read()


def generate_versions(cont: str) -> list[dict[str, str]]:
    lines: list[str] = cont.splitlines()

    versions: list[dict[str, str]] = []

    for line in lines:
        code, *directives= line.split("# ")

        for unclean_directive in directives:
            directive = unclean_directive.strip()

            command, args = directive.split(" ")

            referenced_versions = args.split(",")
            for ver in referenced_versions:
                
                if "+" in ver:
                    num, indents = ver.split("+")
                else:
                    num, indents = ver, 0
                
                num = int(num)
                indents = int(indents)

                if num + 1 > len(versions):
                    for _ in range(num + 1 - len(versions)):
                        versions.append({   "pre-text"   : "",
                                            "code-line" : "",
                                            "post-text"  : ""  })

                if command not in ("pre-text", "code-line", "post-text"):
                    print(f"found unrecognized directive: {command} {args}")
                else:
                    versions[num][command] += (INDENT * indents) + code + "\n"
    
    return versions
                    
def merge_version(version: dict[str, str]) -> str:
    return version['pre-text'] + version['code-line'] + version['post-text']

versions = generate_versions(cont)

which_version = input(f"Which version would you like to see? [0-2]: ")

print(merge_version(versions[int(which_version)]))
# Security Policy of gem_rbs_collection

## Non-security issues

We treat it as an ordinary problem even if `gems/` directory contains malicious code.
Please report them to the issue tracker or open a pull request.

Our test runner (`bin/test`) does not execute any code written in `gems/` directory. `rbs` command and library also do not execute any code from this repository.
So it does not cause any security issue even if `gems/` directory contains malicious code.

But if an attacker can inject malicious code to `bin/test`, `rbs` command or the library, it would be a security issue. Please report the problem with the following steps.

## Reporting a Vulnerability

Report from https://github.com/ruby/gem_rbs_collection/security/advisories.

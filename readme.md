Repo for testing the QEMU segfault when building under emulation.

The relevant line in the flake is `ERL_FLAGS = "+JPperf=true"`.  Without this
line a build with `nix build .#packages.aarch64-linux.default` fails when it
runs under emulation on an `x86` machine even when a non-emulated build with
`nix build .#` succeeds.  Uncommenting to add the flag causes the build to
succeed in either case.

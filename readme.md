# Midi2Apple2

This program compiles monophonic MIDI files into a 6502 executable that will play on an Apple //e.

The Apple //e has a one-bit audio system. There is a single, "soft switch" memory address (`$C030`) that controls the speaker. To drive the speaker coil once, you read from the address `$C030`. If you wish to produce `400 Hz` tone, you must read from that memory address at `400 Hz`. This is complicated by the fact that the //e lacks any sort of system clock, so all time keeping is accomplished by counting cycles.

`note.asm` contains a subroutine, `note()`, written in assembly, capable of playing one of 62 tones for a specified duration. It contains a "wall of nops" (no-op instruction) followed by `bit $C030` which reads the soft switch and drives the speaker. The duration interval is a 32-bit integer that corresponds to the total number of wavelengths to be played. 6502 processors are 8-bit systems, so interpreting the 32-bit value is held in 4 contiguous memory registers and must be handled appropriately.

There is also an assembly routine, `rest()`, which can be thought of as a cycle-accurate `sleep` function. It similarly takes in a 32-bit duration value that specifies how many times the machine should do nothing for 2000 cycles.

Midi files are processed using a ruby script found in `utils/midi.rb`. `midi.rb` processes the note events, calculates the absolute duration of the note given a specified `bpm`, and then writes to a series of calls to `play_note()` and `play_rest()` to play the song on the //e.


## Installation

`scripts/install` installs the requisite homebrew packages. You can call it directly or via `make`

```
./scripts/install

# or

make install
```

**For MacOS only**

MacOS has a command called `ac`, but the command line version of AppleCommander installed via homebrew aliases itself as `ac`. This script should find and rename the alias of the homebrew installation to `aplc`.

There is no `make` command as it should only be run on MacOS systems.

```
./scripts/rename-ac
```

**Virtual ][**

Virtual ][ is an Apple //e emulator that runs on MacOS.

It requires a ROM image, which must be downloaded and installed
separately.

See https://virtualii.com/VirtualIIHelp/virtual_II_help.html#ROMImage

**Online Emulator**

If you're not on MacOS, you can try using **[this web-based emulator](https://www.scullinsteel.com/apple/e)**

## Uninstall

`scripts/uninstall` uninstalls the homebrew packages (and deletes the renamed symlink if it exists). You can call it directly or via `make`

```
./scripts/uninstall

# or

make uninstall
```

## Make Commands

```

# Compile to 6502
make target

# Generate wav file (For casette data transfer protocol to a physical Apple ][)
make wav

# Generate aif file (For audio transfer protocol to Virtual ][)
make aif

# Generate dsk file (For )
make disk

# Do all of the above
make all
```
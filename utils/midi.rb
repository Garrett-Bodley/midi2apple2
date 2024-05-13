require 'midilib'
require 'pathname'
require 'pry-nav'
require 'midilib/io/seqreader'

raise ArgumentError, 'Usage: midi <path-to-midi-file> <BPM>' if ARGV.length != 2
raise ArgumentError, 'Error: invalid filepath provided' unless File.exist?(ARGV.first)
raise ArgumentError, 'Error: BPM must be a non-zero integer' unless ARGV.last.match?(/[0-9]+/)
raise ArgumentError, 'Error: BPM must be a non-zero integer' if ARGV.last.to_i.zero?

midi_path = ARGV.first
BPM = ARGV.last.to_i

# C2 is 36 in midi

MIDI_OFFSET = 36
# BPM = 30
PPQ = 480
MidiError = Class.new(StandardError)

WD_PATH = Pathname.new(__dir__).dirname

FREQUENCIES = %w[
  65 69 73 77 82
  87 92 97 103 110
  116 123 130 138 146
  155 164 174 184 195
  207 220 233 246 261
  277 293 311 329 349
  369 391 415 440 466
  493 523 554 587 622
  659 698 739 783 830
  880 932 987 1046 1108
  1174 1244 1318 1396 1479
  1567 1661 1760 1864 1975
  2093
].map(&:to_i).freeze

# CALCULATE SECONDS PER TICK

def abs_time_in_milliseconds(tick_count)
  tick_count * 60_000 / (BPM * PPQ)
end

# Function to convert ticks to seconds
def ticks_to_seconds(ticks, ticks_per_beat, tempo)
  (ticks.to_f / ticks_per_beat) * (tempo / 1000000.0)
end

# Array to store note durations and numbers
notes = []

seq = MIDI::Sequence.new

# Open the MIDI file
File.open(midi_path, 'rb') do |file|
  seq.read(file)  # Read the file into the sequence
end

# assuming there's one meta track and one note track
# if you send me a midi file that doesn't follow these rules, you suck

note_tracks = seq.tracks.select do |track|
  track.events.any? { |e| e.is_a?(MIDI::NoteOn) || e.is_a?(MIDI::NoteOff) }
end

raise MidiError, 'Found more than one note track' if note_tracks.length > 1

note_track = note_tracks.first
if note_track.events.filter { |e| e.is_a?(MIDI::NoteOn) }.count != note_track.events.filter { |e| e.is_a?(MIDI::NoteOff) }.count
  raise MidiError, 'Hanging note on/off event found'
end

notes = []
note_track.events.filter { |e| e.is_a?(MIDI::NoteOff) }.each do |e|
  unless e.on.delta_time.zero?
    # generate a rest and do stuff
    notes << [-1, abs_time_in_milliseconds(e.on.delta_time)]
  end
  e.delta_time
  notes << [e.on.note - MIDI_OFFSET, abs_time_in_milliseconds(e.delta_time)]
end

song_path = WD_PATH.join('src/song.c')
song_file = File.open(song_path, 'w+')
song_content = <<~SONG
  #include <stdint.h>

  extern void play_note(uint8_t note_num, uint16_t duration);
  extern void play_rest(uint16_t duration);

  void song(){
  #{
    notes.map do |note|
      if note.first.negative?
        raise StandardError if note[1] * 1023 / 2000 > 65535
        "  play_rest(#{note[1] * 1023 / 2000});"
      else
        "  play_note(#{note[0]}, #{note[1] * FREQUENCIES[note[0]] / 1000});"
      end
    end.join("\n")
  }
  }
SONG

song_file.puts song_content
song_file.flush

# rest = 2000 cycles
# 2000 * 1000/1,023,000 * n = duration in milliseconds
# 2000/1,023 * n =  duration in milliseconds
# n =  duration in milliseconds * 1,023 / 2000

# duration in milliseconds
#
# n * frequency(Hz)

# notes = [note_num, abs_time_in_milliseconds]

# how many milliseconds for 1 period of this frequency
# 1000/(frequency) = milliseconds per wavelength

# 1000/frequency * n = notes[1]
# n = notes[1] * frequency / 1000

# How many half-periods should I play this note?

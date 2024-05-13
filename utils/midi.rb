require 'midilib'
require 'pry-nav'
require 'midilib/io/seqreader'

# Function to convert ticks to seconds
def ticks_to_seconds(ticks, ticks_per_beat, tempo)
  (ticks.to_f / ticks_per_beat) * (tempo / 1000000.0)
end

# Array to store note durations and numbers
notes = []

seq = MIDI::Sequence.new()

# Open the MIDI file
File.open('midi/noname.mid', 'rb') do |file|
  seq.read(file)  # Read the file into the sequence
end

# Initialize default tempo (120 BPM)
default_tempo = 500000  # Microseconds per beat
# binding.pry
seq.each do |track|
  puts "*** Track Name: \"#{track.name}\""
  puts "Instrument Name: \"#{track.instrument}\""
  puts "#{track.events.length} events"

  track.each do |event|
    binding.pry
    # Print out event information in a more readable format
    if event.is_a?(MIDI::NoteOn) && event.velocity > 0
      puts "Note On: #{event.note}, Note Name: #{MIDI.note_name(event.note)}, Velocity: #{event.velocity}, Time: #{event.time_from_start}"
    elsif event.is_a?(MIDI::NoteOff) || (event.is_a?(MIDI::NoteOn) && event.velocity == 0)
      puts "Note Off: #{event.note}, Note Name: #{MIDI.note_name(event.note)}, Time: #{event.time_from_start}"
    end
  end
end

# binding.pry

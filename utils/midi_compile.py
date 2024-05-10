#!/usr/bin/env python3
from mido import MidiFile


BPM = 200


def time_to_sec(time):
    return time * 60. / BPM / 1920.


mid = MidiFile('../midi/noname.mid', clip=True)

notes = []
curr_note = None
for msg in mid.tracks[1]:
    if msg.type not in ('note_on', 'note_off'):
        continue
    if msg.type == 'note_on':
        assert curr_note is None
        if msg.time != 0:
            notes.append({
                "note": "REST",
                "duration": time_to_sec(msg.time),
            })
        note = {
            "note": msg.note,
        }
    if msg.type == 'note_off':
        note['duration'] = time_to_sec(msg.time)
        notes.append(note)
        note = None
print(notes)

with open('still_dre.nop', 'w') as f:
    for note in notes:
        f.write(f'{note["note"]}|{note["duration"]}\n')

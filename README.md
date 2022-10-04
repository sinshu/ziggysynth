# ZiggySynth

ZiggySynth is a SoundFont MIDI synthesizer written in pure Rust, ported from [MeltySynth for C#](https://github.com/sinshu/meltysynth).



## Demo

https://www.youtube.com/watch?v=yOosrF4rnFs

[![Youtube video](https://img.youtube.com/vi/yOosrF4rnFs/0.jpg)](https://www.youtube.com/watch?v=yOosrF4rnFs)



## Examples

An example code to synthesize a simple chord:

```zig
// Load the SoundFont.
var sf2 = try fs.cwd().openFile("TimGM6mb.sf2", .{});
defer sf2.close();
var sound_font = try SoundFont.init(allocator, sf2.reader());
defer sound_font.deinit();

// /Create the synthesizer.
var settings = SynthesizerSettings.init(44100);
var synthesizer = try Synthesizer.init(allocator, sound_font, settings);
defer synthesizer.deinit();

// Play some notes (middle C, E, G).
synthesizer.noteOn(0, 60, 100);
synthesizer.noteOn(0, 64, 100);
synthesizer.noteOn(0, 67, 100);

// The output buffer (3 seconds).
const sample_count = @intCast(usize, 3 * settings.sample_rate);
var left: []f32 = try allocator.alloc(f32, sample_count);
defer allocator.free(left);
var right: []f32 = try allocator.alloc(f32, sample_count);
defer allocator.free(right);

// Render the waveform.
synthesizer.render(left, right);
```

Another example code to synthesize a MIDI file:

```zig
// Load the SoundFont.
var sf2 = try fs.cwd().openFile("TimGM6mb.sf2", .{});
defer sf2.close();
var sound_font = try SoundFont.init(allocator, sf2.reader());
defer sound_font.deinit();

// Create the synthesizer.
var settings = SynthesizerSettings.init(44100);
var synthesizer = try Synthesizer.init(allocator, sound_font, settings);
defer synthesizer.deinit();

// Load the MIDI file.
var mid = try fs.cwd().openFile("flourish.mid", .{});
defer mid.close();
var midi_file = try MidiFile.init(allocator, mid.reader());
defer midi_file.deinit();

// Create the sequencer.
var sequencer = try MidiFileSequencer.init(allocator, synthesizer);
defer sequencer.deinit();

// Play the MIDI file.
sequencer.play(midi_file, false);

// The output buffer.
const sample_count = @floatToInt(usize, @intToFloat(f64, settings.sample_rate) * midi_file.getLength());
var left: []f32 = try allocator.alloc(f32, sample_count);
defer allocator.free(left);
var right: []f32 = try allocator.alloc(f32, sample_count);
defer allocator.free(right);

// Render the waveform.
sequencer.render(left, right);
```



## Performance

Below is a comparison of the time it took to render a MIDI file in several languages. The MIDI file is [flourish.mid](https://midis.fandom.com/wiki/Flourish) (90 seconds) and the SoundFont used is [TimGM6mb.sf2](https://musescore.org/en/handbook/3/soundfonts-and-sfz-files#gm_soundfonts).

![Zig is the fastest!](media/20221004_rendering_time.png)



## Todo

* __Wave synthesis__
    - [x] SoundFont reader
    - [x] Waveform generator
    - [x] Envelope generator
    - [x] Low-pass filter
    - [x] Vibrato LFO
    - [x] Modulation LFO
* __MIDI message processing__
    - [x] Note on/off
    - [x] Bank selection
    - [x] Modulation
    - [x] Volume control
    - [x] Pan
    - [x] Expression
    - [x] Hold pedal
    - [x] Program change
    - [x] Pitch bend
    - [x] Tuning
* __Effects__
    - [ ] Reverb
    - [ ] Chorus
* __Other things__
    - [x] Standard MIDI file support
    - [ ] Loop extension support
    - [x] Performace optimization



## License

ZiggySynth is available under [the MIT license](LICENSE.txt).

const std = @import("std");
const debug = std.debug;
const ziggysynth = @import("ziggysynth.zig");
const SoundFont = ziggysynth.SoundFont;
const PresetRegion = ziggysynth.PresetRegion;

fn areEqual(x: f64, y: f64) bool {
    if (@floor(x) == @ceil(x) and @floor(y) == @ceil(y)) {
        return x == y;
    }

    const m = if (@abs(x) > @abs(y)) @abs(x) else @abs(y);
    const limit = m / 1000.0;
    const delta = @abs(x - y);

    return delta < limit;
}

fn check(region: *const PresetRegion, values: *const [39]f64) void {
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getModulationLfoToPitch())), values[0]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getVibratoLfoToPitch())), values[1]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getModulationEnvelopeToPitch())), values[2]));
    debug.assert(areEqual(region.getInitialFilterCutoffFrequency(), values[3]));
    debug.assert(areEqual(region.getInitialFilterQ(), values[4]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getModulationLfoToFilterCutoffFrequency())), values[5]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getModulationEnvelopeToFilterCutoffFrequency())), values[6]));
    debug.assert(areEqual(region.getModulationLfoToVolume(), values[7]));
    debug.assert(areEqual(region.getChorusEffectsSend(), values[8]));
    debug.assert(areEqual(region.getReverbEffectsSend(), values[9]));
    debug.assert(areEqual(region.getPan(), values[10]));
    debug.assert(areEqual(region.getDelayModulationLfo(), values[11]));
    debug.assert(areEqual(region.getFrequencyModulationLfo(), values[12]));
    debug.assert(areEqual(region.getDelayVibratoLfo(), values[13]));
    debug.assert(areEqual(region.getFrequencyVibratoLfo(), values[14]));
    debug.assert(areEqual(region.getDelayModulationEnvelope(), values[15]));
    debug.assert(areEqual(region.getAttackModulationEnvelope(), values[16]));
    debug.assert(areEqual(region.getHoldModulationEnvelope(), values[17]));
    debug.assert(areEqual(region.getDecayModulationEnvelope(), values[18]));
    debug.assert(areEqual(region.getSustainModulationEnvelope(), values[19]));
    debug.assert(areEqual(region.getReleaseModulationEnvelope(), values[20]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyNumberToModulationEnvelopeHold())), values[21]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyNumberToModulationEnvelopeDecay())), values[22]));
    debug.assert(areEqual(region.getDelayVolumeEnvelope(), values[23]));
    debug.assert(areEqual(region.getAttackVolumeEnvelope(), values[24]));
    debug.assert(areEqual(region.getHoldVolumeEnvelope(), values[25]));
    debug.assert(areEqual(region.getDecayVolumeEnvelope(), values[26]));
    debug.assert(areEqual(region.getSustainVolumeEnvelope(), values[27]));
    debug.assert(areEqual(region.getReleaseVolumeEnvelope(), values[28]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyNumberToVolumeEnvelopeHold())), values[29]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyNumberToVolumeEnvelopeDecay())), values[30]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyRangeStart())), values[31]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getKeyRangeEnd())), values[32]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getVelocityRangeStart())), values[33]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getVelocityRangeEnd())), values[34]));
    debug.assert(areEqual(region.getInitialAttenuation(), values[35]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getCoarseTune())), values[36]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getFineTune())), values[37]));
    debug.assert(areEqual(@as(f64, @floatFromInt(region.getScaleTuning())), values[38]));
}

test "MuseScore Preset" {
    var da = std.heap.DebugAllocator(.{}){};
    const allocator = da.allocator();
    defer debug.assert(da.deinit() == .ok);

    var file = try std.fs.cwd().openFile("GeneralUser GS MuseScore v1.442.sf2", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    var reader = file.reader(&buf);
    var sf = try SoundFont.init(allocator, &reader.interface);
    defer sf.deinit();

    // ============================================================
    //  Muted Trumpet
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 96, 0, 127, 6, 0, 0, 0 };
        check(&sf.presets[0].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 0.7002, -100, 1, 0, 0, 1, 1, 1, 1, -96, 1, 0, 0, 97, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[0].regions[1], &values);
    }

    // ============================================================
    //  Trombone
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2, 0, 0, 0, 127, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[1].regions[0], &values);
    }

    // ============================================================
    //  Trumpet
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 127, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[2].regions[0], &values);
    }

    // ============================================================
    //  Standard 3
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[3].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[3].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[3].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[3].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[3].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[3].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 1, 0, 0 };
        check(&sf.presets[3].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[3].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[3].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[3].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[3].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[3].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[3].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[3].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[3].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[3].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[3].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[3].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[3].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[3].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[3].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[3].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[3].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[3].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[3].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[3].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[3].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[3].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[3].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[3].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[3].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[3].regions[42], &values);
    }

    // ============================================================
    //  Bagpipes
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[4].regions[0], &values);
    }

    // ============================================================
    //  Coupled Harpsichord
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, -6000, 0, 0, 7, -10, 100.02, 0.60991, 1, 0.60991, 0.0099978, 1, 0.0099978, 1, 0, 2, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 34, 0, 105, 0, 127, 25, 0, 1, 0 };
        check(&sf.presets[5].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 14.998, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 90, 127, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 21.996, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 83, 89, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 66, 74, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 59, 65, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 48, 58, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 47, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 75, 82, 0, 127, 13.5, 0, 0, 0 };
        check(&sf.presets[5].regions[7], &values);
    }

    // ============================================================
    //  Harpsichord
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, -6000, 0, 0, 7, -10, 100.02, 0.60991, 1, 0.60991, 0.0099978, 1, 0.0099978, 1, 0, 2, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 34, 0, 105, 0, 127, 10.5, 0, 4, 0 };
        check(&sf.presets[6].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 14.998, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 90, 127, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 21.996, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 83, 89, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 66, 74, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 59, 65, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 48, 58, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.5, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 47, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 10, 1, 1, 1, 1, 0.0099978, 0.40007, 1, 1, 0, 29.995, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 75, 82, 0, 127, -1, 0, 0, 0 };
        check(&sf.presets[6].regions[7], &values);
    }

    // ============================================================
    //  SFX Kit
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[7].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 6, 50, 0 };
        check(&sf.presets[7].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[7].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 3, 50, 0 };
        check(&sf.presets[7].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 53, 0, 127, 0, 3, 50, 0 };
        check(&sf.presets[7].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 54, 0, 127, 0, 2, 0, 0 };
        check(&sf.presets[7].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 55, 55, 0, 127, 0, 1, 0, 0 };
        check(&sf.presets[7].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 56, 57, 0, 127, -7.1, 0, 50, 0 };
        check(&sf.presets[7].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 58, 58, 0, 127, 10, -2, 50, -40 };
        check(&sf.presets[7].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 58, 58, 0, 127, 10, 2, 50, -40 };
        check(&sf.presets[7].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 59, 59, 0, 127, 12, 0, 25, 0 };
        check(&sf.presets[7].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 60, 60, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[7].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 62, 62, 0, 127, 15, -1, 12, 0 };
        check(&sf.presets[7].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 63, 63, 0, 127, 12, -1, 0, 0 };
        check(&sf.presets[7].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 64, 64, 0, 127, 4, -2, 0, 0 };
        check(&sf.presets[7].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 65, 65, 0, 127, 0, -2, -50, 0 };
        check(&sf.presets[7].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.64992, 0, 0, 67, 67, 0, 127, 10, -3, -50, 0 };
        check(&sf.presets[7].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 68, 68, 0, 127, 25, -5, -25, 0 };
        check(&sf.presets[7].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 69, 69, 0, 127, 10, -9, 0, 0 };
        check(&sf.presets[7].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.5004, 0, 0, 70, 70, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[7].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 71, 71, 0, 127, 10, -5, -50, 0 };
        check(&sf.presets[7].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 72, 72, 0, 127, 0, -8, 0, 0 };
        check(&sf.presets[7].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 73, 73, 0, 127, 6, -6, -50, 0 };
        check(&sf.presets[7].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 1300, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 10, 8, 40, 0 };
        check(&sf.presets[7].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 7200, 0, 0, 3, 12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 0, -8, 40, 0 };
        check(&sf.presets[7].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 5464, 0, 0, 3, -12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 0, -10, 40, 0 };
        check(&sf.presets[7].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 75, 75, 0, 127, 20, -1, 0, 0 };
        check(&sf.presets[7].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 75, 75, 0, 127, 20, -1, -50, 0 };
        check(&sf.presets[7].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 127, 0, -8, 0, 0 };
        check(&sf.presets[7].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0.0099978, 4.9991, 1, 1, 0, 3.0001, 0, 0, 77, 77, 0, 127, 15, -3, 0, 0 };
        check(&sf.presets[7].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 78, 78, 0, 127, 35, -6, 0, 0 };
        check(&sf.presets[7].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 78, 78, 0, 127, 35, -4, 0, 0 };
        check(&sf.presets[7].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 79, 79, 0, 127, 10, -11, 0, 0 };
        check(&sf.presets[7].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 79, 79, 0, 127, 10, -6, 0, 0 };
        check(&sf.presets[7].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 250, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 80, 80, 0, 127, 0, -10, 50, 0 };
        check(&sf.presets[7].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 81, 81, 0, 127, 10, -21, 0, 0 };
        check(&sf.presets[7].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 82, 82, 0, 127, 0, -11, 0, 0 };
        check(&sf.presets[7].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 83, 83, 0, 127, 20, -12, -50, 0 };
        check(&sf.presets[7].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 83, 83, 0, 127, 20, -10, -50, 0 };
        check(&sf.presets[7].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 84, 84, 0, 127, 5, -12, 0, 0 };
        check(&sf.presets[7].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 61, 61, 0, 127, 7.5, -1, -50, 0 };
        check(&sf.presets[7].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 66, 66, 0, 127, 0, -3, 0, 0 };
        check(&sf.presets[7].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 12, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[7].regions[42], &values);
    }

    // ============================================================
    //  Orchestral Perc.
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 88, 88, 0, 127, 5, -14, 0, 0 };
        check(&sf.presets[8].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 53, 0, 107, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 41, 53, 108, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[8].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[8].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[8].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[8].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[8].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[8].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[8].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[8].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[8].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[8].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 15, 0, 50, 0 };
        check(&sf.presets[8].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 11, 0, 50, 0 };
        check(&sf.presets[8].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[8].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 15, -5, 0, 0 };
        check(&sf.presets[8].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 11, -5, 0, 0 };
        check(&sf.presets[8].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 7, -26.2, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[8].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 37, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 31, 34, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 17.7, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 59, 59, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[8].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 7, -51.8, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -2, 0, 0 };
        check(&sf.presets[8].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[8].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, -29.1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[8].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -2, 0, 0, 0 };
        check(&sf.presets[8].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 25.6, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 39, 39, 0, 127, 3, 9, -50, 0 };
        check(&sf.presets[8].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 38, 38, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 40, 40, 0, 127, 0, -2, 38, 0 };
        check(&sf.presets[8].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[8].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[8].regions[38], &values);
    }

    // ============================================================
    //  Brush Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[9].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[9].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[9].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[9].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[9].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[9].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[9].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[9].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[9].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[9].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[9].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[9].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[9].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[9].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[9].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[9].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[9].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[9].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[9].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[9].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[9].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[9].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[9].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[9].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[9].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[9].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[9].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[9].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, -5, 0, 0 };
        check(&sf.presets[9].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[9].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 109, 127, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 86, 108, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2.4102, 1, 1, 0, 1, 0, 0, 0, 127, 0, 85, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[9].regions[43], &values);
    }

    // ============================================================
    //  Jazz Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[10].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[10].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[10].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[10].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[10].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[10].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[10].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[10].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[10].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[10].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[10].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[10].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[10].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[10].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[10].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[10].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[10].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[10].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[10].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[10].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[10].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[10].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[10].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[10].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[10].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[10].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[10].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[10].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[10].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[10].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[10].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[10].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[10].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, -5, 0, 0 };
        check(&sf.presets[10].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[10].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[10].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -1, 0, 0 };
        check(&sf.presets[10].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.2998, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[10].regions[43], &values);
    }

    // ============================================================
    //  Dance Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[11].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[11].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[11].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[11].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[11].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[11].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[11].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[11].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[11].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[11].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[11].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[11].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[11].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[11].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[11].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[11].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[11].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[11].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[11].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[11].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[11].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 44, 0, 127, 41.9, 1, 0, 0 };
        check(&sf.presets[11].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[11].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 50, 50, 0, 127, 0, 14, 0, 0 };
        check(&sf.presets[11].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 17, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 48, 48, 0, 127, 0, 12, 0, 0 };
        check(&sf.presets[11].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 9, 0, 0 };
        check(&sf.presets[11].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 45, 45, 0, 127, 0, 7, 0, 0 };
        check(&sf.presets[11].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -18, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 43, 43, 0, 127, 0, 5, 0, 0 };
        check(&sf.presets[11].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 41, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[11].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[11].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 0.7002, 1, 1, 0, 100.02, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[11].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 46, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0.0099978, 0.15003, 0, 0.15003, 0, 0, 46, 46, 0, 127, 41.9, 15, 0, 0 };
        check(&sf.presets[11].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[11].regions[49], &values);
    }

    // ============================================================
    //  808/909 Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 1, 0, 0 };
        check(&sf.presets[12].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[12].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[12].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[12].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[12].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[12].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[12].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[12].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[12].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[12].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[12].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[12].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[12].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 15, 0, 50, 0 };
        check(&sf.presets[12].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 11, 0, 50, 0 };
        check(&sf.presets[12].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[12].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[12].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[12].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[12].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[12].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 15, -5, 0, 0 };
        check(&sf.presets[12].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 11, -5, 0, 0 };
        check(&sf.presets[12].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[12].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 61, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 54, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 65, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[30], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -25, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 41, 41, 0, 127, 7, -2, 0, 0 };
        check(&sf.presets[12].regions[31], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -15, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 43, 43, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[12].regions[32], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -5, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 45, 45, 0, 127, 7, 2, 0, 0 };
        check(&sf.presets[12].regions[33], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 5, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 47, 47, 0, 127, 7, 4, 0, 0 };
        check(&sf.presets[12].regions[34], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 15, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 48, 48, 0, 127, 7, 6, 0, 0 };
        check(&sf.presets[12].regions[35], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 25, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 50, 50, 0, 127, 7, 8, 0, 0 };
        check(&sf.presets[12].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[12].regions[39], &values);
    }

    // ============================================================
    //  Electronic Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[13].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[13].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[13].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[13].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[13].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[13].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[13].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[13].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[13].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[13].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[13].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[13].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[13].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[13].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[13].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[13].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[13].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[13].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[13].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[13].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[13].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 44, 0, 127, 41.9, 1, 0, 0 };
        check(&sf.presets[13].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[13].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[13].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 50, 50, 0, 127, 0, 14, 0, 0 };
        check(&sf.presets[13].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 17, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 48, 48, 0, 127, 0, 12, 0, 0 };
        check(&sf.presets[13].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 9, 0, 0 };
        check(&sf.presets[13].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 45, 45, 0, 127, 0, 7, 0, 0 };
        check(&sf.presets[13].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -18, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 43, 43, 0, 127, 0, 5, 0, 0 };
        check(&sf.presets[13].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 41, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[13].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[13].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 0.7002, 1, 1, 0, 100.02, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[13].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 46, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0.0099978, 0.15003, 0, 0.15003, 0, 0, 46, 46, 0, 127, 41.9, 15, 0, 0 };
        check(&sf.presets[13].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[13].regions[48], &values);
    }

    // ============================================================
    //  Power Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -1, 0, 0 };
        check(&sf.presets[14].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -1, 0, 0 };
        check(&sf.presets[14].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[14].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[14].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[14].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[14].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 5, 0, 0, 0 };
        check(&sf.presets[14].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 95, 111, 5, 0, 0, 0 };
        check(&sf.presets[14].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 74, 94, 5, 0, 0, 0 };
        check(&sf.presets[14].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 73, 5, 0, 0, 0 };
        check(&sf.presets[14].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -1, 0, 0 };
        check(&sf.presets[14].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[14].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[14].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[14].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[14].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[14].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[14].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[14].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[14].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[14].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[14].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[14].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[14].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[14].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[14].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[14].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[14].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, -1, -72, 0 };
        check(&sf.presets[14].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[14].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[14].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[14].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[14].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 20, 0, 0, 0 };
        check(&sf.presets[14].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 20, 0, 0, 0 };
        check(&sf.presets[14].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 20, 0, 0, 0 };
        check(&sf.presets[14].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 20, 0, 0, 0 };
        check(&sf.presets[14].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 20, 0, 0, 0 };
        check(&sf.presets[14].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[14].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 4, 1, 0, 0 };
        check(&sf.presets[14].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[14].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -2, 0, 0 };
        check(&sf.presets[14].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 5617, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.039991, 100, 0.039991, 0, 0, 1, 1, 1, 3.0001, 96, 3.0001, 0, 0, 0, 127, 111, 127, 0, 0, 0, 0 };
        check(&sf.presets[14].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 96, 2, 0, 0, 0, 127, 95, 110, -3, 0, 0, 0 };
        check(&sf.presets[14].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1, 0, 0, 0, 127, 79, 94, -6, 0, 0, 0 };
        check(&sf.presets[14].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 96, 0.80014, 0, 0, 0, 127, 64, 78, -9, 0, 0, 0 };
        check(&sf.presets[14].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 96, 0.60012, 0, 0, 0, 127, 0, 63, -12, 0, 0, 0 };
        check(&sf.presets[14].regions[50], &values);
    }

    // ============================================================
    //  Room Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[15].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[15].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[15].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[15].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[15].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[15].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -6, 0, 0 };
        check(&sf.presets[15].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[15].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[15].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[15].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[15].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[15].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[15].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[15].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[15].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[15].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[15].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[15].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[15].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[15].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[15].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[15].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, -1, 0, 0 };
        check(&sf.presets[15].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[15].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[15].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[15].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[15].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[15].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[15].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[15].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 5, 0, 0, 0 };
        check(&sf.presets[15].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 95, 111, 5, 0, 0, 0 };
        check(&sf.presets[15].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 74, 94, 5, 0, 0, 0 };
        check(&sf.presets[15].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 0, 73, 5, 0, 0, 0 };
        check(&sf.presets[15].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 20, 0, 0, 0 };
        check(&sf.presets[15].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 20, 0, 0, 0 };
        check(&sf.presets[15].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 20, 0, 0, 0 };
        check(&sf.presets[15].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 20, 0, 0, 0 };
        check(&sf.presets[15].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 20, 0, 0, 0 };
        check(&sf.presets[15].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 1, 83, 0 };
        check(&sf.presets[15].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[15].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[15].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[15].regions[47], &values);
    }

    // ============================================================
    //  Standard 2 Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[16].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[16].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[16].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[16].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[16].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[16].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[16].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[16].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[16].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[16].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[16].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[16].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[16].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[16].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[16].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[16].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[16].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[16].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[16].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[16].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[16].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[16].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[16].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[16].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[16].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[16].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[16].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[16].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[16].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[16].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[16].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[16].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[16].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[16].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 5617, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 0.039991, 100, 0.039991, 0, 0, 1, 1, 1, 3.0001, 96, 3.0001, 0, 0, 0, 127, 111, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 96, 2, 0, 0, 0, 127, 95, 110, -3, 0, 0, 0 };
        check(&sf.presets[16].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1, 0, 0, 0, 127, 79, 94, -6, 0, 0, 0 };
        check(&sf.presets[16].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 96, 0.80014, 0, 0, 0, 127, 64, 78, -9, 0, 0, 0 };
        check(&sf.presets[16].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 96, 0.60012, 0, 0, 0, 127, 0, 63, -12, 0, 0, 0 };
        check(&sf.presets[16].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 11, 0, 0, 0 };
        check(&sf.presets[16].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[16].regions[46], &values);
    }

    // ============================================================
    //  Standard Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[17].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[17].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[17].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[17].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[17].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[17].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 1, 0, 0 };
        check(&sf.presets[17].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[17].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[17].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[17].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[17].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[17].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[17].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[17].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[17].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[17].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[17].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[17].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[17].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[17].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[17].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[17].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[17].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[17].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[17].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[17].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[17].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[17].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[17].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[17].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[17].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[17].regions[42], &values);
    }

    // ============================================================
    //  808/909
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 1, 0, 0 };
        check(&sf.presets[18].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[18].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[18].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[18].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[18].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[18].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[18].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[18].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[18].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[18].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[18].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[18].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[18].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 15, 0, 50, 0 };
        check(&sf.presets[18].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 11, 0, 50, 0 };
        check(&sf.presets[18].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[18].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[18].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[18].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[18].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[18].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 15, -5, 0, 0 };
        check(&sf.presets[18].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 11, -5, 0, 0 };
        check(&sf.presets[18].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[18].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 61, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 54, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 65, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[30], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -25, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 41, 41, 0, 127, 7, -2, 0, 0 };
        check(&sf.presets[18].regions[31], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -15, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 43, 43, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[18].regions[32], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -5, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 45, 45, 0, 127, 7, 2, 0, 0 };
        check(&sf.presets[18].regions[33], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 5, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 47, 47, 0, 127, 7, 4, 0, 0 };
        check(&sf.presets[18].regions[34], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 15, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 48, 48, 0, 127, 7, 6, 0, 0 };
        check(&sf.presets[18].regions[35], &values);
    }
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, 25, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 50, 50, 0, 127, 7, 8, 0, 0 };
        check(&sf.presets[18].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[18].regions[39], &values);
    }

    // ============================================================
    //  Fantasia
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 117, 127, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 106, 116, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 93, 105, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 79, 92, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 67, 78, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 38, 66, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 54, 74, 0, 37, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 75, 127, 106, 127, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 75, 127, 85, 104, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 75, 127, 61, 84, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 75, 127, 34, 60, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 75, 127, 0, 33, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 117, 127, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 106, 116, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 93, 105, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 79, 92, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 67, 78, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 38, 66, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 14, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 1.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 1.5, 0, 0, 0, 53, 0, 37, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 5, 0, 0, 0, 5, 50, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 72, 108, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[19].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 15, 0, 0, 0, 5, 50, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.059989, 1, 1, 0, 1, 0, 0, 0, 71, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[19].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 1500, 0, 7, 21, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.069992, 9.9982, 25.005, 96, 39.993, 0, 0, 0, 35, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[19].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1500, 0, 7, 21, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.069992, 9.9982, 25.005, 96, 39.993, 0, 0, 36, 53, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[19].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.64992, 0, 0, 1500, 0, 7, 21, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.069992, 9.9982, 25.005, 96, 39.993, 0, 0, 54, 72, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[19].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1500, 0, 7, 21, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.069992, 9.9982, 25.005, 96, 39.993, 0, 0, 73, 90, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[19].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1500, 0, 7, 21, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.069992, 9.9982, 25.005, 96, 39.993, 0, 0, 91, 108, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[19].regions[25], &values);
    }

    // ============================================================
    //  Taiko Drum
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 108, 127, 0, 0, 0, 0 };
        check(&sf.presets[20].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 95, 107, 0, 0, 0, 0 };
        check(&sf.presets[20].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 81, 94, 0, 0, 0, 0 };
        check(&sf.presets[20].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 67, 80, 0, 0, 0, 0 };
        check(&sf.presets[20].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 66, 0, 0, 0, 0 };
        check(&sf.presets[20].regions[4], &values);
    }

    // ============================================================
    //  Concert Choir
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.33007, 1, 1, 0, 0.80014, 0, 0, 0, 127, 113, 127, 3, 0, 10, 0 };
        check(&sf.presets[21].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.90021, 1, 1, 0, 1, 0, 0, 0, 127, 94, 112, 3, 0, 10, 0 };
        check(&sf.presets[21].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.8004, 1, 1, 0, 1.2002, 0, 0, 0, 127, 72, 93, 3, 0, 10, 0 };
        check(&sf.presets[21].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1.4004, 0, 0, 0, 127, 0, 71, 3, 0, 10, 0 };
        check(&sf.presets[21].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 20, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.33007, 1, 1, 0, 0.80014, 0, 0, 0, 127, 113, 127, 13, 0, 10, 0 };
        check(&sf.presets[21].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 20, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.7002, 1, 1, 0, 1, 0, 0, 0, 127, 94, 112, 13, 0, 10, 0 };
        check(&sf.presets[21].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 20, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.2002, 1, 1, 0, 1.2002, 0, 0, 0, 127, 72, 93, 13, 0, 10, 0 };
        check(&sf.presets[21].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 20, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1.4004, 0, 0, 0, 127, 0, 71, 13, 0, 10, 0 };
        check(&sf.presets[21].regions[7], &values);
    }

    // ============================================================
    //  Brass Section
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 800, 0, 5, 7, 15, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 5, 0 };
        check(&sf.presets[22].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 800, 0, 5, 7, -20, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 5, 0 };
        check(&sf.presets[22].regions[1], &values);
    }

    // ============================================================
    //  Music Box
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 1, 0, 17, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[23].regions[0], &values);
    }

    // ============================================================
    //  Bell Piano
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 0, 0, 7, 0 };
        check(&sf.presets[24].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 5, 0, 7, 0 };
        check(&sf.presets[24].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 9, 0, 7, 0 };
        check(&sf.presets[24].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 14, 0, 7, 0 };
        check(&sf.presets[24].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 18, 0, 7, 0 };
        check(&sf.presets[24].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 23, 0, 7, 0 };
        check(&sf.presets[24].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 27, 0, 7, 0 };
        check(&sf.presets[24].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 32, 0, 7, 0 };
        check(&sf.presets[24].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 36, 0, 7, 0 };
        check(&sf.presets[24].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 41, 0, 7, 0 };
        check(&sf.presets[24].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 0, 35, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 0, 35, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 0, 35, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 0, 35, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 0, 35, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 0, 35, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 0, 35, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 0, 35, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 36, 50, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 36, 50, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 36, 50, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 36, 50, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 36, 50, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 36, 50, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 36, 50, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 36, 50, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 51, 65, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 51, 65, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 51, 65, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 51, 65, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 51, 65, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 51, 65, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 51, 65, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 51, 65, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 66, 80, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 66, 80, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 66, 80, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 66, 80, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 66, 80, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 66, 80, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 66, 80, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 66, 80, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 3, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 81, 87, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 81, 87, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 1, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 81, 87, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 81, 87, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 81, 87, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 81, 87, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 81, 87, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 81, 87, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 4, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[24].regions[50], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[24].regions[51], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 1.2, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[24].regions[52], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[24].regions[53], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[24].regions[54], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[24].regions[55], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[24].regions[56], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[24].regions[57], &values);
    }

    // ============================================================
    //  Bell Tine EP
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 0, 0, 7, 0 };
        check(&sf.presets[25].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 5, 0, 7, 0 };
        check(&sf.presets[25].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 9, 0, 7, 0 };
        check(&sf.presets[25].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 14, 0, 7, 0 };
        check(&sf.presets[25].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 18, 0, 7, 0 };
        check(&sf.presets[25].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 23, 0, 7, 0 };
        check(&sf.presets[25].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 27, 0, 7, 0 };
        check(&sf.presets[25].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 32, 0, 7, 0 };
        check(&sf.presets[25].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 36, 0, 7, 0 };
        check(&sf.presets[25].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 41, 0, 7, 0 };
        check(&sf.presets[25].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 67, 10, 0, -23, 0 };
        check(&sf.presets[25].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 68, 105, 10, 0, -23, 0 };
        check(&sf.presets[25].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 10, 0, -23, 0 };
        check(&sf.presets[25].regions[12], &values);
    }

    // ============================================================
    //  Tine & FM EPs
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 0, 0, 7, 0 };
        check(&sf.presets[26].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 5, 0, 7, 0 };
        check(&sf.presets[26].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 9, 0, 7, 0 };
        check(&sf.presets[26].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 14, 0, 7, 0 };
        check(&sf.presets[26].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 18, 0, 7, 0 };
        check(&sf.presets[26].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 23, 0, 7, 0 };
        check(&sf.presets[26].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 27, 0, 7, 0 };
        check(&sf.presets[26].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 32, 0, 7, 0 };
        check(&sf.presets[26].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 36, 0, 7, 0 };
        check(&sf.presets[26].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 41, 0, 7, 0 };
        check(&sf.presets[26].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[26].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[26].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[26].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[26].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[26].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[26].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[26].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 106, 127, -4, 0, 0, 0 };
        check(&sf.presets[26].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 85, 104, -6, 0, 0, 0 };
        check(&sf.presets[26].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 61, 84, -8, 0, 0, 0 };
        check(&sf.presets[26].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 34, 60, -10, 0, 0, 0 };
        check(&sf.presets[26].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 0, 33, -12, 0, 0, 0 };
        check(&sf.presets[26].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[26].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[26].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[26].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[26].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[26].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[26].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[26].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 67, 10, 0, -30, 0 };
        check(&sf.presets[26].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 68, 105, 10, 0, -30, 0 };
        check(&sf.presets[26].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 15, 7, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 10, 0, -30, 0 };
        check(&sf.presets[26].regions[31], &values);
    }

    // ============================================================
    //  Piano & FM EP
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 0, 0, 7, 0 };
        check(&sf.presets[27].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 5, 0, 7, 0 };
        check(&sf.presets[27].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 9, 0, 7, 0 };
        check(&sf.presets[27].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 14, 0, 7, 0 };
        check(&sf.presets[27].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 18, 0, 7, 0 };
        check(&sf.presets[27].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 23, 0, 7, 0 };
        check(&sf.presets[27].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 27, 0, 7, 0 };
        check(&sf.presets[27].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 32, 0, 7, 0 };
        check(&sf.presets[27].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 36, 0, 7, 0 };
        check(&sf.presets[27].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 41, 0, 7, 0 };
        check(&sf.presets[27].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[27].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[27].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 106, 127, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 85, 104, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 61, 84, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 34, 60, -10, 0, 0, 0 };
        check(&sf.presets[27].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 0, 33, -12, 0, 0, 0 };
        check(&sf.presets[27].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[27].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[27].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 0, 35, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 0, 35, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 0, 35, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 0, 35, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 0, 35, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 0, 35, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 0, 35, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 0, 35, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 36, 50, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 36, 50, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 36, 50, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 36, 50, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 36, 50, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 36, 50, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 36, 50, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 36, 50, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 51, 65, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 51, 65, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 51, 65, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 51, 65, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 51, 65, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 51, 65, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[50], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 51, 65, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[51], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 51, 65, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[52], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 2, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 66, 80, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[53], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 1, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 66, 80, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[54], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 66, 80, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[55], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 66, 80, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[56], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 66, 80, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[57], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 66, 80, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[58], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 66, 80, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[59], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 66, 80, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[60], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 3, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 81, 87, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[61], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.66014, 0, 0, 81, 87, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[62], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 1, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.67987, 0, 0, 81, 87, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[63], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.7002, 0, 0, 81, 87, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[64], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.71988, 0, 0, 81, 87, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[65], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.74012, 0, 0, 81, 87, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[66], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.76005, 0, 0, 81, 87, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[67], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.79004, 0, 0, 81, 87, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[68], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 4, 0, 600, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 4, 80, 0.5, 0, 68, 0.0099978, 1, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[27].regions[69], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 750, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.7996, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[27].regions[70], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 1.2, 0, 1200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.5004, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[27].regions[71], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 3.0001, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[27].regions[72], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[27].regions[73], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[27].regions[74], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[27].regions[75], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 15, 7, 0, 0.0099978, 0.60991, 0.0099978, 0.60991, 0.0099978, 0.0099978, 0.0099978, 2.4995, 80, 0.5, 0, 68, 0.0099978, 0.0099978, 1, 1.65, 96, 0.64992, 0, 0, 88, 127, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[27].regions[76], &values);
    }

    // ============================================================
    //  Woodwind Choir
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 90, 127, 0, 127, 3, 0, 7, 0 };
        check(&sf.presets[28].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1, 0, 0, 64, 94, 75, 127, 3, 0, 0, 0 };
        check(&sf.presets[28].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 64, 94, 54, 74, 3, 0, 0, 0 };
        check(&sf.presets[28].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.0005, 1, 1, 0, 1, 0, 0, 64, 94, 0, 53, 3, 0, 0, 0 };
        check(&sf.presets[28].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 53, 73, 94, 127, 15, 0, 0, 0 };
        check(&sf.presets[28].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 53, 73, 77, 93, 15, 0, 0, 0 };
        check(&sf.presets[28].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.0007, 1, 1, 0, 1, 0, 0, 53, 73, 59, 76, 15, 0, 0, 0 };
        check(&sf.presets[28].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 10.998, 1, 1, 0, 1, 0, 0, 53, 73, 0, 58, 15, 0, 0, 0 };
        check(&sf.presets[28].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 63, 0, 127, 7, 0, -3, 0 };
        check(&sf.presets[28].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 9.9982, 2, 0.5, 0, 0, 74, 89, 0, 127, 0, 0, 5, 0 };
        check(&sf.presets[28].regions[9], &values);
    }

    // ============================================================
    //  Full Orchestra
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.55994, 1, 1, 0, 0.90021, 0, 0, 0, 127, 0, 51, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.46009, 1, 1, 0, 0.81979, 0, 0, 0, 127, 52, 65, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.37006, 1, 1, 0, 0.77022, 0, 0, 0, 127, 66, 78, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.26996, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.17997, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.089985, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 5, 0, -3, 0 };
        check(&sf.presets[29].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 90, 101, 0, 127, 3, 0, 7, 0 };
        check(&sf.presets[29].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1, 0, 0, 64, 94, 75, 98, 3, 0, 0, 0 };
        check(&sf.presets[29].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 64, 94, 54, 74, 3, 0, 0, 0 };
        check(&sf.presets[29].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.0005, 1, 1, 0, 1, 0, 0, 64, 94, 0, 53, 3, 0, 0, 0 };
        check(&sf.presets[29].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 54, 73, 94, 98, 10, 0, 0, 0 };
        check(&sf.presets[29].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 54, 73, 77, 93, 10, 0, 0, 0 };
        check(&sf.presets[29].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.0007, 1, 1, 0, 1, 0, 0, 54, 73, 59, 76, 10, 0, 0, 0 };
        check(&sf.presets[29].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 21, 25, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 10.998, 1, 1, 0, 1, 0, 0, 54, 73, 0, 58, 10, 0, 0, 0 };
        check(&sf.presets[29].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 1, 0, 0, 0, 0, 0, 21, -25, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 63, 0, 98, 7, 0, -3, 0 };
        check(&sf.presets[29].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 9.9982, 2, 0.5, 0, 0, 74, 89, 0, 98, 0, 0, 5, 0 };
        check(&sf.presets[29].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 53, 0, 98, 3, 0, 5, 0 };
        check(&sf.presets[29].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 21, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 60, 81, 109, 127, 7, 0, 3, 0 };
        check(&sf.presets[29].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -600, 0, 0, 21, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 60, 81, 99, 108, 7, 0, 3, 0 };
        check(&sf.presets[29].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 21, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 0.089985, 1, 1, 0, 1, 0, 0, 82, 94, 109, 127, 0, 0, 3, 0 };
        check(&sf.presets[29].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 0, 0, 0, 21, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -40, 1, 0, 0, 1, 0.10002, 1, 1, 0, 1, 0, 0, 82, 94, 99, 108, 0, 0, 3, 0 };
        check(&sf.presets[29].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 7200, 0, 0, 21, -25, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 0.0099978, 9.9982, 77.3, 2, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 67, 107, 127, 7, 0, -5, 0 };
        check(&sf.presets[29].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 2706, 0, 0, 21, -25, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 100, 2, 0, 0, 0.0099978, 0.15003, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 67, 99, 106, 7, 0, -5, 0 };
        check(&sf.presets[29].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 0.7002, 0, 0, 0, 0, 0, 21, -25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 1, -20, 53.199, 0, 0, 1, 1, 1, 1, 0, 2, 0, 0, 68, 94, 99, 127, 12, 0, -3, 0 };
        check(&sf.presets[29].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 25, 1, 0.60012, 1, 1.1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 59, 99, 127, 15, 0, 5, 0 };
        check(&sf.presets[29].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -3, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 51, 99, 127, -7, 0, 0, 0 };
        check(&sf.presets[29].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 51, 99, 127, 0, 0, 0, 0 };
        check(&sf.presets[29].regions[27], &values);
    }

    // ============================================================
    //  Brass Section 3
    // ============================================================
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 60, 81, 109, 127, 7, 0, 3, 0 };
        check(&sf.presets[30].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -600, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 60, 81, 89, 108, 7, 0, 3, 0 };
        check(&sf.presets[30].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 60, 81, 68, 88, 7, 0, 3, 0 };
        check(&sf.presets[30].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -2000, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -20, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 60, 81, 0, 67, 7, 0, 3, 0 };
        check(&sf.presets[30].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 0.089985, 1, 1, 0, 1, 0, 0, 82, 127, 109, 127, 0, 0, 3, 0 };
        check(&sf.presets[30].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 0, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -40, 1, 0, 0, 1, 0.10002, 1, 1, 0, 1, 0, 0, 82, 127, 89, 108, 0, 0, 3, 0 };
        check(&sf.presets[30].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 0.7002, 0, 0, -500, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -50, 1, 0, 0, 1, 0.30006, 1, 1, 0, 1, 0, 0, 82, 127, 68, 88, 0, 0, 3, 0 };
        check(&sf.presets[30].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 14, 25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -50, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 82, 127, 0, 67, 0, 0, 3, 0 };
        check(&sf.presets[30].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 7200, 0, 0, 14, -25, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 0.0099978, 9.9982, 77.3, 2, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 67, 107, 127, 7, 0, -5, 0 };
        check(&sf.presets[30].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 2706, 0, 0, 14, -25, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 100, 2, 0, 0, 0.0099978, 0.15003, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 67, 82, 106, 7, 0, -5, 0 };
        check(&sf.presets[30].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.029994, 0, 0, 2706, 0, 0, 14, -25, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 61.7, 2, 0, 0, 0.0099978, 0.30006, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 67, 0, 81, 7, 0, -5, 0 };
        check(&sf.presets[30].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 781, 0, 0, 14, 0, 1, 0.5, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 2, 15, 0, 0, 0 };
        check(&sf.presets[30].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 0.7002, 0, 0, 0, 0, 0, 14, -25, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 1, -20, 53.199, 0, 0, 1, 1, 1, 1, 0, 2, 0, 0, 68, 127, 0, 127, 12, 0, -3, 0 };
        check(&sf.presets[30].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 25, 1, 0.60012, 1, 1.1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 59, 0, 127, 15, 0, 5, 0 };
        check(&sf.presets[30].regions[13], &values);
    }

    // ============================================================
    //  Piano & Str.-Sus
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 0, 35, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 0, 35, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 0, 35, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 0, 35, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 0, 35, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 0, 35, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 0, 35, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 0, 35, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 36, 50, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 36, 50, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 36, 50, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 36, 50, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 36, 50, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 36, 50, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 36, 50, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 36, 50, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 51, 65, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 51, 65, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 51, 65, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 51, 65, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 51, 65, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 51, 65, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 51, 65, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 51, 65, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 66, 80, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 66, 80, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 66, 80, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 66, 80, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 66, 80, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 66, 80, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 66, 80, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 66, 80, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 3, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 81, 87, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 81, 87, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 1, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 81, 87, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 81, 87, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 81, 87, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 81, 87, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 81, 87, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 81, 87, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 4, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[31].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[31].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 1.2, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[31].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[31].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[31].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[31].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[31].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[31].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.55994, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 0, 39, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.47991, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 40, 57, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.40007, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 58, 72, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[50], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.31993, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 73, 89, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[51], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.23995, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 90, 107, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[52], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.15997, 0.0099978, 1, 0, 1.5, 0, 0, 0, 127, 108, 127, 32, 0, -3, 0 };
        check(&sf.presets[31].regions[53], &values);
    }

    // ============================================================
    //  Piano & Str.-Fade
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 0, 35, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 0, 35, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 0, 35, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 0, 35, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 0, 35, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 0, 35, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 0, 35, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 0, 35, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 36, 50, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 36, 50, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 36, 50, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 36, 50, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 36, 50, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 36, 50, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 36, 50, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 36, 50, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 51, 65, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 51, 65, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 51, 65, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 51, 65, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 51, 65, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 51, 65, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 51, 65, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 51, 65, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 2, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 66, 80, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 1, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 66, 80, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 66, 80, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 66, 80, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 66, 80, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 66, 80, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 66, 80, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 66, 80, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 3, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 81, 87, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 81, 87, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 1, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 81, 87, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 81, 87, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 81, 87, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 81, 87, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 81, 87, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 81, 87, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 4, 0, 600, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[32].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 750, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[32].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 1.2, 0, 1200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[32].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[32].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[32].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[32].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[32].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 21, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[32].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.55994, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 0, 39, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.47991, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 40, 57, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.40007, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 58, 72, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[50], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.31993, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 73, 89, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[51], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.23995, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 90, 107, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[52], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.15997, 0.0099978, 2, 100, 1.5, 0, 0, 0, 127, 108, 127, 32, 0, -3, 0 };
        check(&sf.presets[32].regions[53], &values);
    }

    // ============================================================
    //  Synth Bass 4
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 2000, 0, 3.5, 0, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 1, 1, 0.5, 0, 0.30006, 0, 0, 0, 127, 0, 127, 3, 12, 0, 0 };
        check(&sf.presets[33].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.059989, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 74, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[33].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80991, 5, 0, 1685, 0, 3.5, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.60012, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 12.07, 96, 2, 0, 0, 75, 108, 0, 127, 8, 0, 0, 0 };
        check(&sf.presets[33].regions[2], &values);
    }

    // ============================================================
    //  Brass Section 2
    // ============================================================
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 60, 81, 109, 127, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -600, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 60, 81, 89, 108, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 60, 81, 68, 88, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -2000, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -20, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 60, 81, 0, 67, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 0.089985, 1, 1, 0, 1, 0, 0, 82, 127, 109, 127, 0, 0, 0, 0 };
        check(&sf.presets[34].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 0, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -40, 1, 0, 0, 1, 0.10002, 1, 1, 0, 1, 0, 0, 82, 127, 89, 108, 0, 0, 0, 0 };
        check(&sf.presets[34].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 0.7002, 0, 0, -500, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -50, 1, 0, 0, 1, 0.30006, 1, 1, 0, 1, 0, 0, 82, 127, 68, 88, 0, 0, 0, 0 };
        check(&sf.presets[34].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 14, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -50, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 82, 127, 0, 67, 0, 0, 0, 0 };
        check(&sf.presets[34].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 7200, 0, 0, 14, 0, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 0.0099978, 9.9982, 77.3, 2, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 59, 107, 127, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 2706, 0, 0, 14, 0, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 100, 2, 0, 0, 0.0099978, 0.15003, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 59, 82, 106, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.029994, 0, 0, 2706, 0, 0, 14, 0, 0.0099978, 0.60012, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 61.7, 2, 0, 0, 0.0099978, 0.30006, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 59, 0, 81, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 781, 0, 0, 14, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[34].regions[11], &values);
    }

    // ============================================================
    //  Orchestra Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.20998, 1, 1, 0, 0.77022, 0, 0, 0, 127, 0, 51, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.17997, 1, 1, 0, 0.76005, 0, 0, 0, 127, 52, 65, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.13998, 1, 1, 0, 0.75002, 0, 0, 0, 127, 66, 78, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.11002, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.069992, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.039991, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 3, 0, -3, 0 };
        check(&sf.presets[35].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 14, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 5, 0 };
        check(&sf.presets[35].regions[7], &values);
    }

    // ============================================================
    //  Feedback Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 10, 0, 0.25, 0, 0, 7200, 0, 7, 3, 0, 100.02, 0.67012, 0.40007, 0.60991, 1, 1, 1, 3.0001, 0, 2, 0, 0, 1, 1, 1, 4.9991, 0, 2, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[36].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 2, 0, 0, -1000, 0, 7, 3, 0, 100.02, 0.67012, 0.40007, 0.60991, 1, 1, 1, 0.5, -30.5, 100.02, 0, 0, 1, 1, 1, 0.5, 0, 1.2498, 0, 0, 0, 127, 0, 127, 40, 0, -2, 0 };
        check(&sf.presets[36].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 4443, 0, 7, 3, 0, 100.02, 0.5, 0.40007, 0.40007, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 1, 24.001, 0.0099978, 25.005, 96, 0.5, 0, 84, 60, 77, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[36].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 5000, 0, 7, 3, 0, 100.02, 0.5, 0.40007, 0.40007, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 1.5, 16, 0.0099978, 25.005, 96, 0.5, 0, 84, 78, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[36].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 3830, 0, 7, 3, 0, 100.02, 0.5, 0.40007, 0.40007, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.5, 29.995, 0.0099978, 25.005, 96, 0.5, 0, 84, 0, 59, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[36].regions[4], &values);
    }

    // ============================================================
    //  Chorused Clean Gt.
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 0, 59, 6, 0, -7, 0 };
        check(&sf.presets[37].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 14, 7, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 84, 106, 6, 0, -7, 0 };
        check(&sf.presets[37].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 107, 127, 6, 0, -7, 0 };
        check(&sf.presets[37].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 14, 7, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 60, 83, 6, 0, -7, 0 };
        check(&sf.presets[37].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 0, 43, 6, 0, 7, 0 };
        check(&sf.presets[37].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 14, 7, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 72, 98, 6, 0, 7, 0 };
        check(&sf.presets[37].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 99, 127, 6, 0, 7, 0 };
        check(&sf.presets[37].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 14, 7, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 44, 71, 6, 0, 7, 0 };
        check(&sf.presets[37].regions[7], &values);
    }

    // ============================================================
    //  12-String Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 3932, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 113, 127, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.3503, 0, 0, 3750, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 99, 112, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3523, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 86, 98, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 3350, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -10, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 72, 85, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3217, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -20, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 58, 71, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2808, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -30, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 45, 57, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2400, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -40, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 0, 44, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 3932, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 113, 127, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.3503, 0, 0, 3750, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 99, 112, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3523, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 86, 98, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 3350, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 72, 85, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3217, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 58, 71, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2808, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 45, 57, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2400, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.55, 0.55, 0, 1, 0, 0, 1, 0.0099978, 0.64992, 0.64992, 0, 1.2998, 0, 0, 0, 62, 0, 44, 15, 0, 0, 0 };
        check(&sf.presets[38].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 3, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 0.0099978, 0.30006, 0, 1, 0, 0, 29.995, 5.7891, 1.2002, 2, 0, 1.2998, 68, 68, 63, 127, 0, 127, 17, 0, -2, 0 };
        check(&sf.presets[38].regions[14], &values);
    }

    // ============================================================
    //  Detuned Perc. Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 3, -25, 1, 4.9991, 1, 1.2998, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 17, 0, -7, 0 };
        check(&sf.presets[39].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 4.9991, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 8, 0, 0, 0 };
        check(&sf.presets[39].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 3, 25, 1, 4.9991, 1, 1.2998, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 17, 0, 7, 0 };
        check(&sf.presets[39].regions[2], &values);
    }

    // ============================================================
    //  Detuned Tnwl. Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 9.9982, 0, 0, 0, 0, 22, 3, -25, 1, 0.85018, 1, 0.85018, 1, 1, 1, 1, -36, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 25, 0, 7, 0 };
        check(&sf.presets[40].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 9.9982, 0, 0, 0, 0, 22, 3, 25, 1, 0.85018, 1, 0.85018, 1, 1, 1, 1, -36, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 25, 0, -7, 0 };
        check(&sf.presets[40].regions[1], &values);
    }

    // ============================================================
    //  Chorused FM EP
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 3, 0, 7, 0 };
        check(&sf.presets[41].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 8, 0, 7, 0 };
        check(&sf.presets[41].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 12, 0, 7, 0 };
        check(&sf.presets[41].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 17, 0, 7, 0 };
        check(&sf.presets[41].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 21, 0, 7, 0 };
        check(&sf.presets[41].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 26, 0, 7, 0 };
        check(&sf.presets[41].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 30, 0, 7, 0 };
        check(&sf.presets[41].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 35, 0, 7, 0 };
        check(&sf.presets[41].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 39, 0, 7, 0 };
        check(&sf.presets[41].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 42, 7, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 44, 0, 7, 0 };
        check(&sf.presets[41].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 117, 127, 6, 0, -5, 0 };
        check(&sf.presets[41].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 106, 116, 4, 0, -5, 0 };
        check(&sf.presets[41].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 93, 105, 2, 0, -5, 0 };
        check(&sf.presets[41].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 79, 92, 0, 0, -5, 0 };
        check(&sf.presets[41].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 67, 78, -2, 0, -5, 0 };
        check(&sf.presets[41].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 38, 66, -4, 0, -5, 0 };
        check(&sf.presets[41].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 0, 37, -6, 0, -5, 0 };
        check(&sf.presets[41].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 106, 127, 2, 0, -5, 0 };
        check(&sf.presets[41].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 85, 104, 0, 0, -5, 0 };
        check(&sf.presets[41].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 61, 84, -2, 0, -5, 0 };
        check(&sf.presets[41].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 34, 60, -4, 0, -5, 0 };
        check(&sf.presets[41].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 0, 33, -6, 0, -5, 0 };
        check(&sf.presets[41].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 117, 127, 6, 0, -5, 0 };
        check(&sf.presets[41].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 106, 116, 4, 0, -5, 0 };
        check(&sf.presets[41].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 93, 105, 2, 0, -5, 0 };
        check(&sf.presets[41].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 79, 92, 0, 0, -5, 0 };
        check(&sf.presets[41].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 67, 78, -2, 0, -5, 0 };
        check(&sf.presets[41].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 38, 66, -4, 0, -5, 0 };
        check(&sf.presets[41].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 7, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 0, 37, -6, 0, -5, 0 };
        check(&sf.presets[41].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 117, 127, 6, 0, 5, 0 };
        check(&sf.presets[41].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 106, 116, 4, 0, 5, 0 };
        check(&sf.presets[41].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 93, 105, 2, 0, 5, 0 };
        check(&sf.presets[41].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 79, 92, 0, 0, 5, 0 };
        check(&sf.presets[41].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 67, 78, -2, 0, 5, 0 };
        check(&sf.presets[41].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 38, 66, -4, 0, 5, 0 };
        check(&sf.presets[41].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 0, 37, -6, 0, 5, 0 };
        check(&sf.presets[41].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 106, 127, 2, 0, 5, 0 };
        check(&sf.presets[41].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 85, 104, 0, 0, 5, 0 };
        check(&sf.presets[41].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 61, 84, -2, 0, 5, 0 };
        check(&sf.presets[41].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 34, 60, -4, 0, 5, 0 };
        check(&sf.presets[41].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 0, 33, -6, 0, 5, 0 };
        check(&sf.presets[41].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 117, 127, 6, 0, 5, 0 };
        check(&sf.presets[41].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 106, 116, 4, 0, 5, 0 };
        check(&sf.presets[41].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 93, 105, 2, 0, 5, 0 };
        check(&sf.presets[41].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 79, 92, 0, 0, 5, 0 };
        check(&sf.presets[41].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 67, 78, -2, 0, 5, 0 };
        check(&sf.presets[41].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 38, 66, -4, 0, 5, 0 };
        check(&sf.presets[41].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 7, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 0, 37, -6, 0, 5, 0 };
        check(&sf.presets[41].regions[47], &values);
    }

    // ============================================================
    //  Chorused Tine EP
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, -25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 67, 15, 0, -28, 0 };
        check(&sf.presets[42].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, -25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 68, 105, 15, 0, -28, 0 };
        check(&sf.presets[42].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, -25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 15, 0, -28, 0 };
        check(&sf.presets[42].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 67, 15, 0, -18, 0 };
        check(&sf.presets[42].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 68, 105, 15, 0, -18, 0 };
        check(&sf.presets[42].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 25, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 15, 0, -18, 0 };
        check(&sf.presets[42].regions[5], &values);
    }

    // ============================================================
    //  French Horns
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1500, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 4.9991, 0, 1, 0, 0, 1, 1, 1, 12, -24, 1, 0, 0, 0, 127, 119, 127, 12, 0, -5, 0 };
        check(&sf.presets[43].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 4.9991, 0, 1, 0, 0, 1, 1, 1, 12, -24, 1, 0, 0, 0, 127, 105, 118, 12, 0, -5, 0 };
        check(&sf.presets[43].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 4.9991, 0, 1, 0, 0, 1, 1, 1, 12, -24, 1, 0, 0, 0, 127, 90, 104, 12, 0, -5, 0 };
        check(&sf.presets[43].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 8000, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 3.0001, 0, 1, 0, 0, 1, 4, 1, 8, -20, 1, 0, 0, 0, 127, 74, 89, 12, 0, -5, 0 };
        check(&sf.presets[43].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5000, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 0, 1, 9.9982, 1, 8, -20, 1, 0, 0, 0, 127, 57, 73, 10, 0, -5, 0 };
        check(&sf.presets[43].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5000, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 4.9991, 0, 1, 0, 0, 1, 9.9982, 1, 8, -20, 1, 0, 0, 0, 127, 41, 56, 8, 0, -5, 0 };
        check(&sf.presets[43].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5000, 0, 0, 7, -10, 1, 1, 1, 1, 1, 1, 1, 6.0002, 0, 1, 0, 0, 1, 9.9982, 1, 8, -20, 1, 0, 0, 0, 127, 0, 40, 6, 0, -5, 0 };
        check(&sf.presets[43].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 10, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.55, 0, 0, 0, 68, 0, 127, 3, 0, 5, 0 };
        check(&sf.presets[43].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.64992, 0, 0, 0, 0, 0, 7, 10, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.55, 0, 0, 69, 74, 0, 127, 3, 0, 5, 0 };
        check(&sf.presets[43].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 0, 0, 0, 7, 10, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.55, 0, 0, 75, 127, 0, 127, 3, 0, 5, 0 };
        check(&sf.presets[43].regions[9], &values);
    }

    // ============================================================
    //  Solo French Horn
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.7002, 0, 0, 0, 127, 0, 127, 0, 0, 7, 0 };
        check(&sf.presets[44].regions[0], &values);
    }

    // ============================================================
    //  Dance
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[45].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[45].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[45].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[45].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[45].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[45].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[45].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[45].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[45].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[45].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[45].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[45].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[45].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[45].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[45].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[45].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[45].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[45].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[45].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[45].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[45].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 44, 0, 127, 41.9, 1, 0, 0 };
        check(&sf.presets[45].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[45].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 50, 50, 0, 127, 0, 14, 0, 0 };
        check(&sf.presets[45].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 17, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 48, 48, 0, 127, 0, 12, 0, 0 };
        check(&sf.presets[45].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 9, 0, 0 };
        check(&sf.presets[45].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 45, 45, 0, 127, 0, 7, 0, 0 };
        check(&sf.presets[45].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -18, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 43, 43, 0, 127, 0, 5, 0, 0 };
        check(&sf.presets[45].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 41, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[45].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[45].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 0.7002, 1, 1, 0, 100.02, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[45].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 46, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0.0099978, 0.15003, 0, 0.15003, 0, 0, 46, 46, 0, 127, 41.9, 15, 0, 0 };
        check(&sf.presets[45].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[45].regions[49], &values);
    }

    // ============================================================
    //  Alto Sax
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[46].regions[0], &values);
    }

    // ============================================================
    //  Distortion Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 10, 0, 0.25, 0, 0, 7200, 0, 7, 3, 0, 100.02, 0.67012, 0.40007, 0.60991, 1, 1, 1, 6.0002, 0, 2, 0, 0, 1, 1, 1, 9.9982, 0, 2, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[47].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 2, 0, 0, -1000, 0, 7, 3, 0, 100.02, 0.67012, 0.40007, 0.60991, 1, 1, 1, 1, -30.5, 100.02, 0, 0, 1, 1, 1, 2, 0, 1.2498, 0, 0, 0, 127, 0, 127, 40, 0, -2, 0 };
        check(&sf.presets[47].regions[1], &values);
    }

    // ============================================================
    //  Fiddle
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.039991, 1, 1, 0, 1, 0, 0, 0, 100, 102, 127, 0, 0, 0, 0 };
        check(&sf.presets[48].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 100, 77, 101, 0, 0, 0, 0 };
        check(&sf.presets[48].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1, 0, 0, 0, 100, 52, 76, 0, 0, 0, 0 };
        check(&sf.presets[48].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 1, 0, 0, 0, 100, 28, 51, 0, 0, 0, 0 };
        check(&sf.presets[48].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.0007, 1, 1, 0, 1, 0, 0, 0, 100, 0, 27, 0, 0, 0, 0 };
        check(&sf.presets[48].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.4007, 1, 1, 0, 1, 0, 0, 101, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[48].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 100, 109, 127, 10, 0, 0, 0 };
        check(&sf.presets[48].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 0, 100, 91, 108, 20, 0, 0, 0 };
        check(&sf.presets[48].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.9982, 1, 1, 0, 1, 0, 0, 0, 100, 73, 90, 30, 0, 0, 0 };
        check(&sf.presets[48].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 19.996, 1, 1, 0, 1, 0, 0, 0, 100, 53, 72, 40, 0, 0, 0 };
        check(&sf.presets[48].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 29.995, 1, 1, 0, 1, 0, 0, 0, 100, 34, 52, 50, 0, 0, 0 };
        check(&sf.presets[48].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 39.993, 1, 1, 0, 1, 0, 0, 0, 100, 0, 33, 60, 0, 0, 0 };
        check(&sf.presets[48].regions[11], &values);
    }

    // ============================================================
    //  Warm Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 0, 61, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 62, 70, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.6003, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 71, 79, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.8998, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 80, 88, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 89, 97, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.4995, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 98, 106, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.8008, 0, 0, 500, 0, 14, 14, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.8497, 0, 0, 107, 127, 0, 127, 5, 0, -3, 0 };
        check(&sf.presets[49].regions[6], &values);
    }

    // ============================================================
    //  Bass & Lead
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 3, 0, 5566, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 70, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 0, 72, 112, 127, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.35994, 3, 0, 5200, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 70, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 0, 72, 96, 111, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 3, 0, 4900, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 70, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 0, 72, 79, 95, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 3, 0, 4600, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 70, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 0, 72, 62, 78, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 3, 0, 4300, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 70, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 0, 72, 0, 61, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2.7, 0, 5000, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 6.0002, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 73, 127, 109, 127, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2.7, 0, 4250, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 6.0002, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 73, 127, 93, 108, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2.7, 0, 3750, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 6.0002, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 73, 127, 77, 92, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2.7, 0, 3250, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 6.0002, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 73, 127, 57, 76, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2.7, 0, 2750, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 6.0002, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 73, 127, 0, 56, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 3, 0, 5566, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 55, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 73, 96, 112, 127, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.35994, 3, 0, 5200, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 55, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 73, 96, 96, 111, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 3, 0, 4900, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 55, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 73, 96, 79, 95, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 3, 0, 4600, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 55, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 73, 96, 62, 78, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 3, 0, 4300, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 13.478, 55, 100.02, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.0984, -96, 1, 0, 0, 73, 96, 0, 61, 5, 0, 1, 0 };
        check(&sf.presets[50].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.7, 0, 5000, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 9.0005, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 72, 109, 127, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.7, 0, 4250, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 9.0005, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 72, 93, 108, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.7, 0, 3750, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 9.0005, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 72, 77, 92, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.7, 0, 3250, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 9.0005, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 72, 57, 76, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.7, 0, 2750, 0, 14, 3, 0, 100.02, 0.7002, 1, 0.77022, 0.0099978, 0.0099978, 0.0099978, 9.0005, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 72, 0, 56, 30, 0, -3, 0 };
        check(&sf.presets[50].regions[19], &values);
    }

    // ============================================================
    //  Saw Lead
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 20, 5, -10, 1, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0, 127, 0, 127, 37, 0, 4, 0 };
        check(&sf.presets[51].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 20, 5, 10, 1, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0.30006, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0, 127, 0, 127, 37, 0, -4, 0 };
        check(&sf.presets[51].regions[1], &values);
    }

    // ============================================================
    //  Square Lead 3
    // ============================================================
    {
        const values = [_]f64{ 25, 0, 0, 100.02, 0, 0, 0, 0, 7, 5, -10, 4.9703, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0, 127, 0, 127, 33, 0, 4, 0 };
        check(&sf.presets[52].regions[0], &values);
    }
    {
        const values = [_]f64{ 25, 0, 0, 100.02, 0, 0, 0, 0, 7, 5, 10, 6.3901, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0.30006, 0.0099978, 0.0099978, 1, 0, 0.5, 0, 0, 0, 127, 0, 127, 33, 0, -4, 0 };
        check(&sf.presets[52].regions[1], &values);
    }

    // ============================================================
    //  Flute
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 99, 127, 6, 0, 0, 0 };
        check(&sf.presets[53].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1, 0, 0, 0, 127, 75, 98, 6, 0, 0, 0 };
        check(&sf.presets[53].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 54, 74, 6, 0, 0, 0 };
        check(&sf.presets[53].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.0005, 1, 1, 0, 1, 0, 0, 0, 127, 0, 53, 6, 0, 0, 0 };
        check(&sf.presets[53].regions[3], &values);
    }

    // ============================================================
    //  Synth Brass 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 2911, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 13.478, 0.0099978, 7.8083, 19.1, 0.40007, 0, 0, 0.0099978, 1, 2.8497, 5.6798, 12.9, 0.40007, 0, 0, 0, 66, 0, 127, 13, 0, 2, 0 };
        check(&sf.presets[54].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 5, 0, 4115, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 1.4298, 0.0099978, 7.8083, 48.9, 0.40007, 0, 0, 0.0099978, 6.3901, 2.8497, 5.6798, 6.1, 0.40007, 0, 0, 0, 66, 0, 127, 17, 0, -2, 0 };
        check(&sf.presets[54].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 3300, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 13.478, 0.0099978, 7.8083, 19.1, 0.40007, 0, 0, 0.0099978, 1, 2.8497, 5.6798, 12.9, 0.40007, 0, 0, 67, 78, 0, 127, 13, 0, 2, 0 };
        check(&sf.presets[54].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 5, 0, 4700, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 1.4298, 0.0099978, 7.8083, 48.9, 0.40007, 0, 0, 0.0099978, 6.3901, 2.8497, 5.6798, 6.1, 0.40007, 0, 0, 67, 78, 0, 127, 17, 0, -2, 0 };
        check(&sf.presets[54].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 3800, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 13.478, 0.0099978, 7.8083, 19.1, 0.40007, 0, 0, 0.0099978, 1, 2.8497, 5.6798, 12.9, 0.40007, 0, 0, 79, 127, 0, 127, 13, 0, 2, 0 };
        check(&sf.presets[54].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 5, 0, 5100, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 1.4298, 0.0099978, 7.8083, 48.9, 0.40007, 0, 0, 0.0099978, 6.3901, 2.8497, 5.6798, 6.1, 0.40007, 0, 0, 79, 127, 0, 127, 17, 0, -2, 0 };
        check(&sf.presets[54].regions[5], &values);
    }

    // ============================================================
    //  Synth Bass 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.0001, 0, 0, 0, 74, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[55].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 5, 0, 7200, 0, 5, 3, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 12.07, 96, 3.0001, 0, 0, 75, 108, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[55].regions[1], &values);
    }

    // ============================================================
    //  Cello
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 79, 3, 0, 0, 0 };
        check(&sf.presets[56].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 80, 102, 3, 0, 0, 0 };
        check(&sf.presets[56].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 103, 127, 3, 0, 0, 0 };
        check(&sf.presets[56].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 116, 127, 27, 0, 0, 0 };
        check(&sf.presets[56].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 107, 115, 32, 0, 0, 0 };
        check(&sf.presets[56].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 97, 106, 39, 0, 0, 0 };
        check(&sf.presets[56].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 88, 96, 45, 0, 0, 0 };
        check(&sf.presets[56].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 78, 87, 53, 0, 0, 0 };
        check(&sf.presets[56].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 69, 77, 67, 0, 0, 0 };
        check(&sf.presets[56].regions[8], &values);
    }

    // ============================================================
    //  Violin
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.039991, 1, 1, 0, 1, 0, 0, 0, 100, 112, 127, 7, 0, 0, 0 };
        check(&sf.presets[57].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 100, 96, 111, 7, 0, 0, 0 };
        check(&sf.presets[57].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 0, 1, 0, 0, 0, 100, 78, 95, 7, 0, 0, 0 };
        check(&sf.presets[57].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 1, 0, 0, 0, 100, 61, 77, 7, 0, 0, 0 };
        check(&sf.presets[57].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.0007, 1, 1, 0, 1, 0, 0, 0, 100, 0, 60, 7, 0, 0, 0 };
        check(&sf.presets[57].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.4007, 1, 1, 0, 1, 0, 0, 101, 127, 0, 127, 14, 0, 0, 0 };
        check(&sf.presets[57].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 100, 115, 127, 17, 0, 0, 0 };
        check(&sf.presets[57].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 0, 100, 104, 114, 27, 0, 0, 0 };
        check(&sf.presets[57].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.9982, 1, 1, 0, 1, 0, 0, 0, 100, 92, 103, 37, 0, 0, 0 };
        check(&sf.presets[57].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 19.996, 1, 1, 0, 1, 0, 0, 0, 100, 80, 91, 47, 0, 0, 0 };
        check(&sf.presets[57].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 29.995, 1, 1, 0, 1, 0, 0, 0, 100, 68, 79, 57, 0, 0, 0 };
        check(&sf.presets[57].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 13, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 39.993, 1, 1, 0, 1, 0, 0, 0, 100, 56, 67, 67, 0, 0, 0 };
        check(&sf.presets[57].regions[11], &values);
    }

    // ============================================================
    //  Synth Bass 1
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.97999, 4.8, 0, 6000, 0, 7, 0, -15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 113, 127, 23, 0, -3, 0 };
        check(&sf.presets[58].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.97999, 4.8, 0, 5200, 0, 7, 0, -15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 98, 112, 23, 0, -3, 0 };
        check(&sf.presets[58].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.97999, 4.8, 0, 4400, 0, 7, 0, -15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 83, 97, 23, 0, -3, 0 };
        check(&sf.presets[58].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.97999, 4.8, 0, 3600, 0, 7, 0, -15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 67, 82, 23, 0, -3, 0 };
        check(&sf.presets[58].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.97999, 4.8, 0, 2800, 0, 7, 0, -15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 0, 66, 23, 0, -3, 0 };
        check(&sf.presets[58].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7502, 4.8, 0, 5000, 0, 7, 0, 15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.15003, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 109, 127, 23, 0, 3, 0 };
        check(&sf.presets[58].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7502, 4.8, 0, 4200, 0, 7, 0, 15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.15003, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 94, 108, 23, 0, 3, 0 };
        check(&sf.presets[58].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7502, 4.8, 0, 3400, 0, 7, 0, 15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.15003, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 78, 93, 23, 0, 3, 0 };
        check(&sf.presets[58].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7502, 4.8, 0, 2600, 0, 7, 0, 15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.15003, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 62, 77, 23, 0, 3, 0 };
        check(&sf.presets[58].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7502, 4.8, 0, 1800, 0, 7, 0, 15, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.15003, 83, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 22.706, 100, 0.5, 0, 0, 0, 127, 0, 61, 23, 0, 3, 0 };
        check(&sf.presets[58].regions[9], &values);
    }

    // ============================================================
    //  Slap Bass 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 114, 127, 0, 0, -23, 0 };
        check(&sf.presets[59].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 101, 113, 7, 0, -23, 0 };
        check(&sf.presets[59].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 88, 100, 14, 0, -23, 0 };
        check(&sf.presets[59].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 75, 87, 21, 0, -23, 0 };
        check(&sf.presets[59].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 61, 74, 28, 0, -23, 0 };
        check(&sf.presets[59].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1800, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 0, 60, 0, 0, -23, 0 };
        check(&sf.presets[59].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 61, 74, 5, 0, -23, 0 };
        check(&sf.presets[59].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 75, 87, 10, 0, -23, 0 };
        check(&sf.presets[59].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 88, 100, 15, 0, -23, 0 };
        check(&sf.presets[59].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 101, 113, 20, 0, -23, 0 };
        check(&sf.presets[59].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 6500, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 1, 0, 0, 0, 127, 114, 127, 25, 0, -23, 0 };
        check(&sf.presets[59].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1398, 0, 0, 2500, 0, 5, 3, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.029994, 85.8, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4, 100, 0.20004, 0, 0, 73, 127, 0, 127, 20, 0, 3, 0 };
        check(&sf.presets[59].regions[11], &values);
    }

    // ============================================================
    //  Reed Organ
    // ============================================================
    {
        const values = [_]f64{ 4, 0, 0, 0.17997, 4, 15, 0, 0.5, 0, 3, -6, 1, 1.2498, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.5, 0, 0, 0, 115, 0, 127, 5, 0, 4, 0 };
        check(&sf.presets[60].regions[0], &values);
    }
    {
        const values = [_]f64{ 4, 0, 0, 0.029994, 0, 15, 3000, 0.5, 0, 3, 15, 1, 1.2498, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 80.868, 1, 1, 0, 0.5, 0, 0, 57, 80, 0, 127, 10, 12, 0, 0 };
        check(&sf.presets[60].regions[1], &values);
    }
    {
        const values = [_]f64{ 4, 0, 0, 0.029994, 0, 15, 4000, 0.5, 0, 3, 15, 1, 1.2498, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 80.868, 1, 1, 0, 0.5, 0, 0, 81, 98, 0, 127, 15, 12, 0, 0 };
        check(&sf.presets[60].regions[2], &values);
    }
    {
        const values = [_]f64{ 4, 0, 0, 0.029994, 0, 15, 4000, 0.5, 0, 3, 15, 1, 1.2498, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 80.868, 1, 1, 0, 0.5, 0, 0, 99, 115, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[60].regions[3], &values);
    }
    {
        const values = [_]f64{ 4, 0, 0, 0.029994, 0, 15, 3000, 0.5, 0, 3, 15, 1, 1.2498, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 80.868, 1, 1, 0, 0.5, 0, 0, 0, 56, 0, 127, 20, 12, 0, 0 };
        check(&sf.presets[60].regions[4], &values);
    }

    // ============================================================
    //  Mono Strings Trem
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.55994, 1, 1, 0, 0.90021, 0, 0, 0, 127, 0, 51, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.46009, 1, 1, 0, 0.81979, 0, 0, 0, 127, 52, 65, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.37006, 1, 1, 0, 0.77022, 0, 0, 0, 127, 66, 78, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.26996, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.17997, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.089985, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 0, 4, 2, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 7, 0, -3, 0 };
        check(&sf.presets[61].regions[6], &values);
    }

    // ============================================================
    //  Stereo Strings Trem
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.90021, 1, 1, 0, 1, 0, 0, 0, 127, 0, 51, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.7002, 1, 1, 0, 0.97999, 0, 0, 0, 127, 52, 65, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 0.95982, 0, 0, 0, 127, 66, 78, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.3501, 1, 1, 0, 0.94007, 0, 0, 0, 127, 79, 89, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.26996, 1, 1, 0, 0.92019, 0, 0, 0, 127, 90, 100, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.13998, 1, 1, 0, 0.90021, 0, 0, 0, 127, 101, 113, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 666, 0, 3, 0, 14, 15, 4, 2, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.88016, 0, 0, 0, 127, 114, 127, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 700, 0, 2.7, 0, 14, -15, 4.5002, 1.2998, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.089985, 1, 1, 0, 0.80014, 0, 0, 0, 127, 96, 127, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 700, 0, 2.7, 0, 14, -15, 4.5002, 1.2998, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.23995, 1, 1, 0, 0.90021, 0, 0, 0, 127, 64, 95, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 700, 0, 2.7, 0, 14, -15, 4.5002, 1.2998, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.40007, 1, 1, 0, 1, 0, 0, 0, 127, 0, 63, 2, 0, -3, 0 };
        check(&sf.presets[62].regions[9], &values);
    }

    // ============================================================
    //  Mono Strings Velo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.55994, 1, 1, 0, 0.90021, 0, 0, 0, 127, 0, 51, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.46009, 1, 1, 0, 0.81979, 0, 0, 0, 127, 52, 65, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.37006, 1, 1, 0, 0.77022, 0, 0, 0, 127, 66, 78, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.26996, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.17997, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.089985, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 0, 0, -3, 0 };
        check(&sf.presets[63].regions[6], &values);
    }

    // ============================================================
    //  Mono Strings Slow
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.63986, 1, 1, 0, 1.2002, 0, 0, 0, 127, 0, 51, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.55994, 1, 1, 0, 0.90021, 0, 0, 0, 127, 52, 65, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.47991, 1, 1, 0, 0.81979, 0, 0, 0, 127, 66, 78, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.40007, 1, 1, 0, 0.77022, 0, 0, 0, 127, 79, 89, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.31993, 1, 1, 0, 0.74012, 0, 0, 0, 127, 90, 100, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.23995, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.15997, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 0, 0, -3, 0 };
        check(&sf.presets[64].regions[6], &values);
    }

    // ============================================================
    //  Mono Strings Fast
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.20998, 1, 1, 0, 0.77022, 0, 0, 0, 127, 0, 51, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.17997, 1, 1, 0, 0.76005, 0, 0, 0, 127, 52, 65, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.13998, 1, 1, 0, 0.75002, 0, 0, 0, 127, 66, 78, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.11002, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.069992, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.039991, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 2, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, 0, 0, -3, 0 };
        check(&sf.presets[65].regions[6], &values);
    }

    // ============================================================
    //  Stereo Strings Velo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.90021, 1, 1, 0, 0.90021, 0, 0, 0, 127, 0, 51, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.7002, 1, 1, 0, 0.81979, 0, 0, 0, 127, 52, 65, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 0.77022, 0, 0, 0, 127, 66, 78, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.3501, 1, 1, 0, 0.74012, 0, 0, 0, 127, 79, 89, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.26996, 1, 1, 0, 0.72993, 0, 0, 0, 127, 90, 100, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.13998, 1, 1, 0, 0.71988, 0, 0, 0, 127, 101, 113, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.70997, 0, 0, 0, 127, 114, 127, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.089985, 1, 1, 0, 0.75002, 0, 0, 0, 127, 96, 127, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.23995, 1, 1, 0, 0.85018, 0, 0, 0, 127, 64, 95, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.40007, 1, 1, 0, 0.94989, 0, 0, 0, 127, 0, 63, -1, 0, -3, 0 };
        check(&sf.presets[66].regions[9], &values);
    }

    // ============================================================
    //  Stereo Strings Slow
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.1, 1, 1, 0, 1.2002, 0, 0, 0, 127, 0, 51, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.90021, 1, 1, 0, 1, 0, 0, 0, 127, 52, 65, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.79004, 1, 1, 0, 0.97999, 0, 0, 0, 127, 66, 78, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.67987, 1, 1, 0, 0.95982, 0, 0, 0, 127, 79, 89, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.55994, 1, 1, 0, 0.94007, 0, 0, 0, 127, 90, 100, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.46009, 1, 1, 0, 0.92019, 0, 0, 0, 127, 101, 113, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.3501, 1, 1, 0, 0.90021, 0, 0, 0, 127, 114, 127, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.20004, 1, 1, 0, 0.94007, 0, 0, 0, 127, 96, 127, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.40007, 1, 1, 0, 1.0401, 0, 0, 0, 127, 64, 95, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.60012, 1, 1, 0, 1.1401, 0, 0, 0, 127, 0, 63, -1, 0, -3, 0 };
        check(&sf.presets[67].regions[9], &values);
    }

    // ============================================================
    //  Stereo Strings Fast
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.20004, 1, 1, 0, 1, 0, 0, 0, 127, 0, 51, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.17997, 1, 1, 0, 0.97999, 0, 0, 0, 127, 52, 65, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.15997, 1, 1, 0, 0.95982, 0, 0, 0, 127, 66, 78, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.11998, 1, 1, 0, 0.94007, 0, 0, 0, 127, 79, 89, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.079983, 1, 1, 0, 0.92019, 0, 0, 0, 127, 90, 100, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.039991, 1, 1, 0, 0.90021, 0, 0, 0, 127, 101, 113, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.88016, 0, 0, 0, 127, 114, 127, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.089985, 1, 1, 0, 0.80014, 0, 0, 0, 127, 96, 127, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.11998, 1, 1, 0, 0.90021, 0, 0, 0, 127, 64, 95, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, -15, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.17997, 1, 1, 0, 1, 0, 0, 0, 127, 0, 63, -1, 0, -3, 0 };
        check(&sf.presets[68].regions[9], &values);
    }

    // ============================================================
    //  SFX
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[69].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 6, 50, 0 };
        check(&sf.presets[69].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[69].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 3, 50, 0 };
        check(&sf.presets[69].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 53, 0, 127, 0, 3, 50, 0 };
        check(&sf.presets[69].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 54, 0, 127, 0, 2, 0, 0 };
        check(&sf.presets[69].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 55, 55, 0, 127, 0, 1, 0, 0 };
        check(&sf.presets[69].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 56, 57, 0, 127, -7.1, 0, 50, 0 };
        check(&sf.presets[69].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 58, 58, 0, 127, 10, -2, 50, -40 };
        check(&sf.presets[69].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 58, 58, 0, 127, 10, 2, 50, -40 };
        check(&sf.presets[69].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 59, 59, 0, 127, 12, 0, 25, 0 };
        check(&sf.presets[69].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 60, 60, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[69].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 62, 62, 0, 127, 15, -1, 12, 0 };
        check(&sf.presets[69].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 63, 63, 0, 127, 12, -1, 0, 0 };
        check(&sf.presets[69].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 64, 64, 0, 127, 4, -2, 0, 0 };
        check(&sf.presets[69].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 65, 65, 0, 127, 0, -2, -50, 0 };
        check(&sf.presets[69].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.64992, 0, 0, 67, 67, 0, 127, 10, -3, -50, 0 };
        check(&sf.presets[69].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 68, 68, 0, 127, 25, -5, -25, 0 };
        check(&sf.presets[69].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 69, 69, 0, 127, 10, -9, 0, 0 };
        check(&sf.presets[69].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.5004, 0, 0, 70, 70, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[69].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 71, 71, 0, 127, 10, -5, -50, 0 };
        check(&sf.presets[69].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 72, 72, 0, 127, 0, -8, 0, 0 };
        check(&sf.presets[69].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 73, 73, 0, 127, 6, -6, -50, 0 };
        check(&sf.presets[69].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 1300, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 10, 8, 40, 0 };
        check(&sf.presets[69].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 7200, 0, 0, 3, 12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 0, -8, 40, 0 };
        check(&sf.presets[69].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 5464, 0, 0, 3, -12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 74, 74, 0, 127, 0, -10, 40, 0 };
        check(&sf.presets[69].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 75, 75, 0, 127, 20, -1, 0, 0 };
        check(&sf.presets[69].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 75, 75, 0, 127, 20, -1, -50, 0 };
        check(&sf.presets[69].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 127, 0, -8, 0, 0 };
        check(&sf.presets[69].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0.0099978, 4.9991, 1, 1, 0, 3.0001, 0, 0, 77, 77, 0, 127, 15, -3, 0, 0 };
        check(&sf.presets[69].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 78, 78, 0, 127, 35, -6, 0, 0 };
        check(&sf.presets[69].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 78, 78, 0, 127, 35, -4, 0, 0 };
        check(&sf.presets[69].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 79, 79, 0, 127, 10, -11, 0, 0 };
        check(&sf.presets[69].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 79, 79, 0, 127, 10, -6, 0, 0 };
        check(&sf.presets[69].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 250, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 80, 80, 0, 127, 0, -10, 50, 0 };
        check(&sf.presets[69].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 81, 81, 0, 127, 10, -21, 0, 0 };
        check(&sf.presets[69].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 82, 82, 0, 127, 0, -11, 0, 0 };
        check(&sf.presets[69].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 83, 83, 0, 127, 20, -12, -50, 0 };
        check(&sf.presets[69].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 83, 83, 0, 127, 20, -10, -50, 0 };
        check(&sf.presets[69].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 84, 84, 0, 127, 5, -12, 0, 0 };
        check(&sf.presets[69].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 61, 61, 0, 127, 7.5, -1, -50, 0 };
        check(&sf.presets[69].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 66, 66, 0, 127, 0, -3, 0, 0 };
        check(&sf.presets[69].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 12, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[69].regions[42], &values);
    }

    // ============================================================
    //  Orchestral
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 88, 88, 0, 127, 5, -14, 0, 0 };
        check(&sf.presets[70].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 53, 0, 107, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 41, 53, 108, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[70].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[70].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[70].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[70].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[70].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[70].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[70].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[70].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[70].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[70].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 15, 0, 50, 0 };
        check(&sf.presets[70].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 11, 0, 50, 0 };
        check(&sf.presets[70].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[70].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 15, -5, 0, 0 };
        check(&sf.presets[70].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 11, -5, 0, 0 };
        check(&sf.presets[70].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 7, -26.2, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[70].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 37, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 31, 34, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 54, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 17.7, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 59, 59, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[70].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 7, -51.8, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -2, 0, 0 };
        check(&sf.presets[70].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[70].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, -29.1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[70].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 36, 36, 0, 127, -2, 0, 0, 0 };
        check(&sf.presets[70].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 25.6, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 39, 39, 0, 127, 3, 9, -50, 0 };
        check(&sf.presets[70].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 38, 38, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 40, 40, 0, 127, 0, -2, 38, 0 };
        check(&sf.presets[70].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[70].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[70].regions[38], &values);
    }

    // ============================================================
    //  Brush
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[71].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[71].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[71].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[71].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[71].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[71].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[71].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[71].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[71].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[71].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[71].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[71].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[71].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[71].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[71].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[71].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[71].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[71].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[71].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[71].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[71].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[71].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[71].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[71].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[71].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[71].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[71].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[71].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, -5, 0, 0 };
        check(&sf.presets[71].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[71].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 109, 127, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 86, 108, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 19.996, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2.4102, 1, 1, 0, 1, 0, 0, 0, 127, 0, 85, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[71].regions[43], &values);
    }

    // ============================================================
    //  Jazz
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[72].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[72].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[72].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[72].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[72].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[72].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[72].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[72].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[72].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[72].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[72].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[72].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[72].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[72].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[72].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[72].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[72].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[72].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[72].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[72].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[72].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[72].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[72].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[72].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[72].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[72].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[72].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[72].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[72].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[72].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[72].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[72].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[72].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, -5, 0, 0 };
        check(&sf.presets[72].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[72].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[72].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -1, 0, 0 };
        check(&sf.presets[72].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.2998, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[72].regions[43], &values);
    }

    // ============================================================
    //  Electronic
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[73].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[73].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[73].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[73].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[73].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[73].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[73].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[73].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[73].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[73].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[73].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[73].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[73].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[73].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[73].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[73].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[73].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[73].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[73].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[73].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[73].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 44, 0, 127, 41.9, 1, 0, 0 };
        check(&sf.presets[73].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 53, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[73].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[73].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 50, 50, 0, 127, 0, 14, 0, 0 };
        check(&sf.presets[73].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 17, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 48, 48, 0, 127, 0, 12, 0, 0 };
        check(&sf.presets[73].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 47, 47, 0, 127, 0, 9, 0, 0 };
        check(&sf.presets[73].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -5, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 45, 45, 0, 127, 0, 7, 0, 0 };
        check(&sf.presets[73].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -18, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 43, 43, 0, 127, 0, 5, 0, 0 };
        check(&sf.presets[73].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 41, 41, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[73].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[73].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 0.7002, 1, 1, 0, 100.02, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 52, 52, 0, 127, 0, 4, 0, 0 };
        check(&sf.presets[73].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 42, 46, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0.0099978, 0.15003, 0, 0.15003, 0, 0, 46, 46, 0, 127, 41.9, 15, 0, 0 };
        check(&sf.presets[73].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[73].regions[48], &values);
    }

    // ============================================================
    //  Power
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -1, 0, 0 };
        check(&sf.presets[74].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -1, 0, 0 };
        check(&sf.presets[74].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[74].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[74].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[74].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[74].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 5, 0, 0, 0 };
        check(&sf.presets[74].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 95, 111, 5, 0, 0, 0 };
        check(&sf.presets[74].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 74, 94, 5, 0, 0, 0 };
        check(&sf.presets[74].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 73, 5, 0, 0, 0 };
        check(&sf.presets[74].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -1, 0, 0 };
        check(&sf.presets[74].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[74].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[74].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[74].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[74].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[74].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[74].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[74].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[74].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[74].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[74].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[74].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[74].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[74].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[74].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[74].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[74].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, -1, -72, 0 };
        check(&sf.presets[74].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[74].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[74].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[74].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[74].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 20, 0, 0, 0 };
        check(&sf.presets[74].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 20, 0, 0, 0 };
        check(&sf.presets[74].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 20, 0, 0, 0 };
        check(&sf.presets[74].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 20, 0, 0, 0 };
        check(&sf.presets[74].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 20, 0, 0, 0 };
        check(&sf.presets[74].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[74].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 4, 1, 0, 0 };
        check(&sf.presets[74].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[74].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -2, 0, 0 };
        check(&sf.presets[74].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 5617, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.039991, 100, 0.039991, 0, 0, 1, 1, 1, 3.0001, 96, 3.0001, 0, 0, 0, 127, 111, 127, 0, 0, 0, 0 };
        check(&sf.presets[74].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 96, 2, 0, 0, 0, 127, 95, 110, -3, 0, 0, 0 };
        check(&sf.presets[74].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1, 0, 0, 0, 127, 79, 94, -6, 0, 0, 0 };
        check(&sf.presets[74].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 96, 0.80014, 0, 0, 0, 127, 64, 78, -9, 0, 0, 0 };
        check(&sf.presets[74].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 96, 0.60012, 0, 0, 0, 127, 0, 63, -12, 0, 0, 0 };
        check(&sf.presets[74].regions[50], &values);
    }

    // ============================================================
    //  Room
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[75].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[75].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[75].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[75].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[75].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[75].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -6, 0, 0 };
        check(&sf.presets[75].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[75].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[75].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[75].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[75].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[75].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[75].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[75].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[75].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[75].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[75].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[75].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[75].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[75].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[75].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[75].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, -1, 0, 0 };
        check(&sf.presets[75].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[75].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[75].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[75].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[75].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[75].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[75].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[75].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 5, 0, 0, 0 };
        check(&sf.presets[75].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 95, 111, 5, 0, 0, 0 };
        check(&sf.presets[75].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 74, 94, 5, 0, 0, 0 };
        check(&sf.presets[75].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 0, 73, 5, 0, 0, 0 };
        check(&sf.presets[75].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 20, 0, 0, 0 };
        check(&sf.presets[75].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 20, 0, 0, 0 };
        check(&sf.presets[75].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 20, 0, 0, 0 };
        check(&sf.presets[75].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 20, 0, 0, 0 };
        check(&sf.presets[75].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 20, 0, 0, 0 };
        check(&sf.presets[75].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 1, 83, 0 };
        check(&sf.presets[75].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[75].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[75].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[75].regions[47], &values);
    }

    // ============================================================
    //  Standard 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[76].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[76].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[76].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[76].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[76].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[76].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[76].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[76].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[76].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[76].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[76].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[76].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[76].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[76].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[76].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[76].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[76].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[76].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[76].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[76].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[76].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[76].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[76].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[76].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[76].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[76].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[76].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[76].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[76].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[76].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[76].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[76].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[76].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[76].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 5617, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 0.039991, 100, 0.039991, 0, 0, 1, 1, 1, 3.0001, 96, 3.0001, 0, 0, 0, 127, 111, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 96, 2, 0, 0, 0, 127, 95, 110, -3, 0, 0, 0 };
        check(&sf.presets[76].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1, 0, 0, 0, 127, 79, 94, -6, 0, 0, 0 };
        check(&sf.presets[76].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 96, 0.80014, 0, 0, 0, 127, 64, 78, -9, 0, 0, 0 };
        check(&sf.presets[76].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 96, 0.60012, 0, 0, 0, 127, 0, 63, -12, 0, 0, 0 };
        check(&sf.presets[76].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 11, 0, 0, 0 };
        check(&sf.presets[76].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[76].regions[46], &values);
    }

    // ============================================================
    //  Standard+Orch
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, -3, 0, 0 };
        check(&sf.presets[77].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[77].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[77].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[77].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[77].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[77].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 101, 127, 0, 10, 0, 0 };
        check(&sf.presets[77].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 66, 100, 0, 10, 0, 0 };
        check(&sf.presets[77].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 67, 67, 0, 65, 0, 10, 0, 0 };
        check(&sf.presets[77].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 101, 127, 0, 4, 0, 0 };
        check(&sf.presets[77].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 66, 100, 0, 4, 0, 0 };
        check(&sf.presets[77].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, -53, 68, 68, 0, 65, 0, 4, 0, 0 };
        check(&sf.presets[77].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 13, 0, 0, 0 };
        check(&sf.presets[77].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 13, 0, 0, 0 };
        check(&sf.presets[77].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 13, 0, 0, 0 };
        check(&sf.presets[77].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 13, 0, 0, 0 };
        check(&sf.presets[77].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 13, 0, 0, 0 };
        check(&sf.presets[77].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 102, 127, 0, 0, 50, 0 };
        check(&sf.presets[77].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 86, 101, 0, 0, 50, 0 };
        check(&sf.presets[77].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 71, 85, 0, 0, 50, 0 };
        check(&sf.presets[77].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 70, 0, 0, 50, 0 };
        check(&sf.presets[77].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 76, 76, 0, 101, 8, 0, 50, 0 };
        check(&sf.presets[77].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 102, 114, 4, 0, 50, 0 };
        check(&sf.presets[77].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 76, 76, 115, 127, 0, 0, 50, 0 };
        check(&sf.presets[77].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 102, 127, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 86, 101, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 71, 85, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 70, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 77, 77, 0, 101, 8, -5, 0, 0 };
        check(&sf.presets[77].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 102, 114, 4, -5, 0, 0 };
        check(&sf.presets[77].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 77, 77, 115, 127, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[77].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, -16, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[77].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -5, 0, 0 };
        check(&sf.presets[77].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 38, 38, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 40, 40, 0, 127, 0, -2, 38, 0 };
        check(&sf.presets[77].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 35, 35, 0, 127, 11.2, 0, 0, 0 };
        check(&sf.presets[77].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 17.7, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 49, 49, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[77].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[77].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 35, 35, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[77].regions[44], &values);
    }

    // ============================================================
    //  FM Electric Piano
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 121, 127, 0, 0, 7, 0 };
        check(&sf.presets[78].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 114, 120, 5, 0, 7, 0 };
        check(&sf.presets[78].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 107, 113, 9, 0, 7, 0 };
        check(&sf.presets[78].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 99, 106, 14, 0, 7, 0 };
        check(&sf.presets[78].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 92, 98, 18, 0, 7, 0 };
        check(&sf.presets[78].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 83, 91, 23, 0, 7, 0 };
        check(&sf.presets[78].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 71, 82, 27, 0, 7, 0 };
        check(&sf.presets[78].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 59, 70, 32, 0, 7, 0 };
        check(&sf.presets[78].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 46, 58, 36, 0, 7, 0 };
        check(&sf.presets[78].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 39.993, 0, 0, 0, 0, 22, 7, 12, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 1, 1, 96, 0.5, 0, 0, 0, 127, 0, 45, 41, 0, 7, 0 };
        check(&sf.presets[78].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, 0, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[78].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[78].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[78].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[78].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[78].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[78].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 54, 74, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[78].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 106, 127, -4, 0, 0, 0 };
        check(&sf.presets[78].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 85, 104, -6, 0, 0, 0 };
        check(&sf.presets[78].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 61, 84, -8, 0, 0, 0 };
        check(&sf.presets[78].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 34, 60, -10, 0, 0, 0 };
        check(&sf.presets[78].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 75, 127, 0, 33, -12, 0, 0, 0 };
        check(&sf.presets[78].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2998, -2, 0, 3400, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 117, 127, 0, 0, 0, 0 };
        check(&sf.presets[78].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, -2, 0, 3100, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 106, 116, -2, 0, 0, 0 };
        check(&sf.presets[78].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, -2, 0, 2800, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 93, 105, -4, 0, 0, 0 };
        check(&sf.presets[78].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, -2, 0, 2500, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 79, 92, -6, 0, 0, 0 };
        check(&sf.presets[78].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, -2, 0, 2200, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 67, 78, -8, 0, 0, 0 };
        check(&sf.presets[78].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, -2, 0, 1900, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 38, 66, -10, 0, 0, 0 };
        check(&sf.presets[78].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, -2, 0, 1600, 0, 15, 7, -7, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1.5, 80, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 19.996, 96, 0.5, 0, 0, 0, 53, 0, 37, -12, 0, 0, 0 };
        check(&sf.presets[78].regions[28], &values);
    }

    // ============================================================
    //  Tine Electric Piano
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 67, 10, 0, -23, 0 };
        check(&sf.presets[79].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 68, 105, 10, 0, -23, 0 };
        check(&sf.presets[79].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 1, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 10, 0, -23, 0 };
        check(&sf.presets[79].regions[2], &values);
    }

    // ============================================================
    //  Stereo Grand
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 2, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 0, 35, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 1, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 0, 35, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 0, 35, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 0, 35, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 0, 35, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 0, 35, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 0, 35, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 0, 35, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 2, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 36, 50, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 1, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 36, 50, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 36, 50, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 36, 50, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 36, 50, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 36, 50, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 36, 50, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 36, 50, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 2, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 51, 65, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 1, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 51, 65, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 51, 65, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 51, 65, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 51, 65, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 51, 65, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 51, 65, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 51, 65, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 2, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 66, 80, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 1, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 66, 80, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 66, 80, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 66, 80, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 66, 80, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 66, 80, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 66, 80, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 66, 80, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 3, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 81, 87, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.66014, 0, 0, 81, 87, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 1, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.67987, 0, 0, 81, 87, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.7002, 0, 0, 81, 87, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.71988, 0, 0, 81, 87, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.74012, 0, 0, 81, 87, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.76005, 0, 0, 81, 87, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.79004, 0, 0, 81, 87, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 4, 0, 600, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 0, 49, -8, 0, 0, 0 };
        check(&sf.presets[80].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 750, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 50, 65, -6, 0, 0, 0 };
        check(&sf.presets[80].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 1.2, 0, 1200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 66, 79, -5, 0, 0, 0 };
        check(&sf.presets[80].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 80, 91, -4, 0, 0, 0 };
        check(&sf.presets[80].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 92, 101, -3, 0, 0, 0 };
        check(&sf.presets[80].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 102, 110, -2, 0, 0, 0 };
        check(&sf.presets[80].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 111, 119, -1, 0, 0, 0 };
        check(&sf.presets[80].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 7, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.65, 0, 0.64992, 0, 0, 88, 127, 120, 127, 0, 0, 0, 0 };
        check(&sf.presets[80].regions[47], &values);
    }

    // ============================================================
    //  Honky-Tonk
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5502, 4, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 0, 35, 0, 48, -3, 0, -5, 0 };
        check(&sf.presets[81].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 2, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 0, 35, 49, 62, -1, 0, -5, 0 };
        check(&sf.presets[81].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 2, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 0, 35, 63, 74, 0, 0, -5, 0 };
        check(&sf.presets[81].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 0, 35, 75, 86, 1, 0, -5, 0 };
        check(&sf.presets[81].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2800, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 0, 35, 87, 96, 2, 0, -5, 0 };
        check(&sf.presets[81].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 0, 35, 97, 107, 3, 0, -5, 0 };
        check(&sf.presets[81].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 4500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 0, 35, 108, 117, 4, 0, -5, 0 };
        check(&sf.presets[81].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 7000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 0, 35, 118, 127, 5, 0, -5, 0 };
        check(&sf.presets[81].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.7004, 4, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 36, 50, 0, 48, -3, 0, -5, 0 };
        check(&sf.presets[81].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 2, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 36, 50, 49, 62, -1, 0, -5, 0 };
        check(&sf.presets[81].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 2, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 36, 50, 63, 74, 0, 0, -5, 0 };
        check(&sf.presets[81].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 36, 50, 75, 86, 1, 0, -5, 0 };
        check(&sf.presets[81].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2800, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 36, 50, 87, 96, 2, 0, -5, 0 };
        check(&sf.presets[81].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 36, 50, 97, 107, 3, 0, -5, 0 };
        check(&sf.presets[81].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 4500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 36, 50, 108, 117, 4, 0, -5, 0 };
        check(&sf.presets[81].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 7000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 36, 50, 118, 127, 5, 0, -5, 0 };
        check(&sf.presets[81].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.85, 4, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 51, 65, 0, 48, -3, 0, -5, 0 };
        check(&sf.presets[81].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 2, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 51, 65, 49, 62, -1, 0, -5, 0 };
        check(&sf.presets[81].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 2, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 51, 65, 63, 74, 0, 0, -5, 0 };
        check(&sf.presets[81].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 51, 65, 75, 86, 1, 0, -5, 0 };
        check(&sf.presets[81].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2800, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 51, 65, 87, 96, 2, 0, -5, 0 };
        check(&sf.presets[81].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 51, 65, 97, 107, 3, 0, -5, 0 };
        check(&sf.presets[81].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 4500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 51, 65, 108, 117, 4, 0, -5, 0 };
        check(&sf.presets[81].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 7000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 51, 65, 118, 127, 5, 0, -5, 0 };
        check(&sf.presets[81].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 4, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 66, 80, 0, 48, -3, 0, -5, 0 };
        check(&sf.presets[81].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 2, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 66, 80, 49, 62, -1, 0, -5, 0 };
        check(&sf.presets[81].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 2, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 66, 80, 63, 74, 0, 0, -5, 0 };
        check(&sf.presets[81].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 66, 80, 75, 86, 1, 0, -5, 0 };
        check(&sf.presets[81].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2800, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 66, 80, 87, 96, 2, 0, -5, 0 };
        check(&sf.presets[81].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 66, 80, 97, 107, 3, 0, -5, 0 };
        check(&sf.presets[81].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 4500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 66, 80, 108, 117, 4, 0, -5, 0 };
        check(&sf.presets[81].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 7000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 66, 80, 118, 127, 5, 0, -5, 0 };
        check(&sf.presets[81].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1497, 6, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 81, 88, 0, 48, -3, 0, -10, 0 };
        check(&sf.presets[81].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 4, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 81, 88, 49, 62, -1, 0, -10, 0 };
        check(&sf.presets[81].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 2, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 81, 88, 63, 74, 0, 0, -10, 0 };
        check(&sf.presets[81].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 81, 88, 75, 86, 1, 0, -10, 0 };
        check(&sf.presets[81].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 81, 88, 87, 96, 2, 0, -10, 0 };
        check(&sf.presets[81].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 81, 88, 97, 107, 3, 0, -10, 0 };
        check(&sf.presets[81].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3300, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 81, 88, 108, 117, 4, 0, -10, 0 };
        check(&sf.presets[81].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 81, 88, 118, 127, 5, 0, -10, 0 };
        check(&sf.presets[81].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 8, 0, 750, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 0, 48, -3, 0, -15, 0 };
        check(&sf.presets[81].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 5, 0, 1200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 49, 62, -1, 0, -15, 0 };
        check(&sf.presets[81].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2.5, 0, 1700, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 63, 74, 0, 0, -15, 0 };
        check(&sf.presets[81].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2200, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 75, 86, 1, 0, -15, 0 };
        check(&sf.presets[81].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 2800, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 87, 96, 2, 0, -15, 0 };
        check(&sf.presets[81].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 3500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 97, 107, 3, 0, -15, 0 };
        check(&sf.presets[81].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 4500, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 108, 117, 4, 0, -15, 0 };
        check(&sf.presets[81].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 2, 0, 7000, 0, 0, 3, 5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 89, 127, 118, 127, 5, 0, -15, 0 };
        check(&sf.presets[81].regions[47], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 30, 127, 113, 127, -3, 0, 3, 0 };
        check(&sf.presets[81].regions[48], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23005, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 30, 127, 97, 112, -4, 0, 3, 0 };
        check(&sf.presets[81].regions[49], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 30, 127, 82, 96, -5, 0, 3, 0 };
        check(&sf.presets[81].regions[50], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 4, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 30, 127, 65, 81, -6, 0, 3, 0 };
        check(&sf.presets[81].regions[51], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 6, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 30, 127, 0, 64, -7, 0, 3, 0 };
        check(&sf.presets[81].regions[52], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 29, 113, 127, -3, 0, -10, 0 };
        check(&sf.presets[81].regions[53], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23005, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 29, 97, 112, -4, 0, -10, 0 };
        check(&sf.presets[81].regions[54], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 2, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 29, 82, 96, -5, 0, -10, 0 };
        check(&sf.presets[81].regions[55], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 4, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 29, 65, 81, -6, 0, -10, 0 };
        check(&sf.presets[81].regions[56], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 6, 0, 0, 0, 0, 3, -5, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 29, 0, 64, -7, 0, -10, 0 };
        check(&sf.presets[81].regions[57], &values);
    }

    // ============================================================
    //  Bright Grand
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.8004, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 0, 35, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 0, 35, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 0, 35, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 0, 35, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 0, 35, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 0, 35, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 0, 35, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 7000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 0, 35, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 36, 50, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.47991, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 36, 50, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.52003, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 36, 50, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 36, 50, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 36, 50, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 36, 50, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 36, 50, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 7000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 36, 50, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 51, 65, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.50992, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 51, 65, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 51, 65, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 51, 65, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[19], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 51, 65, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[20], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 51, 65, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[21], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 51, 65, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[22], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 7000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 51, 65, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[23], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 66, 80, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[24], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.53993, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 66, 80, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[25], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55994, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 66, 80, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[26], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 66, 80, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[27], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 66, 80, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[28], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 66, 80, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[29], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 66, 80, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[30], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 7000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 66, 80, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[31], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.2894, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 81, 87, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[32], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.57005, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.66014, 0, 0, 81, 87, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[33], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.58002, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.67987, 0, 0, 81, 87, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[34], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.59016, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.7002, 0, 0, 81, 87, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[35], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.71988, 0, 0, 81, 87, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[36], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.74012, 0, 0, 81, 87, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[37], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3300, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.76005, 0, 0, 81, 87, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[38], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.79004, 0, 0, 81, 87, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[39], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.4995, 0, 0, 750, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 4, 0, 0.5, 0, 68, 1, 1, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 0, 48, -8, 0, 0, 0 };
        check(&sf.presets[82].regions[40], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.7996, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 49, 62, -6, 0, 0, 0 };
        check(&sf.presets[82].regions[41], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 1700, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.5004, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 63, 74, -5, 0, 0, 0 };
        check(&sf.presets[82].regions[42], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2200, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 3.0001, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 75, 86, -4, 0, 0, 0 };
        check(&sf.presets[82].regions[43], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 87, 96, -3, 0, 0, 0 };
        check(&sf.presets[82].regions[44], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 3500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 97, 107, -2, 0, 0, 0 };
        check(&sf.presets[82].regions[45], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 4500, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 108, 117, -1, 0, 0, 0 };
        check(&sf.presets[82].regions[46], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, 7000, 0, 0, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 2.4995, 0, 0.5, 0, 68, 1, 0.0099978, 1, 1.5, 0, 0.64992, 0, 0, 88, 127, 118, 127, 0, 0, 0, 0 };
        check(&sf.presets[82].regions[47], &values);
    }

    // ============================================================
    //  Shooting Star
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 96, 0, 6298, 0, 7, 3.5, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 2.1398, 100, 2.1398, 0, 0, 0.0099978, 0.0099978, 0.0099978, 3.5595, 100, 3.5595, 0, 0, 0, 127, 0, 127, 0, 49, 0, 0 };
        check(&sf.presets[83].regions[0], &values);
    }

    // ============================================================
    //  Night Vision
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 7.8083, 0, 0, 5617, 0, 30, 100, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 2, 100, 2, 0, 0, 0, 127, 0, 127, 63, 0, 0, 0 };
        check(&sf.presets[84].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 30, 100, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0, 127, 0, 127, 53, -2, -31, 0 };
        check(&sf.presets[84].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.8497, 0, 0, 1532, 0, 21, 50, 0, 0.0099978, 1, 0.0099978, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.30006, 100, 0.30006, 0, 0, 0.0099978, 0.079983, 0.0099978, 14.998, 9.2, 39.993, 0, 0, 0, 108, 0, 127, 8, 0, 5, 0 };
        check(&sf.presets[84].regions[2], &values);
    }

    // ============================================================
    //  Mean Saw Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 500, 100.02, 0, 0, 0, 0, 30, 0, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4.9991, 100, 0.5, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[85].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, -14, 0.7002, 5, 0, 7000, 0, 30, 0, -25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 3.0001, 100, 0.5, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[85].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 14, 0.7002, 5, 0, 7000, 0, 30, 0, 25, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 3.0001, 100, 0.5, 0, 0, 0, 127, 0, 127, 23, 0, 0, 0 };
        check(&sf.presets[85].regions[2], &values);
    }

    // ============================================================
    //  Pulse Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.71988, 0, 0, 2553, 0, 7, 0, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.079983, 100, 0.079983, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 10, 0.5, 0, 0, 0, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[86].regions[0], &values);
    }

    // ============================================================
    //  Bright Saw Stack
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 10.998, 0, 0, 2400, 0, 21, 14, 0, 0.0099978, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.30006, 100, 0.30006, 0, 0, 0.0099978, 0.079983, 0.0099978, 9.9982, 96, 39.993, 0, 0, 0, 108, 0, 127, 0, 0, 5, 0 };
        check(&sf.presets[87].regions[0], &values);
    }

    // ============================================================
    //  Square Lead 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, -70, 10.52, 0, 0, 2000, 0, 14, 5, -10, 0.0099978, 1.2002, 0.0099978, 1.2002, 0.0099978, 0.0099978, 0.0099978, 0.050009, 100, 0.050009, 0, 0, 0.0099978, 0.0099978, 0.0099978, 21.996, 9.2, 0.5, 0, 0, 0, 127, 0, 127, 33, 0, 6, 0 };
        check(&sf.presets[88].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 22.706, 0, 0, 2894, 0, 14, 5, 10, 0.0099978, 1.2002, 0.0099978, 1.2002, 0.0099978, 0.0099978, 0.0099978, 0.050009, 100, 0.050009, 0, 0, 0.0099978, 0.079983, 0.0099978, 21.996, 9.2, 0.5, 0, 0, 0, 127, 0, 127, 33, 0, -5, 0 };
        check(&sf.presets[88].regions[1], &values);
    }

    // ============================================================
    //  Square Lead
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.19001, 0, 0, 2000, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.15003, 0, 0, 0, 127, 109, 127, 33.5, 0, 3, 0 };
        check(&sf.presets[89].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, -45, 0.19001, 5, 0, 2000, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.30006, 0, 0, 0, 127, 109, 127, 33.5, 0, -3, 0 };
        check(&sf.presets[89].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.17997, 0, 0, 1500, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.15003, 0, 0, 0, 127, 89, 108, 33.5, 0, 3, 0 };
        check(&sf.presets[89].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, -35, 0.17997, 5, 0, 1500, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.30006, 0, 0, 0, 127, 89, 108, 33.5, 0, -3, 0 };
        check(&sf.presets[89].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 1250, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.15003, 0, 0, 0, 127, 67, 88, 33.5, 0, 3, 0 };
        check(&sf.presets[89].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, -25, 0.16997, 5, 0, 1250, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.30006, 0, 0, 0, 127, 67, 88, 33.5, 0, -3, 0 };
        check(&sf.presets[89].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 1000, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.15003, 0, 0, 0, 127, 0, 66, 33.5, 0, 3, 0 };
        check(&sf.presets[89].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, -15, 0.15997, 5, 0, 1000, 0, 21, 0, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 65.006, 100, 65.006, 0, 0, 1, 1, 1, 12, 5, 0.30006, 0, 0, 0, 127, 0, 66, 33.5, 0, -3, 0 };
        check(&sf.presets[89].regions[7], &values);
    }

    // ============================================================
    //  Harpsi Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 4, 0, 1500, 0, 17, 32, 0, 0.0099978, 0.60991, 1, 1, 0.0099978, 0.0099978, 0.0099978, 12, 100, 12, 0, 0, 0.0099978, 0.079983, 9.9982, 25.005, 96, 25.005, 0, 0, 0, 108, 0, 127, 18, 0, 0, 0 };
        check(&sf.presets[90].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.60012, 0, 0, -500, 0, 50, 32, 0, 100.02, 0.60991, 1, 0.60991, 1, 0.60012, 1, 1, 0, 1, 0, 0, 1, 0.079983, 1, 1, 0, 0.80014, 0, 0, 0, 105, 0, 127, 21, 0, 3, 0 };
        check(&sf.presets[90].regions[1], &values);
    }

    // ============================================================
    //  Synth Strings 3
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 1000, 0, 7, 21, 25, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 56.038, 0, 0, 0.0099978, 2.1398, 0.0099978, 0.0099978, 0, 29.995, 0, 0, 0, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[91].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 21, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.7002, 1, 1, 0, 2, 0, 0, 0, 108, 0, 127, 14, 0, 0, 0 };
        check(&sf.presets[91].regions[1], &values);
    }

    // ============================================================
    //  Halo Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.85018, 0, 0, 1500, 0, 14, 14, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 0.30006, 0.0099978, 0.0099978, 0, 22.706, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[92].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 15, 0, 1700, 0, 14, 14, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 2, 15, 2, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 2, 0, 0, 0, 127, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[92].regions[1], &values);
    }

    // ============================================================
    //  Saw Lead 3
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 12, 0, 0, 3000, 0, 14, 3.5, -10, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.10002, 60, 0.10002, 0, 0, 0.0099978, 0.079983, 0.0099978, 11.36, 7.8, 0.30006, 0, 0, 0, 127, 0, 127, 25, 0, -6, 0 };
        check(&sf.presets[93].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 45.464, 0, 0, -2894, 0, 14, 3.5, 10, 0.0099978, 1.2002, 0.0099978, 1, 0.0099978, 9.2322, 0.0099978, 4.9991, 50.4, 0.029994, 0, 0, 0.0099978, 0.0099978, 0.0099978, 11.36, 7.8, 0.30006, 0, 0, 0, 127, 0, 127, 25, 0, 6, 0 };
        check(&sf.presets[93].regions[1], &values);
    }

    // ============================================================
    //  Synth Brass 1
    // ============================================================
    {
        const values = [_]f64{ 0, 12, 100, 38.011, 3, 0, 2650, 0, 7, 5, -5, 0.0099978, 1, 2, 1, 0.0099978, 0.0099978, 0.0099978, 0.050009, 100, 0.050009, 0, 0, 0.0099978, 0.5, 0.0099978, 4.9703, 6.4, 0.20004, 0, 0, 0, 127, 0, 127, 21, 0, 3, 0 };
        check(&sf.presets[94].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 12, -30, 29.995, 2, 0, 1872, 0, 7, 5, 5, 0.0099978, 1, 1.5, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.089985, 100, 0.089985, 0, 0, 0.0099978, 0.22004, 0.0099978, 9.2322, 6.4, 0.3501, 0, 0, 0, 127, 0, 127, 30, 0, -3, 0 };
        check(&sf.presets[94].regions[1], &values);
    }

    // ============================================================
    //  Synth Strings 1
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.5, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[95].regions[0], &values);
    }

    // ============================================================
    //  Marimba
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 121, 127, 9, 0, 0, 0 };
        check(&sf.presets[96].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 114, 120, 8, 0, 0, 0 };
        check(&sf.presets[96].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 107, 113, 7, 0, 0, 0 };
        check(&sf.presets[96].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 100, 106, 6, 0, 0, 0 };
        check(&sf.presets[96].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 93, 99, 5, 0, 0, 0 };
        check(&sf.presets[96].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 86, 92, 4, 0, 0, 0 };
        check(&sf.presets[96].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 79, 85, 3, 0, 0, 0 };
        check(&sf.presets[96].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 72, 78, 2, 0, 0, 0 };
        check(&sf.presets[96].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 0, 64, 65, 71, 1, 0, 0, 0 };
        check(&sf.presets[96].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 0, 2, 0, 0, 0, 64, 0, 64, 0, 0, 0, 0 };
        check(&sf.presets[96].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 121, 127, 9, 0, 0, 0 };
        check(&sf.presets[96].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 114, 120, 8, 0, 0, 0 };
        check(&sf.presets[96].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 107, 113, 7, 0, 0, 0 };
        check(&sf.presets[96].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 100, 106, 6, 0, 0, 0 };
        check(&sf.presets[96].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 93, 99, 5, 0, 0, 0 };
        check(&sf.presets[96].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 86, 92, 4, 0, 0, 0 };
        check(&sf.presets[96].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 79, 85, 3, 0, 0, 0 };
        check(&sf.presets[96].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 72, 78, 2, 0, 0, 0 };
        check(&sf.presets[96].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 2, 0, 2, 0, 0, 65, 127, 65, 71, 1, 0, 0, 0 };
        check(&sf.presets[96].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 2, 0, 2, 0, 0, 65, 127, 0, 64, 0, 0, 0, 0 };
        check(&sf.presets[96].regions[19], &values);
    }

    // ============================================================
    //  Oboe
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 9.9982, 2, 0.5, 0, 0, 0, 127, 0, 127, 2.2, 0, 5, 0 };
        check(&sf.presets[97].regions[0], &values);
    }

    // ============================================================
    //  Doctor Solo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[98].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[98].regions[1], &values);
    }

    // ============================================================
    //  Cymbal Crash
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[99].regions[0], &values);
    }

    // ============================================================
    //  Synth Chime
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[100].regions[0], &values);
    }

    // ============================================================
    //  Synth Strings 5
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[101].regions[0], &values);
    }

    // ============================================================
    //  Synth Strings 4
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[102].regions[0], &values);
    }

    // ============================================================
    //  Clean Guitar 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 3932, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 119, 127, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3523, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 99, 108, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3217, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 78, 87, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2400, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 60, 68, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3319, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 1, 1, 1, 0, 4.9703, 0, 0, 0, 127, 0, 59, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.3503, 0, 0, 3750, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 109, 118, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 3350, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 88, 98, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2808, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 4.9703, 0, 0, 0, 127, 69, 77, 20, 0, 0, 0 };
        check(&sf.presets[103].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 2.4995, 0, 0, 0, 127, 0, 67, 0, 0, 0, 0 };
        check(&sf.presets[103].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.059989, 1, 1, 0, 2.4995, 0, 0, 0, 127, 87, 106, 5, 0, 0, 0 };
        check(&sf.presets[103].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.059989, 1, 1, 0, 2.4995, 0, 0, 0, 127, 107, 127, 5, 0, 0, 0 };
        check(&sf.presets[103].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 22, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.059989, 1, 1, 0, 2.4995, 0, 0, 0, 127, 68, 86, 5, 0, 0, 0 };
        check(&sf.presets[103].regions[11], &values);
    }

    // ============================================================
    //  Burst Noise
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[104].regions[0], &values);
    }

    // ============================================================
    //  Carillon
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.9406, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[105].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, -20, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.0099978, 0.71988, 0.0099978, 9.9982, 96, 2, 0, 84, 0, 89, 0, 127, 49, -9, 40, 0 };
        check(&sf.presets[105].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 20, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.0099978, 0.71988, 0.0099978, 9.9982, 96, 2, 0, 84, 0, 89, 0, 127, 49, 7, -43, 0 };
        check(&sf.presets[105].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, -20, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.0099978, 0.71988, 0.0099978, 9.9982, 96, 1, 0, 84, 90, 127, 0, 127, 49, -9, 40, 0 };
        check(&sf.presets[105].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 20, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.0099978, 0.71988, 0.0099978, 9.9982, 96, 1, 0, 84, 90, 127, 0, 127, 49, 7, -43, 0 };
        check(&sf.presets[105].regions[4], &values);
    }

    // ============================================================
    //  Synth Brass 4
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0.10002, 4.9991, 2, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -3, 0, 0, 0 };
        check(&sf.presets[106].regions[0], &values);
    }

    // ============================================================
    //  Synth Brass 3
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -3, 0, 0, 0 };
        check(&sf.presets[107].regions[0], &values);
    }

    // ============================================================
    //  Solar Wind 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[108].regions[0], &values);
    }

    // ============================================================
    //  Fantasia 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[109].regions[0], &values);
    }

    // ============================================================
    //  Christmas Bells
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[110].regions[0], &values);
    }

    // ============================================================
    //  Interference
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[111].regions[0], &values);
    }

    // ============================================================
    //  Doctor's Solo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[112].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[112].regions[1], &values);
    }

    // ============================================================
    //  Tinkling Bells
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[113].regions[0], &values);
    }

    // ============================================================
    //  808 Tom
    // ============================================================
    {
        const values = [_]f64{ -1200, 0, 1200, 100.02, 0, 0, 0, 0, 0, 0, -5, 0.0099978, 0.10002, 0.0099978, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, 100, 0.25, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0, 127, 0, 127, 7, 17, 0, 0 };
        check(&sf.presets[114].regions[0], &values);
    }

    // ============================================================
    //  Castanets
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[115].regions[0], &values);
    }

    // ============================================================
    //  White Noise Wave
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 0, 1, 0, 0, 0.0099978, 1, 0.0099978, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, -13, 0, 0 };
        check(&sf.presets[116].regions[0], &values);
    }

    // ============================================================
    //  Melodic Tom 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 3, 0, 0, 0 };
        check(&sf.presets[117].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 95, 111, 3, 0, 0, 0 };
        check(&sf.presets[117].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 74, 94, 3, 0, 0, 0 };
        check(&sf.presets[117].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 73, 3, 0, 0, 0 };
        check(&sf.presets[117].regions[3], &values);
    }

    // ============================================================
    //  Concert Bass Drum
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 91, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[118].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.5, 0, 0, 92, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[118].regions[1], &values);
    }

    // ============================================================
    //  Synth Bass 3
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.43003, 12, 0, 3626, 0, 7, 0, 0, 1, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.15003, 100, 0.30006, 0, 0, 0.0099978, 0.0099978, 0.0099978, 12.07, 11.6, 0.0099978, 0, 0, 0, 127, 0, 127, 11, 0, 0, 0 };
        check(&sf.presets[119].regions[0], &values);
    }

    // ============================================================
    //  Pipe Organ 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 14, 0, 1, 0.5, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[120].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 5, 14, 0, 1, 0.85018, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 100.02, 1, 1, 0, 7.0984, 0, 0, 0, 127, 0, 127, 35, 0, 6, 0 };
        check(&sf.presets[120].regions[1], &values);
    }

    // ============================================================
    //  Bell Tower
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, -6, 0, 0, 0 };
        check(&sf.presets[121].regions[0], &values);
    }

    // ============================================================
    //  Echo Pan
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 2000, 0, 7, 0, 0, 1, 1, 1, 1, 0.0099978, 3.0001, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4, 96, 1, 0, 0, 0, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[122].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 2000, 0, 7, 0, -50, 1, 1, 1, 1, 1.2002, 3.0001, 0.0099978, 1, 100, 1, 0, 0, 1.2002, 0.0099978, 0.0099978, 4, 96, 1, 0, 0, 0, 127, 0, 127, 22, 0, 0, 0 };
        check(&sf.presets[122].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.019996, 0, 0, 2000, 0, 7, 0, 50, 1, 1, 1, 1, 2.4005, 3.0001, 0.0099978, 1, 100, 1, 0, 0, 2.4005, 0.0099978, 0.0099978, 4, 96, 1, 0, 0, 0, 127, 0, 127, 32, 0, 0, 0 };
        check(&sf.presets[122].regions[2], &values);
    }

    // ============================================================
    //  Funk Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 1000, 0, 7, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 0.0099978, 1, 0, 0.20004, 0, 0, 0, 127, 87, 106, 5, 0, 0, 0 };
        check(&sf.presets[123].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 7, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 0.0099978, 1, 0, 0.20004, 0, 0, 0, 127, 107, 127, 5, 0, 0, 0 };
        check(&sf.presets[123].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 1000, 0, 7, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 0.0099978, 1, 0, 0.20004, 0, 0, 0, 127, 0, 86, 5, 0, 0, 0 };
        check(&sf.presets[123].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 4545, 0, 7, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 100, 0.0099978, 0, 0, 1, 1, 0.0099978, 3.5595, 96, 0.079983, 0, 0, 100, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[123].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.4995, 0, 0, 5500, 0, 7, 5, 0, 1, 1, 1, 1, 1, 1, 1, 3.0001, 0, 1, 0, 0, 1, 6.5018, 0.0099978, 1, 0, 0.20004, 0, 0, 0, 127, 0, 127, 5, 0, -17, 0 };
        check(&sf.presets[123].regions[4], &values);
    }

    // ============================================================
    //  Guitar Feedback
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 4600, 0, 0, 0, 0, 1, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 1, 0, 100.02, 0, 0, 0.0099978, 19.996, 1, 100.02, 96, 1, 0, 0, 0, 127, 0, 127, 10, -12, 0, 0 };
        check(&sf.presets[124].regions[0], &values);
    }

    // ============================================================
    //  Taisho Koto
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 116, 127, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.29001, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 104, 115, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20998, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 92, 103, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 80, 91, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 1, 1, 1, 0, 3.0001, 0, 0, 0, 93, 0, 79, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 5.6798, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 2, 96, 2, 0, 0, 102, 108, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[125].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 113, 127, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 99, 112, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 84, 98, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 70, 83, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 55, 69, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2000, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 4.9991, 0, 0, 1, 1, 1, 1, 0, 3.0001, 0, 0, 94, 101, 0, 54, 12, 0, 0, 0 };
        check(&sf.presets[125].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 3932, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 119, 127, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3523, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 99, 108, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3217, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 78, 87, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2400, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 60, 68, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3319, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 1, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 0, 59, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.3503, 0, 0, 3750, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 109, 118, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[17], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 3350, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 88, 98, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[18], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2808, 0, 3.5, 3.5, 0, 1, 1, 1, 0.60012, 1, 1, 1, 0.20004, 0, 1, 0, 0, 1, 0.0099978, 1, 0.5, 0, 4.9991, 0, 0, 0, 127, 69, 77, 24, 0, 0, 0 };
        check(&sf.presets[125].regions[19], &values);
    }

    // ============================================================
    //  Bird 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 596, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.20004, 100, 0.20004, 0, 0, 0.0099978, 0.5, 0.0099978, 0.30006, 96, 0.30006, 0, 0, 0, 127, 0, 127, 10, 13, 0, 0 };
        check(&sf.presets[126].regions[0], &values);
    }

    // ============================================================
    //  Car-Crash
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[127].regions[0], &values);
    }

    // ============================================================
    //  Tambourine
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[128].regions[0], &values);
    }

    // ============================================================
    //  Filter Snap
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 12, -2, 0, 0 };
        check(&sf.presets[129].regions[0], &values);
    }

    // ============================================================
    //  Sawtooth Stab
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.23005, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 1, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 104, 127, 22, 0, -6, 0 };
        check(&sf.presets[130].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 1, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 104, 127, 22, 0, 6, 0 };
        check(&sf.presets[130].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 1, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 76, 103, 22, 0, -6, 0 };
        check(&sf.presets[130].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 1, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 76, 103, 22, 0, 6, 0 };
        check(&sf.presets[130].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 1, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 0, 75, 22, 0, -6, 0 };
        check(&sf.presets[130].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 1, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 0.30006, 96, 0.30006, 0, 0, 0, 127, 0, 75, 22, 0, 6, 0 };
        check(&sf.presets[130].regions[5], &values);
    }

    // ============================================================
    //  Synth Mallet
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 18, 0, 7200, 0, 24, 14, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 51.003, 96, 29.995, 0, 0, 0, 109, 0, 127, 58, 4, -15, 0 };
        check(&sf.presets[131].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 1, 0, 0, 0, 0, 24, 14, 0, 1, 0.60012, 6.0002, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[131].regions[1], &values);
    }

    // ============================================================
    //  Square Wave
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.15003, 0, 0, 0, 127, 0, 127, 35, 0, 0, 0 };
        check(&sf.presets[132].regions[0], &values);
    }

    // ============================================================
    //  Saw Wave
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 0, 0.15003, 0, 0, 0, 127, 0, 127, 30, 0, 0, 0 };
        check(&sf.presets[133].regions[0], &values);
    }

    // ============================================================
    //  Synth Bass 101
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2.0397, 0, 0, 1100, 0, 3.5, 0, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.10002, 100, 0.10002, 0, 0, 1, 1, 1, 2, 7, 0.079983, 0, 0, 0, 56, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[134].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.4995, 0, 0, 1100, 0, 3.5, 0, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.10002, 100, 0.10002, 0, 0, 1, 1, 1, 2, 7, 0.079983, 0, 0, 57, 71, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[134].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 3.0001, 0, 0, 1100, 0, 3.5, 0, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.10002, 100, 0.10002, 0, 0, 1, 1, 1, 2, 7, 0.079983, 0, 0, 72, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[134].regions[2], &values);
    }

    // ============================================================
    //  Scratch
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, -1, 0, 0 };
        check(&sf.presets[135].regions[0], &values);
    }

    // ============================================================
    //  Birds
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 0, -50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 40, -1, 0, 0 };
        check(&sf.presets[136].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 0, 50, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 40, 1, 0, 0 };
        check(&sf.presets[136].regions[1], &values);
    }

    // ============================================================
    //  Saw Lead 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.23005, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 0.71988, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 2, 7, 0.20004, 0, 0, 0, 127, 104, 127, 28.5, 0, -6, 0 };
        check(&sf.presets[137].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 0.71988, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 1, 0, 0.20004, 0, 0, 0, 127, 104, 127, 28.5, 0, 6, 0 };
        check(&sf.presets[137].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 0.71988, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 2, 7, 0.20004, 0, 0, 0, 127, 76, 103, 28.5, 0, -6, 0 };
        check(&sf.presets[137].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 0.71988, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 1, 0, 0.20004, 0, 0, 0, 127, 76, 103, 28.5, 0, 6, 0 };
        check(&sf.presets[137].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 21, 0, 0, 1, 0.71988, 1, 0.71988, 1, 1, 1, 1, 100, 1, 0, 0, 1, 1, 1, 2, 7, 0.20004, 0, 0, 0, 127, 0, 75, 28.5, 0, -6, 0 };
        check(&sf.presets[137].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 5.2, 0, -2604, 0, 21, 0, 0, 1, 0.83993, 1, 0.71988, 1, 1.4298, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 1, 0, 0.20004, 0, 0, 0, 127, 0, 75, 28.5, 0, 6, 0 };
        check(&sf.presets[137].regions[5], &values);
    }

    // ============================================================
    //  Lasergun
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 1300, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.5, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 0, 127, 0, 127, 10, 14, 40, 0 };
        check(&sf.presets[138].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 7200, 0, 0, 0, 12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 0, 127, 0, 127, 0, -2, 40, 0 };
        check(&sf.presets[138].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 18, 0, 5464, 0, 0, 0, -12, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 1, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 96, 1, 0, 0, 0, 127, 0, 127, 0, -4, 40, 0 };
        check(&sf.presets[138].regions[2], &values);
    }

    // ============================================================
    //  Crystal
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 18, 0, 7200, 0, 24, 50, 0, 1, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 75.018, 96, 29.995, 0, 0, 0, 127, 0, 127, 10, -7, -15, 0 };
        check(&sf.presets[139].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 50, 25, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.91014, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[139].regions[1], &values);
    }

    // ============================================================
    //  Stream
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 0, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, -1, 0, 0 };
        check(&sf.presets[140].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 0, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 1, 0, 0 };
        check(&sf.presets[140].regions[1], &values);
    }

    // ============================================================
    //  Orchestral Harp
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 116, 108, 127, 15, 0, 0, 0 };
        check(&sf.presets[141].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 116, 90, 107, 15, 0, 0, 0 };
        check(&sf.presets[141].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 116, 74, 89, 15, 0, 0, 0 };
        check(&sf.presets[141].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 116, 59, 73, 15, 0, 0, 0 };
        check(&sf.presets[141].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 116, 0, 58, 15, 0, 0, 0 };
        check(&sf.presets[141].regions[4], &values);
    }

    // ============================================================
    //  Acoustic Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 42, 101, 127, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1541, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 42, 72, 100, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2861, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 42, 0, 71, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 114, 127, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 101, 113, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 87, 100, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 73, 86, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 59, 72, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.050009, 0, 0, 0, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 108, 0, 58, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, -300, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.059989, 0, 0.059989, 0, 0, 43, 60, 101, 127, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, -1750, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.059989, 0, 0.059989, 0, 0, 43, 60, 72, 100, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -3250, 0, 3, 3, 0, 1, 0.50992, 1, 0.50992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.059989, 0, 0.059989, 0, 0, 43, 60, 0, 71, 0, 0, 0, 0 };
        check(&sf.presets[142].regions[11], &values);
    }

    // ============================================================
    //  Double Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 109, 127, -1, 0, 0, 0 };
        check(&sf.presets[143].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 9.9982, 1, 1, 0, 1.2002, 0, 0, 0, 127, 89, 108, -1, 0, 0, 0 };
        check(&sf.presets[143].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 19.996, 1, 1, 0, 1.4004, 0, 0, 0, 127, 68, 88, -1, 0, 0, 0 };
        check(&sf.presets[143].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 29.995, 1, 1, 0, 1.2998, 0, 0, 0, 127, 0, 67, -1, 0, 0, 0 };
        check(&sf.presets[143].regions[3], &values);
    }

    // ============================================================
    //  Synth Drum
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 3, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[144].regions[0], &values);
    }

    // ============================================================
    //  Shamisen
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 113, 127, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.079983, 0, 0, 970, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 100, 0.0099978, 0, 0, 1, 1, 1, 0.20004, 96, 0.20004, 0, 0, 104, 127, 0, 127, 27, 0, 0, 0 };
        check(&sf.presets[145].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -400, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 107, 112, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -600, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 100, 106, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -800, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 93, 99, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1000, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 85, 92, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1200, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 78, 84, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1400, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 72, 77, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1600, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 65, 71, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1800, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 59, 64, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1.2498, 0, 1.2498, 0, 0, 0, 103, 0, 58, -5, 0, 0, 0 };
        check(&sf.presets[145].regions[10], &values);
    }

    // ============================================================
    //  Steel Drums
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[146].regions[0], &values);
    }

    // ============================================================
    //  Fl. Key Click
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[147].regions[0], &values);
    }

    // ============================================================
    //  Mandolin
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, -5, 0, 3421, 0, 0, 5, 0, 100.02, 0.60991, 1, 1, 1, 1, 1, 0.71988, 36.2, 0.71988, 0, 0, 0.0099978, 1, 1, 1, 0, 4.2599, 0, 0, 0, 127, 0, 127, 7, 0, 2, 0 };
        check(&sf.presets[148].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 11.9, 0, 2800, 0, 0, 5, 0, 100.02, 0.60991, 1, 1, 1, 1, 1, 0.20004, -68.8, 1, 0, 0, 0.40007, 0.0099978, 1, 1, 0, 4.2599, 0, 0, 0, 127, 0, 127, 0, 0, -2, 0 };
        check(&sf.presets[148].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 100.02, 0.60991, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 36.19, 1, 1, 1, 0, 1.2002, 0, 0, 0, 127, 0, 127, -10, 0, -2, 0 };
        check(&sf.presets[148].regions[2], &values);
    }

    // ============================================================
    //  Explosion
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 0, 50, 0 };
        check(&sf.presets[149].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 50, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[149].regions[1], &values);
    }

    // ============================================================
    //  Punch
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[150].regions[0], &values);
    }

    // ============================================================
    //  Ocarina
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2630, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 103, 112, 127, 12, 0, 0, 0 };
        check(&sf.presets[151].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -2000, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 2, 1, 1, 0, 1, 0, 0, 1, 14.998, 1, 1, 0, 1, 0, 0, 0, 103, 95, 111, 12, 0, 0, 0 };
        check(&sf.presets[151].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1800, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 3.0001, 1, 1, 0, 1, 0, 0, 1, 29.995, 1, 1, 0, 1, 0, 0, 0, 103, 77, 94, 12, 0, 0, 0 };
        check(&sf.presets[151].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1400, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 4, 1, 1, 0, 1, 0, 0, 1, 50.011, 1, 1, 0, 1, 0, 0, 0, 103, 0, 76, 12, 0, 0, 0 };
        check(&sf.presets[151].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 100, 0.069992, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.039991, -55, 1.5, 0, 0, 1, 0.20004, 1, 1, -96, 1, 0, 0, 104, 127, 0, 127, 0, -1, 54, 0 };
        check(&sf.presets[151].regions[4], &values);
    }

    // ============================================================
    //  Goblin
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 21, 0, 1, 1, 1, 1, 0.0099978, 0.20004, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -3, 0, 0, 0 };
        check(&sf.presets[152].regions[0], &values);
    }

    // ============================================================
    //  Percussive Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 3, 0, 1, 4.9991, 1, 1.2998, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[153].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 4.9991, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 1, 0, 0, 0 };
        check(&sf.presets[153].regions[1], &values);
    }

    // ============================================================
    //  Gun Shot
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, -2, 0, 0 };
        check(&sf.presets[154].regions[0], &values);
    }

    // ============================================================
    //  Starship
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[155].regions[0], &values);
    }

    // ============================================================
    //  Jet Plane
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[156].regions[0], &values);
    }

    // ============================================================
    //  Train
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 25, 0, 0, 0 };
        check(&sf.presets[157].regions[0], &values);
    }

    // ============================================================
    //  Footsteps
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7.1, 0, 0, 0 };
        check(&sf.presets[158].regions[0], &values);
    }

    // ============================================================
    //  Siren
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.64992, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[159].regions[0], &values);
    }

    // ============================================================
    //  Windchime
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[160].regions[0], &values);
    }

    // ============================================================
    //  Bubbles
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[161].regions[0], &values);
    }

    // ============================================================
    //  Heart Beat
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[162].regions[0], &values);
    }

    // ============================================================
    //  Car-Pass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[163].regions[0], &values);
    }

    // ============================================================
    //  Door
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, -96, 100.02, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[164].regions[0], &values);
    }

    // ============================================================
    //  Scream
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[165].regions[0], &values);
    }

    // ============================================================
    //  Car-Stop
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 4, 0, 0, 0 };
        check(&sf.presets[166].regions[0], &values);
    }

    // ============================================================
    //  Door Creaking
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[167].regions[0], &values);
    }

    // ============================================================
    //  Horse Gallop
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0.0099978, 4.9991, 1, 1, 0, 3.0001, 0, 0, 0, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[168].regions[0], &values);
    }

    // ============================================================
    //  Thunder
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 250, 0, 7, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[169].regions[0], &values);
    }

    // ============================================================
    //  String Slap
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[170].regions[0], &values);
    }

    // ============================================================
    //  Machine Gun
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 6, 0, 0, 0 };
        check(&sf.presets[171].regions[0], &values);
    }

    // ============================================================
    //  Laughing
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[172].regions[0], &values);
    }

    // ============================================================
    //  Car-Engine
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[173].regions[0], &values);
    }

    // ============================================================
    //  Telephone 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[174].regions[0], &values);
    }

    // ============================================================
    //  Dog
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[175].regions[0], &values);
    }

    // ============================================================
    //  Rain
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3.5, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 0, 127, 0, 127, 10, -1, 0, 0 };
        check(&sf.presets[176].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 3.5, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 0, 3.0001, 0, 0, 0, 127, 0, 127, 10, 3, 0, 0 };
        check(&sf.presets[176].regions[1], &values);
    }

    // ============================================================
    //  Cut Noise
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[177].regions[0], &values);
    }

    // ============================================================
    //  Concert Choir Mono
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.33007, 1, 1, 0, 0.80014, 0, 0, 0, 127, 113, 127, 3, 0, 10, 0 };
        check(&sf.presets[178].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.60012, 1, 1, 0, 1, 0, 0, 0, 127, 94, 112, 3, 0, 10, 0 };
        check(&sf.presets[178].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.90021, 1, 1, 0, 1.2002, 0, 0, 0, 127, 72, 93, 3, 0, 10, 0 };
        check(&sf.presets[178].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1.5, 1, 1, 0, 1.4004, 0, 0, 0, 127, 0, 71, 3, 0, 10, 0 };
        check(&sf.presets[178].regions[3], &values);
    }

    // ============================================================
    //  Electric Grand
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1.5, 0, 0, 0, 127, 0, 50, 7, 0, 0, 0 };
        check(&sf.presets[179].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1.5, 0, 0, 0, 127, 51, 69, 7, 0, 0, 0 };
        check(&sf.presets[179].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1.5, 0, 0, 0, 127, 70, 86, 7, 0, 0, 0 };
        check(&sf.presets[179].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1.5, 0, 0, 0, 127, 87, 106, 7, 0, 0, 0 };
        check(&sf.presets[179].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 96, 1.5, 0, 0, 0, 127, 107, 127, 7, 0, 0, 0 };
        check(&sf.presets[179].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 6.0002, 0, 0, 0, 0, 7, 3, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 0.10002, -100, 100.02, 0, 68, 1, 1, 1, 0.10002, 0, 0.20004, 0, 0, 0, 127, 0, 75, 15, 0, 0, 0 };
        check(&sf.presets[179].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 4, 5, 0, 0, 0, 7, 3, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 0.10002, -100, 100.02, 0, 68, 1, 0.0099978, 1, 0.10002, 0, 0.20004, 0, 0, 0, 127, 76, 91, 10, 0, 0, 0 };
        check(&sf.presets[179].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 4.9991, 10, 0, 0, 0, 7, 3, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 0.10002, -100, 100.02, 0, 68, 1, 0.0099978, 1, 0.10002, 0, 0.20004, 0, 0, 0, 127, 92, 108, 5, 0, 0, 0 };
        check(&sf.presets[179].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 7.0984, 96, 0, 0, 0, 7, 3, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 0.10002, -100, 100.02, 0, 68, 1, 0.0099978, 1, 0.10002, 0, 0.20004, 0, 0, 0, 127, 109, 127, 0, 0, 0, 0 };
        check(&sf.presets[179].regions[8], &values);
    }

    // ============================================================
    //  Harmonica
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, -250, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 2, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[180].regions[0], &values);
    }

    // ============================================================
    //  Celeste
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -2, 0, 0, 0 };
        check(&sf.presets[181].regions[0], &values);
    }

    // ============================================================
    //  Solo Vox
    // ============================================================
    {
        const values = [_]f64{ 0, 20, -200, 1, 0, 0, 0, 0, 5, 5, 10, 1, 0.60991, 0.0099978, 0.7002, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 100, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1.4298, 0, 0, 0, 127, 0, 127, 17, 0, -2, 0 };
        check(&sf.presets[182].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 20, 0, 0.80014, 0, 0, 2298, 0, 5, 5, -10, 1, 0.60991, 0.0099978, 0.7002, 0.0099978, 0.0099978, 0.0099978, 0.5, 100, 0.0099978, 0, 0, 0.0099978, 0.30006, 0.0099978, 0.0099978, 0, 1.4298, 0, 0, 0, 127, 0, 127, 17, 0, 2, 0 };
        check(&sf.presets[182].regions[1], &values);
    }

    // ============================================================
    //  Vibraphone
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 114, 127, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 101, 113, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 88, 100, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 75, 87, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 62, 74, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 48, 61, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.050009, 0, 0, 0, 2, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 0.60012, 0, 0, 0, 127, 0, 47, 20, 0, 0, 0 };
        check(&sf.presets[183].regions[6], &values);
    }

    // ============================================================
    //  Xylophone
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.029994, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 0, 51, -8, 0, -21, 0 };
        check(&sf.presets[184].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.059989, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 52, 66, -6, 0, -21, 0 };
        check(&sf.presets[184].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.089985, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 67, 82, -4, 0, -21, 0 };
        check(&sf.presets[184].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 83, 96, -2, 0, -21, 0 };
        check(&sf.presets[184].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 97, 111, -1, 0, -21, 0 };
        check(&sf.presets[184].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 112, 127, 0, 0, -21, 0 };
        check(&sf.presets[184].regions[5], &values);
    }

    // ============================================================
    //  Clavinet
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.27997, 0, 0, -800, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.67012, 0, 0, -200, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, -1000, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.4501, 0, 0, -500, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 43, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, -800, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, -200, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, -1000, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, -500, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 44, 61, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[11], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[12], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[185].regions[13], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.31993, 0, 0, -800, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[14], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.72993, 0, 0, -200, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 82, 106, -4, 0, 0, 0 };
        check(&sf.presets[185].regions[15], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.23995, 0, 0, -1000, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[16], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, -500, 0, 7, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 62, 127, 0, 81, -8, 0, 0, 0 };
        check(&sf.presets[185].regions[17], &values);
    }

    // ============================================================
    //  Trumpet 2
    // ============================================================
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 81, 109, 127, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -600, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 0, 81, 89, 108, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 0, 81, 68, 88, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -2000, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -20, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 81, 0, 67, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 4400, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -20, 1, 0, 0, 1, 0.089985, 1, 1, 0, 1, 0, 0, 82, 127, 109, 127, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 0, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -40, 1, 0, 0, 1, 0.10002, 1, 1, 0, 1, 0, 0, 82, 127, 89, 108, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 0.7002, 0, 0, -500, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 0.0099978, 1, 0.7002, -50, 1, 0, 0, 1, 0.30006, 1, 1, 0, 1, 0, 0, 82, 127, 68, 88, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, -1000, 0, 0, 7, 0, 0.0099978, 0.60012, 0.60012, 0.5, 1, 17.03, 1, 0.7002, -50, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 82, 127, 0, 67, -1, 0, 0, 0 };
        check(&sf.presets[186].regions[7], &values);
    }

    // ============================================================
    //  Slap Bass 1
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4000, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.67012, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 0.20004, 0, 0, 0, 127, 113, 127, 0, 12, 5, 0 };
        check(&sf.presets[187].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.67012, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 0.20004, 0, 0, 0, 127, 98, 112, 0, 12, 5, 0 };
        check(&sf.presets[187].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2500, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.67012, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 0.20004, 0, 0, 0, 127, 84, 97, 0, 12, 5, 0 };
        check(&sf.presets[187].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2000, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.67012, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 0.20004, 0, 0, 0, 127, 69, 83, 0, 12, 5, 0 };
        check(&sf.presets[187].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1500, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.67012, 0, 1, 0, 0, 1, 1, 1, 0.7002, 0, 0.20004, 0, 0, 0, 127, 0, 68, 0, 12, 5, 0 };
        check(&sf.presets[187].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1398, 0, 0, 2500, 0, 5, 3, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.029994, 85.8, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4, 100, 0.20004, 0, 0, 85, 127, 0, 127, 20, 0, 3, 0 };
        check(&sf.presets[187].regions[5], &values);
    }

    // ============================================================
    //  Jazz Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4000, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, -30, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 0, 127, 90, 127, 0, 0, 0, 0 };
        check(&sf.presets[188].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 3700, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, -30, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 0, 127, 75, 89, 0, 0, 0, 0 };
        check(&sf.presets[188].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 0, 0, 3600, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, -30, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 0, 127, 60, 74, 0, 0, 0, 0 };
        check(&sf.presets[188].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 3500, 0, 5, 5, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.25, -30, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 0, 127, 0, 59, 0, 0, 0, 0 };
        check(&sf.presets[188].regions[3], &values);
    }

    // ============================================================
    //  Synth Voice
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 0.60012, 1, 0.60012, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[189].regions[0], &values);
    }

    // ============================================================
    //  Koto
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 116, 127, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.29001, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 104, 115, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20998, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 92, 103, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 0, 93, 80, 91, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 1, 1, 1, 0, 3.0001, 0, 0, 0, 93, 0, 79, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 5.6798, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 2, 96, 2, 0, 0, 102, 108, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[190].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 113, 127, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 99, 112, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[7], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 84, 98, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[8], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 70, 83, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[9], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 9.9982, 0, 0, 1, 0.0099978, 1, 1, 0, 3.0001, 0, 0, 94, 101, 55, 69, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[10], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2000, 0, 0, 5, 0, 1, 1, 1, 0.55, 1, 1, 1, 1, 0, 4.9991, 0, 0, 1, 1, 1, 1, 0, 3.0001, 0, 0, 94, 101, 0, 54, 8, 0, 0, 0 };
        check(&sf.presets[190].regions[11], &values);
    }

    // ============================================================
    //  Banjo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 101, 113, 127, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 101, 99, 112, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 101, 84, 98, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 101, 70, 83, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.16997, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 101, 55, 69, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2000, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 1, 1, 1, 1, 0, 4.9991, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 101, 0, 54, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 5.6798, 0, 0, 0, 0, 0, 5, 0, 1, 0.55, 1, 0.55, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4, 96, 4, 0, 0, 102, 108, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[191].regions[6], &values);
    }

    // ============================================================
    //  Bandoneon
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.7002, 0, 0, 0, 127, 0, 127, 14, 0, -4, 0 };
        check(&sf.presets[192].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 8, 0, 600, 0, 3, 5, 0, 1, 1, 1, 1, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 1, 0.30006, 1, 1, 0, 0.7002, 0, 0, 0, 127, 0, 127, 14, 0, 4, 0 };
        check(&sf.presets[192].regions[1], &values);
    }

    // ============================================================
    //  Accordian
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 21, 5, 0, 1, 1, 1, 1, 1, 0.0099978, 1, 1, 0, 100.02, 0, 0, 1, 0.0099978, 1, 1, 6, 0.5, 0, 0, 0, 127, 0, 127, 6, 0, -4, 0 };
        check(&sf.presets[193].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 21, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 0.60012, 1, 0.5, 6, 0.5, 0, 0, 0, 127, 103, 127, 6, 12, 4, 0 };
        check(&sf.presets[193].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 21, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 0.5, 0, 0.5, 0, 0, 0, 127, 77, 102, 16, 12, 4, 0 };
        check(&sf.presets[193].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 21, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 2, 1, 0.5, 0, 0.5, 0, 0, 0, 127, 0, 76, 16, 12, 4, 0 };
        check(&sf.presets[193].regions[3], &values);
    }

    // ============================================================
    //  Italian Accordian
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 17, 0, -6, 0 };
        check(&sf.presets[194].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 3.5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 17, 0, 6, 0 };
        check(&sf.presets[194].regions[1], &values);
    }

    // ============================================================
    //  Orchestra Hit
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 7, 0, 1, 0.80014, 1, 0.80014, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 105, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[195].regions[0], &values);
    }

    // ============================================================
    //  Timpani
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, -3, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -12, 0, 0, 0 };
        check(&sf.presets[196].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[196].regions[1], &values);
    }

    // ============================================================
    //  Rock Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 22, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -3, 0, 0, 0 };
        check(&sf.presets[197].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 26, 0, 0, 0 };
        check(&sf.presets[197].regions[1], &values);
    }

    // ============================================================
    //  Trombone 2
    // ============================================================
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60991, 9.0005, 0.60991, 0.0099978, 0.0099978, 0.0099978, 9.9982, 77.3, 2, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 127, 107, 127, -2, 0, 0, 0 };
        check(&sf.presets[198].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.050009, 0, 0, 2706, 0, 0, 7, 0, 1, 0.60991, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 100, 2, 0, 0, 0.0099978, 0.15003, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 127, 82, 106, -2, 0, 0, 0 };
        check(&sf.presets[198].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 0.029994, 0, 0, 2706, 0, 0, 7, 0, 1, 0.60991, 9.0005, 0.60991, 0.0099978, 0.0099978, 2.8497, 7.8083, 61.7, 2, 0, 0, 0.0099978, 0.30006, 0.0099978, 0.0099978, 0, 1, 0, 0, 0, 127, 0, 81, -2, 0, 0, 0 };
        check(&sf.presets[198].regions[2], &values);
    }

    // ============================================================
    //  Shakuhachi
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.11998, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 83, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[199].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, -1000, 0, 0, 7, 0, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 84, 96, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[199].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 83, 0.15003, 0, 0, 1500, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 0.0099978, 1, 0.0099978, 100, 0.0099978, 0, 0, 1, 0.0099978, 1, 2.1398, 8.9, 4.2599, 0, 0, 97, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[199].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 0.0099978, 1, 0.0099978, 0, 1.2002, 0, 0, 97, 127, 0, 127, 50, 0, 0, 0 };
        check(&sf.presets[199].regions[3], &values);
    }

    // ============================================================
    //  Irish Tin Whistle
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 4, -5, 1, 0, 0, 0, 127, 109, 127, 3, 0, -34, 0 };
        check(&sf.presets[200].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 4, -5, 1, 0, 0, 0, 127, 92, 108, 3, 0, -34, 0 };
        check(&sf.presets[200].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 4, -5, 1, 0, 0, 0, 127, 74, 91, 3, 0, -34, 0 };
        check(&sf.presets[200].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.5002, 1, 4, -5, 1, 0, 0, 0, 127, 56, 73, 3, 0, -34, 0 };
        check(&sf.presets[200].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 4, -5, 1, 0, 0, 0, 127, 0, 55, 3, 0, -34, 0 };
        check(&sf.presets[200].regions[4], &values);
    }

    // ============================================================
    //  Bottle Blow
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 90, 0, 127, 22, 0, 0, 0 };
        check(&sf.presets[201].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 0.0099978, 1, 0.0099978, 100, 0.0099978, 0, 0, 1, 0.71988, 1, 0.0099978, 0, 4.2599, 0, 0, 91, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[201].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 100.02, 0, 0, 1, 0.71988, 1, 0.0099978, 0, 1, 0, 0, 91, 127, 0, 127, 70, 0, 0, 0 };
        check(&sf.presets[201].regions[2], &values);
    }

    // ============================================================
    //  Pan Flute
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 111, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[202].regions[0], &values);
    }

    // ============================================================
    //  English Horn
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.80014, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 112, 0, 127, 3, 0, -3, 0 };
        check(&sf.presets[203].regions[0], &values);
    }

    // ============================================================
    //  Bassoon
    // ============================================================
    {
        const values = [_]f64{ 0, 12, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 1, 0, 0, 0, 102, 0, 127, 8, 0, -3, 0 };
        check(&sf.presets[204].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 12, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 6.0002, 1, 1, 0, 0.80014, 0, 0, 103, 127, 0, 127, 8, 0, -3, 0 };
        check(&sf.presets[204].regions[1], &values);
    }

    // ============================================================
    //  Viola
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1000, 0, 0, 7, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.15997, 1, 1, 0, 0.75002, 0, 0, 0, 127, 117, 127, 7, 0, 0, 0 };
        check(&sf.presets[205].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 7, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.27997, 1, 1, 0, 0.75002, 0, 0, 0, 127, 104, 116, 7, 0, 0, 0 };
        check(&sf.presets[205].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 7, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 0.75002, 0, 0, 0, 127, 90, 103, 7, 0, 0, 0 };
        check(&sf.presets[205].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 7, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.75002, 1, 1, 0, 0.75002, 0, 0, 0, 127, 75, 89, 7, 0, 0, 0 };
        check(&sf.presets[205].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 0, 7, 0, 1, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0.75002, 0, 0, 0, 127, 0, 74, 7, 0, 0, 0 };
        check(&sf.presets[205].regions[4], &values);
    }

    // ============================================================
    //  Fretless Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 92, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[206].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.13001, 0, 0, 2298, 0, 5, 3, 0, 1, 0.60012, 1, 1, 1, 1, 1, 100.02, 100, 66.679, 0, 0, 1, 6.7505, 1, 0.40007, 96, 0.15003, 0, 0, 93, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[206].regions[1], &values);
    }

    // ============================================================
    //  Tonewheel Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 9.9982, 0, 0, 0, 0, 22, 3, 0, 1, 0.85018, 1, 0.85018, 1, 1, 1, 1, -36, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[207].regions[0], &values);
    }

    // ============================================================
    //  Star Theme
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 7, 0, 255, 0, 7, 21, 0, 1, 0.55, 1, 0.55, 0.0099978, 0.0099978, 0.0099978, 0.20004, 25, 1, 0, 0, 1, 0.5, 1, 1, 0, 2, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[208].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 20, 0, 0.0099978, 5, 0, 7200, 0, 64, 21, 0, 1, 1, 1, 1, 1, 1, 1, 39.012, -100, 100.02, 0, 0, 1, 12.07, 1, 1, -96, 9.0005, 0, 0, 0, 52, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[208].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 20, 0, 0.0099978, 5, 0, 7200, 0, 64, 21, 0, 1, 1, 1, 1, 1, 1, 1, 7.8083, 25, 100.02, 0, 0, 1, 12.07, 1, 1, -96, 9.0005, 0, 0, 58, 125, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[208].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 20, 0, 0.0099978, 5, 0, 5500, 0, 64, 21, 0, 1, 1, 1, 1, 1, 1, 1, 39.012, -100, 100.02, 0, 0, 1, 12.07, 1, 1, -96, 9.0005, 0, 0, 53, 57, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[208].regions[3], &values);
    }

    // ============================================================
    //  Soundtrack
    // ============================================================
    {
        const values = [_]f64{ 0, 0, -2400, 0.20004, 11, 200, 3150, 0, 14, 14, 30, 0.30006, 0.10002, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 9.9982, 13, 100.02, 0, 0, 0.0099978, 2, 0.0099978, 0.0099978, 0, 21.996, 0, 0, 0, 89, 0, 127, 0, 27, 87, 0 };
        check(&sf.presets[209].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.39003, 11, 0, 2094, 0, 14, 14, -30, 1, 0.20004, 1, 0.60012, 0.0099978, 17.743, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 3.0001, 0.0099978, 0.0099978, 0, 29.995, 0, 0, 0, 108, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[209].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.39003, 11, 0, 1800, 0, 14, 14, -30, 1, 0.20004, 1, 0.60012, 0.0099978, 17.743, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 2.2, 0.0099978, 0.0099978, 0, 25.005, 0, 0, 90, 101, 0, 127, 0, 7, 0, 0 };
        check(&sf.presets[209].regions[2], &values);
    }

    // ============================================================
    //  Sweep Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, -1000, 7000, 0, 7, 7, 30, 3.4007, 0.019996, 1, 0.60012, 1, 14.998, 0.0099978, 0.0099978, 0, 50.359, 0, 0, 0.0099978, 1, 0.0099978, 0.0099978, 0, 69.511, 0, 0, 0, 108, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[210].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, 5250, 0, 7, 7, -30, 1, 0.60012, 1, 0.60012, 0.0099978, 19.996, 0.0099978, 0.0099978, 0, 47.532, 0, 0, 0.0099978, 9.9982, 0.0099978, 0.0099978, 0, 73.051, 0, 0, 0, 108, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[210].regions[1], &values);
    }

    // ============================================================
    //  Bowed Glass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 500, 0, 32, 32, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 4, 0.0099978, 50.011, 96, 50.011, 0, 0, 0, 127, 0, 127, 12, -12, 0, 0 };
        check(&sf.presets[211].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 12, 7, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 8, 0.0099978, 29.995, 16, 59.991, 0, 0, 0, 50, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[211].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 1250, 0, 12, 7, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 8, 0.0099978, 29.995, 16, 59.991, 0, 0, 51, 63, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[211].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 2000, 0, 12, 7, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 8, 0.0099978, 29.995, 16, 59.991, 0, 0, 64, 76, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[211].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 2250, 0, 12, 7, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 8, 0.0099978, 29.995, 16, 59.991, 0, 0, 77, 89, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[211].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 3000, 0, 12, 7, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 8, 0.0099978, 29.995, 16, 59.991, 0, 0, 90, 108, 0, 127, 2, 0, 0, 0 };
        check(&sf.presets[211].regions[5], &values);
    }

    // ============================================================
    //  Polysynth
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 300, 0.20004, 0, 2000, 3000, 0, 7, 5, -7, 1, 0.019996, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.30006, 100, 0.0099978, 0, 0, 0.0099978, 0.40007, 0.0099978, 29.995, 12, 12, 0, 0, 0, 108, 0, 127, 0, 0, 4, 0 };
        check(&sf.presets[212].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 25, 0.20004, 0, -2000, 2000, 0, 7, 5, 7, 1, 0.019996, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 9.9982, 100, 6.0002, 0, 0, 0.0099978, 0.079983, 0.0099978, 48.224, 0, 12, 0, 0, 0, 108, 0, 127, 20, 0, -4, 0 };
        check(&sf.presets[212].regions[1], &values);
    }

    // ============================================================
    //  Steel Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1.5, 0, 0, 3932, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 113, 127, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.3503, 0, 0, 3750, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 99, 112, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.2002, 0, 0, 3523, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 86, 98, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1.1, 0, 0, 3350, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -10, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 72, 85, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3217, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -20, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 58, 71, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2808, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -30, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 45, 57, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2400, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 0.40007, -40, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1.2998, 0, 0, 0, 127, 0, 44, 15, 0, 0, 0 };
        check(&sf.presets[213].regions[6], &values);
    }

    // ============================================================
    //  Hawaiian Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 7.8, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[214].regions[0], &values);
    }

    // ============================================================
    //  Sitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 96, 0, 127, 0, 0, -60, 0 };
        check(&sf.presets[215].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 5.6798, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 7.8083, 96, 7.8083, 0, 0, 97, 108, 0, 127, 4, 0, 0, 0 };
        check(&sf.presets[215].regions[1], &values);
    }

    // ============================================================
    //  Sine Wave
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.30006, 0, 0, 0, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[216].regions[0], &values);
    }

    // ============================================================
    //  Muted Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3500, 0, 7, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 0, 0.80014, 0, 0, 0, 118, 106, 127, 0, 0, 0, 0 };
        check(&sf.presets[217].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2700, 0, 7, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.63986, 0, 0.63986, 0, 0, 0, 118, 86, 105, 0, 0, 0, 0 };
        check(&sf.presets[217].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1900, 0, 7, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.47991, 0, 0.47991, 0, 0, 0, 118, 70, 85, 0, 0, 0, 0 };
        check(&sf.presets[217].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1100, 0, 7, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.31993, 0, 0.31993, 0, 0, 0, 118, 54, 69, 0, 0, 0, 0 };
        check(&sf.presets[217].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 300, 0, 7, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15997, 0, 0.15997, 0, 0, 0, 118, 0, 53, 0, 0, 0, 0 };
        check(&sf.presets[217].regions[4], &values);
    }

    // ============================================================
    //  Nylon Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 100.02, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 105, 93, 127, 10, 0, 0, 0 };
        check(&sf.presets[218].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 100.02, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 105, 69, 92, 10, 0, 0, 0 };
        check(&sf.presets[218].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 5, 0, 100.02, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 105, 47, 68, 10, 0, 0, 0 };
        check(&sf.presets[218].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 5, 0, 100.02, 0.64992, 1, 0.64992, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.2002, 0, 0, 0, 105, 0, 46, 10, 0, 0, 0 };
        check(&sf.presets[218].regions[3], &values);
    }

    // ============================================================
    //  Church Bells
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 21, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0.0099978, 8, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[219].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 21, -25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 2, 0.0099978, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, -5, 0, 3, 0 };
        check(&sf.presets[219].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3.5, 21, 25, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 8, 0.0099978, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, -5, 0, -2, 0 };
        check(&sf.presets[219].regions[2], &values);
    }

    // ============================================================
    //  Applause
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 12, -30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, -2, 0, -40 };
        check(&sf.presets[220].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 12, 30, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 2, 0, -40 };
        check(&sf.presets[220].regions[1], &values);
    }

    // ============================================================
    //  Telephone 1
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[221].regions[0], &values);
    }

    // ============================================================
    //  Seashore
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[222].regions[0], &values);
    }

    // ============================================================
    //  Atmosphere
    // ============================================================
    {
        const values = [_]f64{ 0, 21, 0, 0.0099978, 7, 0, 7200, 0, 28, 21, 0, 1, 0.55994, 0.5, 0.60012, 0.0099978, 0.0099978, 0.0099978, 36.886, 50.4, 26.955, 0, 0, 0.0099978, 0.60012, 0.5, 1, -90, 9.9982, 0, 0, 0, 105, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[223].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 7.3, 0, -1000, 0, 7, 21, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.80014, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1.6003, 0, 0, 0, 127, 0, 127, 12, 0, 0, 0 };
        check(&sf.presets[223].regions[1], &values);
    }

    // ============================================================
    //  Chiffer Lead
    // ============================================================
    {
        const values = [_]f64{ 0, 0, -200, 0.22004, 4, 0, 3000, 0, 7, 5, 0, 0.0099978, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.4501, 100, 0.0099978, 0, 0, 0.0099978, 0.20004, 0.0099978, 9.2322, 4, 2.4995, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[224].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 400, 0.15003, 0, 0, 5668, 0, 7, 5, 0, 1, 1, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 100, 0.0099978, 0, 0, 0.0099978, 1, 0.0099978, 21.996, 8, 0.4099, 0, 0, 0, 99, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[224].regions[1], &values);
    }

    // ============================================================
    //  5th Saw Wave
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 4000, 0, 5, 5, 20, 1, 1, 1, 0.60991, 1, 0.0099978, 1, 75.192, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 0, 9.9982, 0, 0, 0, 127, 0, 127, 14, 0, 0, 0 };
        check(&sf.presets[225].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 4000, 0, 5, 5, -20, 1, 1, 1, 0.60991, 1, 0.0099978, 1, 75.192, 100, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 1, 0, 9.9982, 0, 0, 0, 127, 0, 127, 14, -5, 0, 0 };
        check(&sf.presets[225].regions[1], &values);
    }

    // ============================================================
    //  Synth Calliope
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4200, 0, 5, 5, -5, 1, 1, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 88, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[226].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.079983, 0, 0, 6000, 0, 5, 5, 10, 1, 1, 1, 0.60012, 1, 1, 1, 50.011, 100, 1, 0, 0, 1, 6.3901, 1, 1, 0, 1, 0, 0, 0, 87, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[226].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 83, 0.10002, 0, 0, 4000, 0, 5, 5, 10, 1, 1, 1, 0.60012, 1, 0.0099978, 1, 0.0099978, 100, 0.0099978, 0, 0, 1, 0.3501, 1, 2.1398, 8.9, 4.2599, 0, 0, 96, 127, 0, 127, 20, 0, -5, 0 };
        check(&sf.presets[226].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, 4340, 0, 5, 5, -5, 1, 1, 1, 0.60012, 1, 1, 1, 50.011, 40, 1, 0, 0, 1, 1, 1, 1, -55.1, 1, 0, 0, 72, 87, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[226].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, 4340, 0, 5, 5, -5, 1, 1, 1, 0.60012, 1, 1, 1, 50.011, 48.9, 1, 0, 0, 1, 1, 1, 1, -55.1, 1, 0, 0, 0, 71, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[226].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.029994, 0, 0, 4000, 0, 5, 5, 10, 1, 1, 1, 0.60012, 1, 1, 1, 100.02, 53.2, 1, 0, 0, 1, 6.3901, 1, 1, 0, 1, 0, 0, 88, 95, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[226].regions[5], &values);
    }

    // ============================================================
    //  Clarinet
    // ============================================================
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 111, 127, 9, 0, 0, 0 };
        check(&sf.presets[227].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 0, 1, 0, 0, 0, 127, 94, 110, 9, 0, 0, 0 };
        check(&sf.presets[227].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4, 1, 1, 0, 1, 0, 0, 0, 127, 77, 93, 9, 0, 0, 0 };
        check(&sf.presets[227].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.0007, 1, 1, 0, 1, 0, 0, 0, 127, 59, 76, 9, 0, 0, 0 };
        check(&sf.presets[227].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.4501, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 10.998, 1, 1, 0, 1, 0, 0, 0, 127, 0, 58, 9, 0, 0, 0 };
        check(&sf.presets[227].regions[4], &values);
    }

    // ============================================================
    //  Recorder
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 0.5, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 105, 0, 127, 15, 0, -8, 0 };
        check(&sf.presets[228].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 5, 0, 0.15003, 0, 0, 0, 0, 0, 7, 0, 1, 0.55, 0.5, 0.55, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 106, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[228].regions[1], &values);
    }

    // ============================================================
    //  Tenor Sax
    // ============================================================
    {
        const values = [_]f64{ 0, 10, 0, 0.089985, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 0.40007, 1.5, 0.0099978, 0.0099978, 0.0099978, 0.90021, 100, 0.0099978, 0, 0, 1, 1, 1, 21.996, 6, 0.5, 0, 0, 0, 99, 108, 127, 2, 0, 0, 0 };
        check(&sf.presets[229].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 0.069992, 0, 0, 2000, 0, 0, 7, 0, 1, 1, 0.40007, 1.5, 0.0099978, 0.0099978, 0.0099978, 1.4298, 100, 0.0099978, 0, 0, 1, 1, 1, 21.996, 6, 0.5, 0, 0, 0, 99, 88, 107, 2, 0, 0, 0 };
        check(&sf.presets[229].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 0.050009, 0, 0, 1500, 0, 0, 7, 0, 1, 1, 0.40007, 1.5, 0.0099978, 7.0984, 0.0099978, 2, 100, 0.0099978, 0, 0, 1, 1, 1, 21.996, 6, 0.5, 0, 0, 0, 99, 69, 87, 2, 0, 0, 0 };
        check(&sf.presets[229].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 0.029994, 0, 0, 1500, 0, 0, 7, 0, 1, 1, 0.40007, 1.5, 0.0099978, 81.572, 0.0099978, 3.0001, 100, 0.0099978, 0, 0, 1, 1, 1, 21.996, 6, 0.5, 0, 0, 0, 99, 0, 68, 2, 0, 0, 0 };
        check(&sf.presets[229].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 10, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 0.40007, 0.7002, 1, 1, 1, 1, 0, 0.0099978, 0, 0, 1, 1, 1, 21.996, 6, 1, 0, 0, 100, 127, 0, 127, 8, 0, 7, 0 };
        check(&sf.presets[229].regions[4], &values);
    }

    // ============================================================
    //  Soprano Sax
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 17.743, 6, 1, 0, 0, 0, 127, 0, 127, 10, 0, 5, 0 };
        check(&sf.presets[230].regions[0], &values);
    }

    // ============================================================
    //  Piccolo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 1, 0, 7, 0 };
        check(&sf.presets[231].regions[0], &values);
    }

    // ============================================================
    //  Tuba
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 0.60012, 1, 1.1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 83, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[232].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -1000, 0, 0, 7, 0, 0.0099978, 0.60012, 1, 1, 1, 1, 1, 0.7002, 0, 1, 0, 0, 1, 1, 1, 1, -96, 2, 0, 0, 84, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[232].regions[1], &values);
    }

    // ============================================================
    //  Muted Trumpet 2
    // ============================================================
    {
        const values = [_]f64{ 0, 14, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 0.60012, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 96, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[233].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 7200, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 0.7002, -100, 1, 0, 0, 1, 1, 1, 1, -96, 1, 0, 0, 97, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[233].regions[1], &values);
    }

    // ============================================================
    //  Pizzicato Strings
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 112, 0, 127, -1, 0, 5, 0 };
        check(&sf.presets[234].regions[0], &values);
    }

    // ============================================================
    //  Pipe Organ
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 14, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -11, 0, 0, 0 };
        check(&sf.presets[235].regions[0], &values);
    }

    // ============================================================
    //  Brass Section Mono
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1081, 0, 5, 7, 0, 1, 0.5, 1, 0.5, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 5, 0 };
        check(&sf.presets[236].regions[0], &values);
    }

    // ============================================================
    //  Pick Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 5000, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 106, 127, 3, 0, 0, 0 };
        check(&sf.presets[237].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 4200, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 92, 105, 3, 0, 0, 0 };
        check(&sf.presets[237].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3400, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 77, 91, 3, 0, 0, 0 };
        check(&sf.presets[237].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 2600, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 62, 76, 3, 0, 0, 0 };
        check(&sf.presets[237].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 1800, 0, 5, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 61, 3, 0, 0, 0 };
        check(&sf.presets[237].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 5, 3, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 1, 1, 0, 1, 0, 0, 0.0099978, 0.20004, 0.0099978, 8, 100, 0.5, 0, 84, 0, 127, 0, 127, 26, 0, 0, 0 };
        check(&sf.presets[237].regions[5], &values);
    }

    // ============================================================
    //  Finger Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 5, 3, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 92, 104, 127, 0, 0, 0, 0 };
        check(&sf.presets[238].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 1.5, 0, 0, 0, 5, 3, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 92, 82, 103, 0, 0, 0, 0 };
        check(&sf.presets[238].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 3, 0, 0, 0, 5, 3, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 92, 60, 81, 0, 0, 0, 0 };
        check(&sf.presets[238].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 4.5, 0, 0, 0, 5, 3, 0, 0.0099978, 1, 0.0099978, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 92, 0, 59, 0, 0, 0, 0 };
        check(&sf.presets[238].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.069992, 0, 0, 970, 0, 5, 3, 0, 0.0099978, 0.60012, 0.0099978, 0.60012, 1, 1, 1, 1, 100, 0.0099978, 0, 0, 1, 1, 1, 3.5595, 96, 0.079983, 0, 0, 93, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[238].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 0, 0, 5, 3, 0, 0.0099978, 1, 0.0099978, 1, 0.0099978, 0.0099978, 1, 1, 0, 1, 0, 0, 0.0099978, 0.10002, 0.0099978, 8, 100, 0.5, 0, 84, 0, 92, 0, 127, 20, 0, 0, 0 };
        check(&sf.presets[238].regions[5], &values);
    }

    // ============================================================
    //  Dulcimer
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0.5, 0.5, 0, 1, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[239].regions[0], &values);
    }

    // ============================================================
    //  Synth Strings 2
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 4000, 1, 5, 0, 0, 0, 14, 14, 100, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 100, 1, 0, 0, 1.5, 1, 1, 1, 0, 2, 0, 0, 0, 116, 0, 127, 23, 0, 4, 0 };
        check(&sf.presets[240].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 7200, 0, 14, 14, -100, 1, 0.60012, 1, 0.60012, 1, 1, 1, 0.5, 0, 0.10002, 0, 0, 1, 4, 1, 1, 0, 2, 0, 0, 0, 116, 0, 127, 23, 0, -4, 0 };
        check(&sf.presets[240].regions[1], &values);
    }

    // ============================================================
    //  Overdrive Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[241].regions[0], &values);
    }

    // ============================================================
    //  Clean Guitar
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 0, 59, 0, 0, 0, 0 };
        check(&sf.presets[242].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 14, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 84, 106, 0, 0, 0, 0 };
        check(&sf.presets[242].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 107, 127, 0, 0, 0, 0 };
        check(&sf.presets[242].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 14, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 0.80014, 0, 0.5, 0, 51, 0, 127, 60, 83, 0, 0, 0, 0 };
        check(&sf.presets[242].regions[3], &values);
    }

    // ============================================================
    //  Baritone Sax
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 2, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 4, 1, 0, 0, 0, 127, 112, 127, 5, 0, 6, 0 };
        check(&sf.presets[243].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 4, 1, 0, 0, 0, 127, 96, 111, 5, 0, 6, 0 };
        check(&sf.presets[243].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 1, 4, 1, 0, 0, 0, 127, 79, 95, 5, 0, 6, 0 };
        check(&sf.presets[243].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 3.0001, 1, 1, 4, 1, 0, 0, 0, 127, 62, 78, 5, 0, 6, 0 };
        check(&sf.presets[243].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 4.9991, 1, 1, 4, 1, 0, 0, 0, 127, 0, 61, 5, 0, 6, 0 };
        check(&sf.presets[243].regions[4], &values);
    }

    // ============================================================
    //  Howling Winds
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 10, 0, 0, 0 };
        check(&sf.presets[244].regions[0], &values);
    }

    // ============================================================
    //  Mystery Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[245].regions[0], &values);
    }

    // ============================================================
    //  Solar Wind
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[246].regions[0], &values);
    }

    // ============================================================
    //  Whistlin'
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[247].regions[0], &values);
    }

    // ============================================================
    //  Techno Bass
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 14, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[248].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 2.1398, 0, 0, 2500, 0, 0, 0, 0, 1, 1, 1, 1, 0.0099978, 0.0099978, 0.0099978, 0.029994, 85.8, 1, 0, 0, 0.0099978, 0.0099978, 0.0099978, 4, 100, 0.20004, 0, 0, 76, 127, 0, 127, 20, 0, 3, 0 };
        check(&sf.presets[248].regions[1], &values);
    }

    // ============================================================
    //  Ukulele
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 5, 0, 0, 0 };
        check(&sf.presets[249].regions[0], &values);
    }

    // ============================================================
    //  Glockenspiel
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.15003, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 98, 0, 60, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 98, 61, 83, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 98, 84, 104, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 98, 105, 127, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.7002, 0, 0, 0, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 99, 127, 0, 60, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.80014, 0, 0, 1000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 99, 127, 61, 83, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.90021, 0, 0, 2000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 99, 127, 84, 104, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[6], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 0, 7, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.60012, 0, 1, 0, 0, 99, 127, 105, 127, 5, 0, 0, 0 };
        check(&sf.presets[250].regions[7], &values);
    }

    // ============================================================
    //  Tubular Bells
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, 3, 0, 0, 0 };
        check(&sf.presets[251].regions[0], &values);
    }

    // ============================================================
    //  Guitar Harmonics
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[252].regions[0], &values);
    }

    // ============================================================
    //  Voice Oohs
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 3, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -7, 0, 0, 0 };
        check(&sf.presets[253].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.55, 0, 0, 0, 0, 3, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 0.0099978, 0.71988, 8, 0.30006, 0, 0, 0, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[253].regions[1], &values);
    }

    // ============================================================
    //  Charang
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 4.5002, 0, 0, 2604, 0, 14, 5, 0, 100.02, 0.60991, 1, 0.60991, 1, 1, 1, 0.5, -50, 26.249, 0, 0, 1, 33.34, 0.0099978, 0.11002, -86.5, 1, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[254].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, -255, 4.9991, 8, 0, 7200, 0, 14, 5, 0, 100.02, 0.60991, 1, 0.60991, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 0.0099978, 0, 0, 1, 0.80014, 0.0099978, 0.0099978, -96, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[254].regions[1], &values);
    }

    // ============================================================
    //  Space Voice
    // ============================================================
    {
        const values = [_]f64{ 0, 30, 0, 0.10002, 12, 0, 2000, 0, 50, 14, 0, 1, 0.60012, 0.0099978, 0.60012, 0.0099978, 0.0099978, 0.0099978, 31.215, 27.7, 51.774, 0, 0, 0.0099978, 0.5, 0.0099978, 100.02, 8.9, 38.297, 0, 0, 0, 127, 0, 127, 16, 0, 0, 0 };
        check(&sf.presets[255].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.0099978, 0, 0, 5000, 0, 24, 20, 0, 1, 1, 1, 0.80014, 0.0099978, 0.0099978, 0.0099978, 0.0099978, 0, 100.02, 0, 0, 0.0099978, 1.2002, 0.0099978, 79.986, 15, 44.683, 0, 0, 0, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[255].regions[1], &values);
    }

    // ============================================================
    //  Metal Pad
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 7, 0, 4000, 0, 24, 7, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.3501, 0, 1, 0, 0, 1, 1, 1, 12.773, 8, 2, 0, 0, 0, 127, 0, 127, 16, 0, 8, 0 };
        check(&sf.presets[256].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 7.5, 0, 7200, 0, 24, 7, 0, 1, 1, 2, 1, 0.0099978, 0.0099978, 0.0099978, 1, -68.8, 100.02, 0, 0, 1, 38.297, 0.0099978, 0.40007, -68, 12, 0, 0, 0, 127, 0, 127, 0, 0, 8, 0 };
        check(&sf.presets[256].regions[1], &values);
    }

    // ============================================================
    //  Ice Rain
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.41996, 5, 0, 3830, 0, 7, 21, 0, 0.0099978, 0.5, 1, 0.5, 0.0099978, 0.0099978, 0.0099978, 41.141, 40, 100.02, 0, 0, 0.0099978, 0.25, 0.0099978, 0.0099978, 0, 28.377, 0, 0, 67, 127, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[257].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.39003, 5, 0, 3400, 0, 7, 21, 0, 0.0099978, 0.5, 1, 0.5, 0.0099978, 0.0099978, 0.0099978, 41.141, 40, 100.02, 0, 0, 0.0099978, 0.25, 0.0099978, 0.0099978, 0, 28.377, 0, 0, 52, 66, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[257].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.39003, 5, 0, 3000, 0, 7, 21, 0, 0.0099978, 0.5, 1, 0.5, 0.0099978, 0.0099978, 0.0099978, 41.141, 40, 100.02, 0, 0, 0.0099978, 0.25, 0.0099978, 0.0099978, 0, 28.377, 0, 0, 0, 51, 0, 127, 7, 0, 0, 0 };
        check(&sf.presets[257].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 5, 50, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.8083, 1, 1, -13, 3.0001, 0, 0, 0, 57, 0, 127, 55, 31, 0, 0 };
        check(&sf.presets[257].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 5, 50, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.8083, 1, 1, -13, 3.0001, 0, 0, 58, 71, 0, 127, 55, 19, 0, 0 };
        check(&sf.presets[257].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 5, 50, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.8083, 1, 1, -13, 3.0001, 0, 0, 72, 86, 0, 127, 55, 7, 0, 0 };
        check(&sf.presets[257].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 100.02, 0, 0, 7200, 0, 5, 50, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 7.8083, 1, 1, -13, 3.0001, 0, 0, 87, 127, 0, 127, 55, -5, 0, 0 };
        check(&sf.presets[257].regions[6], &values);
    }

    // ============================================================
    //  Brightness
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 10.998, 0, 0, 2400, 0, 21, 14, 20, 0.0099978, 1, 1, 0.60012, 0.0099978, 0.0099978, 0.0099978, 0.30006, 100, 0.30006, 0, 0, 0.0099978, 0.079983, 0.0099978, 9.9982, 96, 39.993, 0, 0, 0, 113, 0, 127, 3, 0, 5, 0 };
        check(&sf.presets[258].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.050009, 0, 0, 4000, 0, 30, 14, -20, 1, 0.60012, 0.0099978, 0.7002, 0.0099978, 0.0099978, 0.0099978, 8, 100, 8, 0, 0, 0.0099978, 0.079983, 0.0099978, 14.998, 96, 4, 0, 0, 0, 127, 0, 127, 13, 0, 0, 0 };
        check(&sf.presets[258].regions[1], &values);
    }

    // ============================================================
    //  Echo Drops
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 21, 75, 0, 1, 0.60012, 1, 0.60012, 0.0099978, 13.478, 0.0099978, 3.5595, 0, 2, 0, 0, 100.02, 0.0099978, 0.0099978, 0.44008, 7, 2, 0, 0, 0, 127, 0, 127, 15, 0, 0, 0 };
        check(&sf.presets[259].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -4443, 0, 3.5, 35, 30, 1, 0.60012, 1, 0.60012, 1.6003, 1, 1, 1, -100, 0.059989, 0, 0, 1, 0.079983, 0.0099978, 1, 0, 2, 0, 0, 0, 127, 0, 127, 25, 0, 0, 0 };
        check(&sf.presets[259].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, -4443, 0, 3.5, 35, -30, 1, 0.60012, 1, 0.60012, 0.0099978, 1, 1, 1, -100, 0.20004, 0, 0, 0.0099978, 0.079983, 0.0099978, 1, 0, 3.0001, 0, 0, 0, 127, 0, 127, 25, 0, 0, 0 };
        check(&sf.presets[259].regions[2], &values);
    }

    // ============================================================
    //  Kalimba
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 103, 127, 0, 0, 0, 0 };
        check(&sf.presets[260].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.3501, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 76, 102, 0, 0, 0, 0 };
        check(&sf.presets[260].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 75, 0, 0, 0, 0 };
        check(&sf.presets[260].regions[2], &values);
    }

    // ============================================================
    //  Shenai
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[261].regions[0], &values);
    }

    // ============================================================
    //  Tinker Bell
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, -5, 0, 0, 0 };
        check(&sf.presets[262].regions[0], &values);
    }

    // ============================================================
    //  Agogo
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 101, 127, -5, 0, 0, 0 };
        check(&sf.presets[263].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.40007, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 66, 100, -5, 0, 0, 0 };
        check(&sf.presets[263].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 0.60012, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 0, 65, -5, 0, 0, 0 };
        check(&sf.presets[263].regions[2], &values);
    }

    // ============================================================
    //  Wood Block
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 102, 127, 0, 0, 0, 0 };
        check(&sf.presets[264].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 86, 101, 0, 0, 0, 0 };
        check(&sf.presets[264].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 71, 85, 0, 0, 0, 0 };
        check(&sf.presets[264].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.10002, 0, 0, -460, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 70, 0, 0, 0, 0 };
        check(&sf.presets[264].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 101, 13, 0, 0, 0 };
        check(&sf.presets[264].regions[4], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 102, 114, 9, 0, 0, 0 };
        check(&sf.presets[264].regions[5], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0.0099978, 1, 1, 0, 1, 0, 0, 0, 127, 115, 127, 0, 0, 0, 0 };
        check(&sf.presets[264].regions[6], &values);
    }

    // ============================================================
    //  Melodic Tom
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 113, 127, 3, 0, 0, 0 };
        check(&sf.presets[265].regions[0], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.30006, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.40007, 0, 0.40007, 0, 0, 0, 127, 96, 112, 3, 0, 0, 0 };
        check(&sf.presets[265].regions[1], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.25, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.15003, 0, 0.15003, 0, 0, 0, 127, 77, 95, 3, 0, 0, 0 };
        check(&sf.presets[265].regions[2], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.20004, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.10002, 0, 0.10002, 0, 0, 0, 127, 59, 76, 3, 0, 0, 0 };
        check(&sf.presets[265].regions[3], &values);
    }
    {
        const values = [_]f64{ 0, 0, 0, 0.15997, 0, 0, 0, 0, 0, 5, 0, 1, 0.60012, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0.069992, 0, 0.069992, 0, 0, 0, 127, 0, 58, 3, 0, 0, 0 };
        check(&sf.presets[265].regions[4], &values);
    }

    // ============================================================
    //  Reverse Cymbal
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 3000, 0, 0, 3, 0, 1, 1, 1, 1, 1, 0.7002, 1, 1, 0, 100.02, 0, 0, 1, 0.5, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[266].regions[0], &values);
    }

    // ============================================================
    //  Fret Noise
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[267].regions[0], &values);
    }

    // ============================================================
    //  Breath Noise
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 0, 5, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[268].regions[0], &values);
    }

    // ============================================================
    //  Helicopter
    // ============================================================
    {
        const values = [_]f64{ 0, 0, 0, 1, 0, 0, 0, 0, 7, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 3.5004, 0, 0, 0, 127, 0, 127, 0, 0, 0, 0 };
        check(&sf.presets[269].regions[0], &values);
    }
}

// version 6

state("Endacopia")
{
    uint room: 0x2F8E70;
    uint credits: 0x00333F8C;
    uint frameCounter: 0x00333FF2;

    uint handsSense: 0x00325490, 0xC, 108;
    uint eyesSense: 0x00325490, 0xC, 112;
    uint mouthSense: 0x00325490, 0xC, 116;

    uint ozzieDead: 0x00325490, 0xC, 336;
    uint aiDead: 0x00325490, 0xC, 396;
    uint trapezistDead: 0x00325490, 0xC, 244;

    short hasSkateboard: 0x00309F54, 0x7C;
    short hasTelescope: 0x00309F54, 0x82;
    short hasVcr: 0x00309F54, 0x8C;
    short hasMap: 0x00309F54, 0xB2;
    short hasTickets: 0x00309F54, 0x96;
    short hasWrench: 0x00309F54, 0xA2;
    short hasToySaw: 0x00309F54, 0xC2;
    short hasRealSaw: 0x00309F54, 0xC4;
}

startup
{
    Action ResetVars = () => {
        vars.stage = 0;
        vars.currentFrame = 0;
        vars.accumulatedFrames = 0;
        vars.lastFrames = 0; // keeps track of the frame count across all re-launches of the game
        vars.running = false;
    };
    vars.ResetVars = ResetVars;

    settings.Add("endingA", true);
    ResetVars();
}

onReset
{
    vars.ResetVars();
}

start
{
    if (vars.stage == 0 && old.room != current.room && old.room == 16)
    {
        return true;
    }
}

update
{
    if (old.room != current.room && old.room == 16)
    {
        vars.startFrame = current.frameCounter;
        vars.running = true;
    }
    if (timer.CurrentPhase != TimerPhase.Running || !vars.running) return true;
    vars.accumulatedFrames = vars.lastFrames + current.frameCounter - vars.startFrame;
}

gameTime
{
    return TimeSpan.FromSeconds(vars.accumulatedFrames / 40.0);
}

isLoading
{
    return true;
}

split
{
    switch ((int)vars.stage)
    {
    case 0: // prologue
        if (old.room == 3 && current.room == 124)
        {
            print("prologue done");
            return true;
        }
        break;
    case 1: // mouth
        if (current.mouthSense != 0)
        {
            print("mouth done");
            return true;
        }
        break;
    case 2: // hands
        if (current.handsSense != 0)
        {
            print("hands done");
            return true;
        }
        break;
    case 3: // skateboard
        if (current.hasSkateboard != 0)
        {
            print("skateboard done");
            return true;
        }
        break;
    case 4: // eyes
        if (current.eyesSense != 0)
        {
            print("eyes done");
            return true;
        }
        break;
    case 5: // telescope
        if (current.hasTelescope != 0)
        {
            // this should only trigger once because of the stage check.
            print("telescope done");
            return true;
        }
        break;
    case 6: // VCR
        if (current.hasVcr != 0)
        {
            print("vcr done");
            return true;
        }
        break;
    case 7: // case closed
        if (current.ozzieDead != 0)
        {
            print("case closed done");
            return true;
        }
        break;
    case 8: // map
        if (current.hasMap != 0)
        {
            print("map done");
            return true;
        }
        break;
    case 9: // tickets
        if (current.hasTickets != 0)
        {
            print("tickets done");
            return true;
        }
        break;
    case 10: // wrench
        if (current.hasWrench != 0)
        {
            print("wrench done");
            return true;
        }
        break;
    case 11: // short circuit
        if (current.aiDead != 0)
        {
            print("short circuit done");
            return true;
        }
        break;
    case 12: // saw
        bool currentHasAnySaw = current.hasToySaw != 0 || current.hasRealSaw != 0;
        if (currentHasAnySaw)
        {
            print("saw done");
            return true;
        }
        break;
    case 13: // cut the act
        if (current.trapezistDead != 0)
        {
            print("cut the act done");
            return true;
        }
        break;
    case 14: // henry (if ending A)
        if (!settings["endingA"])
        {
            vars.stage++;
            goto case 15;
        }
        else if (current.room != old.room && old.room == 122)
        {
            return current.room == 109;
        }
        break;
    case 15: // gg
        if (current.credits != 0 && current.room != 62)
        {
            print("gg!");
            return true;
        }
        break;
    }
}

onSplit
{
    vars.stage++;
}

exit
{
    vars.lastFrames = vars.accumulatedFrames;
    vars.running = false;
}

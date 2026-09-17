# LiveSplit Autosplitter for Endacopia v1.08.

Splits for Ending A and B included. Uncheck **Ending A** in settings if running Ending B.

## Timer options

| Option | Description |
| --- | --- |
| Real Time | Autostart only; once started, timer is not affected. |
| Game Time, internal time **unchecked** | Autostart + autopause when the game closes. |
| Game Time, internal time **checked** | Autostart + autopause + loading/lag time removal (uses the game's internal frame counter). |

- Autostart starts the timer automatically upon pressing **New**/**Continue** on the title screen.
- Autopause pauses the timer when the game closes and resumes upon New/Continue, but still uses LiveSplit's timer.
- Checking **Use internal game time** will force the timer to use the game's internal frame counter. This removes loadtimes, lag, time spent outside the game's window, etc.

Autosplitting works in all modes.

#pragma once

// Home row mod tuning; see docs/tap_hold.md "Configuring Home Row Mods".
#define TAPPING_TERM 250  // Hold a home row key longer than this to get the modifier.
#define PERMISSIVE_HOLD   // Pressing and releasing another key while holding selects the modifier.
#define CHORDAL_HOLD      // Modifiers only trigger with a key on the opposite hand.
#define FLOW_TAP_TERM 150 // While typing fast, home row keys always produce letters.
#define SPECULATIVE_HOLD  // Shift/Ctrl apply immediately, so Shift+click has no lag.

// Six layers (Mac, Win, three Fn, symbols) so VIA keeps the symbol layer.
#undef DYNAMIC_KEYMAP_LAYER_COUNT
#define DYNAMIC_KEYMAP_LAYER_COUNT 6
// The extra layer needs more saved-keymap storage than the 2 KB default.
// Keychron's info.json meant to set 4096 but misspells the key ("wear_levling").
#define WEAR_LEVELING_BACKING_SIZE 4096

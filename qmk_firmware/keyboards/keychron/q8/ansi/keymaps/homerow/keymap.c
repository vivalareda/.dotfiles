/* Copyright 2021 @ Keychron (https://www.keychron.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include QMK_KEYBOARD_H

// clang-format off

enum layers {
    MAC_BASE,
    WIN_BASE,
    _FN1,
    _FN2,
    _FN3,
    _SYM
};

#define KC_TASK LGUI(KC_TAB)
#define KC_FLXP LGUI(KC_E)

// Home row mods: tap for the letter, hold for the modifier.
// Order from the outside in: Cmd, Option, Shift, Ctrl (mirrored on both hands).
// J and K use the right-side Ctrl/Shift so the arrow overrides below can tell
// them apart from the left-hand Ctrl that triggers the arrows.
#define HM_A    LGUI_T(KC_A)
#define HM_S    LALT_T(KC_S)
#define HM_D    LSFT_T(KC_D)
#define HM_F    LCTL_T(KC_F)
#define HM_J    RCTL_T(KC_J)
#define HM_K    RSFT_T(KC_K)
#define HM_L    LALT_T(KC_L)
#define HM_SCLN LGUI_T(KC_SCLN)

// Tap for Tab, hold for the symbol layer.
#define SYM_TAB LT(_SYM, KC_TAB)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [MAC_BASE] = LAYOUT_ansi_69(
        KC_ESC,  KC_1,     KC_2,     KC_3,    KC_4,    KC_5,    KC_6,     KC_7,    KC_8,    KC_9,    KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,          KC_INS,
        SYM_TAB, KC_Q,     KC_W,     KC_E,    KC_R,    KC_T,    KC_Y,     KC_U,    KC_I,    KC_O,    KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,          KC_DEL,
        KC_CAPS, HM_A,     HM_S,     HM_D,    HM_F,    KC_G,              KC_H,    HM_J,    HM_K,    HM_L,     HM_SCLN,  KC_QUOT,  KC_ENT,           KC_HOME,
        KC_LSFT,           KC_Z,     KC_X,    KC_C,    KC_V,    KC_B,     KC_B,    KC_N,    KC_M,    KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT, KC_UP,
        KC_LCTL, KC_LOPT,  KC_LCMD,           KC_SPC,           MO(_FN1), MO(_FN3),         KC_SPC,            KC_RCMD,            KC_LEFT, KC_DOWN, KC_RGHT),

    [WIN_BASE] = LAYOUT_ansi_69(
        KC_ESC,  KC_1,     KC_2,     KC_3,    KC_4,    KC_5,    KC_6,     KC_7,    KC_8,    KC_9,    KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,          KC_INS,
        SYM_TAB, KC_Q,     KC_W,     KC_E,    KC_R,    KC_T,    KC_Y,     KC_U,    KC_I,    KC_O,    KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,          KC_DEL,
        KC_CAPS, HM_A,     HM_S,     HM_D,    HM_F,    KC_G,              KC_H,    HM_J,    HM_K,    HM_L,     HM_SCLN,  KC_QUOT,  KC_ENT,           KC_HOME,
        KC_LSFT,           KC_Z,     KC_X,    KC_C,    KC_V,    KC_B,     KC_B,    KC_N,    KC_M,    KC_COMM,  KC_DOT,   KC_SLSH,  KC_RSFT, KC_UP,
        KC_LCTL, KC_LWIN,  KC_LALT,           KC_SPC,           MO(_FN2), MO(_FN3),         KC_SPC,            KC_RALT,            KC_LEFT, KC_DOWN, KC_RGHT),

    [_FN1] = LAYOUT_ansi_69(
        KC_GRV,  KC_BRID,  KC_BRIU,  KC_NO,   KC_NO,   RM_VALD, RM_VALU,  KC_MPRV, KC_MPLY, KC_MNXT, KC_MUTE,  KC_VOLD,  KC_VOLU,  _______,          _______,
        RM_TOGG, RM_NEXT,  RM_VALU,  RM_HUEU, RM_SATU, RM_SPDU, _______,  _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______, RM_PREV,  RM_VALD,  RM_HUED, RM_SATD, RM_SPDD,           _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______,           _______,  _______, _______, _______, _______,  _______, NK_TOGG, _______, _______,  _______,  _______,  _______, _______,
        _______, _______,  _______,           _______,          _______,  _______,          _______,           _______,            _______, _______, _______),

    [_FN2] = LAYOUT_ansi_69(
        KC_GRV,  KC_BRID,  KC_BRIU,  KC_TASK, KC_FLXP, RM_VALD, RM_VALU,  KC_MPRV, KC_MPLY, KC_MNXT, KC_MUTE,  KC_VOLD,  KC_VOLU,  _______,          _______,
        RM_TOGG, RM_NEXT,  RM_VALU,  RM_HUEU, RM_SATU, RM_SPDU, _______,  _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______, RM_PREV,  RM_VALD,  RM_HUED, RM_SATD, RM_SPDD,           _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______,           _______,  _______, _______, _______, _______,  _______, NK_TOGG, _______, _______,  _______,  _______,  _______, _______,
        _______, _______,  _______,           _______,          _______,  _______,          _______,           _______,            _______, _______, _______),

    [_FN3] = LAYOUT_ansi_69(
        KC_TILD, KC_F1,    KC_F2,    KC_F3,   KC_F4,   KC_F5,   KC_F6,    KC_F7,   KC_F8,   KC_F9,   KC_F10,   KC_F11,   KC_F12,   _______,          _______,
        RM_TOGG, RM_NEXT,  RM_VALU,  RM_HUEU, RM_SATU, RM_SPDU, _______,  _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______, RM_PREV,  RM_VALD,  RM_HUED, RM_SATD, RM_SPDD,           _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______,           _______,  _______, _______, _______, _______,  _______, _______, _______, _______,  _______,  _______,  _______, _______,
        _______, _______,  _______,           _______,          _______,  _______,          _______,           _______,            _______, _______, _______),

    // Brackets and quotes on the right hand while Tab is held.
    [_SYM] = LAYOUT_ansi_69(
        _______, _______,  _______,  _______, _______, _______, _______,  _______, _______, _______, _______,  _______,  _______,  _______,          _______,
        _______, _______,  _______,  _______, _______, _______, _______,  KC_LCBR, KC_RCBR, KC_TILD, _______,  _______,  _______,  _______,          _______,
        _______, _______,  _______,  _______, _______, _______,           KC_GRV,  KC_LPRN, KC_RPRN, KC_DQUO,  _______,  _______,  _______,          _______,
        _______,           _______,  _______, _______, _______, _______,  _______, KC_LBRC, KC_RBRC, _______,  _______,  _______,  _______, _______,
        _______, _______,  _______,           _______,          _______,  _______,          _______,           _______,            _______, _______, _______)
};

// Which hand each key belongs to, following the Alice split. Chordal Hold uses
// this to only allow a home row modifier together with a key on the other hand.
// '*' (spacebars and Fn keys) may combine with either hand.
const char chordal_hold_layout[MATRIX_ROWS][MATRIX_COLS] PROGMEM = LAYOUT_ansi_69(
    'L', 'L', 'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R', 'R', 'R',      'R',
    'L', 'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R',      'R',
    'L', 'L', 'L', 'L', 'L', 'L',       'R', 'R', 'R', 'R', 'R', 'R', 'R',      'R',
    'L',      'L', 'L', 'L', 'L', 'L',  'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R',
    'L', 'L', 'L',      '*',      '*', '*',      '*',      'R',      'R', 'R', 'R'
);

// Left Ctrl (home row F or the Ctrl key) + J/K sends Down/Up, vim style.
// Ctrl is hidden from the host so macOS sees a plain arrow; K's own right Shift
// is hidden too, while left Shift (D) still passes through for selecting text.
static const key_override_t ctrl_j_down = {
    .trigger           = HM_J,
    .trigger_mods      = MOD_BIT(KC_LCTL),
    .layers            = ~0,
    .negative_mod_mask = 0,
    .suppressed_mods   = MOD_MASK_CTRL,
    .replacement       = KC_DOWN,
    .options           = ko_option_activation_trigger_down | ko_option_no_reregister_trigger,
    .enabled           = NULL,
};

static const key_override_t ctrl_k_up = {
    .trigger           = HM_K,
    .trigger_mods      = MOD_BIT(KC_LCTL),
    .layers            = ~0,
    .negative_mod_mask = 0,
    .suppressed_mods   = MOD_MASK_CTRL | MOD_BIT(KC_RSFT),
    .replacement       = KC_UP,
    .options           = ko_option_activation_trigger_down | ko_option_no_reregister_trigger,
    .enabled           = NULL,
};

const key_override_t *key_overrides[] = {
    &ctrl_j_down,
    &ctrl_k_up,
};
